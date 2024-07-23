// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {OracleUtils} from '@gmx/contracts/oracle/OracleUtils.sol';
import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {IOracleProvider} from '@gmx/contracts/oracle/IOracleProvider.sol';
import {GmxPrice} from '@libraries/gmx/GmxPrice.sol';
import {GmxMarket} from '@libraries/gmx/GmxMarket.sol';
import {IGmxDataStore} from '@interfaces/oracles/gmx/IGmxDataStore.sol';
import {IGmxReader} from '@interfaces/oracles/gmx/IGmxReader.sol';

/**
 * @title  GmxGmRelayer
 * @notice This contracts transforms a Gmx GM oracle into a standard IBaseOracle feed
 *
 */
contract GmxGmRelayer {
  string public symbol;

  // ============================ Constants ============================

  /// @dev All of the GM tokens listed have, at-worst, 25 bp for the price deviation
  uint256 public constant PRICE_DEVIATION_BP = 25;
  uint256 public constant BASIS_POINTS = 10_000;
  uint256 public constant SUPPLY_CAP_USAGE_NUMERATOR = 5;
  uint256 public constant SUPPLY_CAP_USAGE_DENOMINATOR = 100;
  uint256 public constant GMX_DECIMAL_ADJUSTMENT = 10 ** 6;
  uint256 public constant RETURN_DECIMAL_ADJUSTMENT = 10 ** 12;
  uint256 public constant FEE_FACTOR_DECIMAL_ADJUSTMENT = 10 ** 26;
  uint256 public constant FEE_BP_FOR_MARKET_TOKEN = 10 ** 26;

  bytes32 public constant MAX_PNL_FACTOR_FOR_DEPOSITS_KEY = keccak256(abi.encode('MAX_PNL_FACTOR_FOR_DEPOSITS')); // solhint-disable-line max-line-length
  bytes32 public constant SWAP_FEE_FACTOR_KEY = keccak256(abi.encode('SWAP_FEE_FACTOR'));
  bytes32 public constant SWAP_FEE_RECEIVER_FACTOR_KEY = keccak256(abi.encode('SWAP_FEE_RECEIVER_FACTOR'));

  address public marketToken;
  IGmxDataStore public dataStore;
  IGmxReader public reader;
  IBaseOracle public indexTokenOracle;
  IBaseOracle public longTokenOracle;
  IBaseOracle public shortTokenOracle;

  constructor(
    address _marketToken,
    address _gmxReader,
    address _dataStore,
    address _indexTokenOracle,
    address _longTokenOracle,
    address _shortTokenOracle
  ) {
    marketToken = _marketToken;
    dataStore = IGmxDataStore(_dataStore);
    reader = IGmxReader(_gmxReader);
    indexTokenOracle = IBaseOracle(_indexTokenOracle);
    longTokenOracle = IBaseOracle(_longTokenOracle);
    shortTokenOracle = IBaseOracle(_shortTokenOracle);
  }

  function getResultWithValidity() external view returns (uint256 _result, bool _validity) {
    _result = _getCurrentPrice();
    _validity = true;
  }

  function read() external view returns (uint256 _value) {
    _value = _getCurrentPrice();
  }

  function _getCurrentPrice() internal view returns (uint256) {
    GmxMarket.MarketProps memory marketProps = reader.getMarket(dataStore, marketToken);

    (uint256 longTokenPrice,) = longTokenOracle.getResultWithValidity();

    GmxPrice.PriceProps memory longTokenPriceProps = GmxPrice.PriceProps({
      min: _adjustDownForBasisPoints(longTokenPrice, PRICE_DEVIATION_BP) / GMX_DECIMAL_ADJUSTMENT,
      max: _adjustUpForBasisPoints(longTokenPrice, PRICE_DEVIATION_BP) / GMX_DECIMAL_ADJUSTMENT
    });

    (uint256 shortTokenPrice,) = shortTokenOracle.getResultWithValidity();
    GmxPrice.PriceProps memory shortTokenPriceProps = GmxPrice.PriceProps({
      min: _adjustDownForBasisPoints(shortTokenPrice, PRICE_DEVIATION_BP) / GMX_DECIMAL_ADJUSTMENT,
      max: _adjustUpForBasisPoints(shortTokenPrice, PRICE_DEVIATION_BP) / GMX_DECIMAL_ADJUSTMENT
    });

    uint256 gmPrice = _getGmTokenPrice(marketProps, longTokenPriceProps, shortTokenPriceProps);

    return _adjustDownForBasisPoints(gmPrice, getFeeBpByMarketToken(marketToken));
  }

  function _getGmTokenPrice(
    GmxMarket.MarketProps memory _marketProps,
    GmxPrice.PriceProps memory _longTokenPriceProps,
    GmxPrice.PriceProps memory _shortTokenPriceProps
  ) internal view returns (uint256) {
    (uint256 indexTokenPrice,) = indexTokenOracle.getResultWithValidity();

    // Dolomite returns price as 36 decimals - token decimals
    // GMX expects 30 decimals - token decimals so we divide by 10 ** 6
    GmxPrice.PriceProps memory indexTokenPriceProps = GmxPrice.PriceProps({
      min: _adjustDownForBasisPoints(indexTokenPrice, PRICE_DEVIATION_BP) / GMX_DECIMAL_ADJUSTMENT,
      max: _adjustUpForBasisPoints(indexTokenPrice, PRICE_DEVIATION_BP) / GMX_DECIMAL_ADJUSTMENT
    });

    (int256 value,) = reader.getMarketTokenPrice(
      dataStore,
      _marketProps,
      indexTokenPriceProps,
      _longTokenPriceProps,
      _shortTokenPriceProps,
      MAX_PNL_FACTOR_FOR_DEPOSITS_KEY,
      /* _maximize = */
      false
    );

    require(value > 0, 'Invalid oracle response');

    // GMX returns the price in 30 decimals. We convert to (36 - GM token decimals == 18) for Dolomite's system
    return uint256(value) / RETURN_DECIMAL_ADJUSTMENT;
  }

  function _adjustDownForBasisPoints(uint256 _value, uint256 _basisPoints) internal pure returns (uint256) {
    return _value - (_value * _basisPoints / BASIS_POINTS);
  }

  function _adjustUpForBasisPoints(uint256 _value, uint256 _basisPoints) internal pure returns (uint256) {
    return _value + (_value * _basisPoints / BASIS_POINTS);
  }

  function _swapFeeFactorKey(address _marketToken, bool _forPositiveImpact) private pure returns (bytes32) {
    return keccak256(abi.encode(SWAP_FEE_FACTOR_KEY, _marketToken, _forPositiveImpact));
  }

  function getFeeBpByMarketToken(address _gmToken) public view returns (uint256) {
    bytes32 key = _swapFeeFactorKey(_gmToken, /* _forPositiveImpact = */ false);
    return dataStore.getUint(key) / FEE_FACTOR_DECIMAL_ADJUSTMENT;
  }
}
