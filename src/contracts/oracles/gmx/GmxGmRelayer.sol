// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {OracleUtils} from '@gmx/contracts/oracle/OracleUtils.sol';
import {IOracleProvider} from '@gmx/contracts/oracle/IOracleProvider.sol';
import {GmxPrice} from '@libraries/gmx/GmxPrice.sol';
import {IGmxDataStore} from '@interfaces/oracles/gmx/IGmxDataStore.sol';

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
  uint256 public constant Gmx_DECIMAL_ADJUSTMENT = 10 ** 6;
  uint256 public constant RETURN_DECIMAL_ADJUSTMENT = 10 ** 12;
  uint256 public constant FEE_FACTOR_DECIMAL_ADJUSTMENT = 10 ** 26;

  bytes32 public constant MAX_PNL_FACTOR_FOR_DEPOSITS_KEY = keccak256(abi.encode('MAX_PNL_FACTOR_FOR_DEPOSITS')); // solhint-disable-line max-line-length
  bytes32 public constant SWAP_FEE_FACTOR_KEY = keccak256(abi.encode('SWAP_FEE_FACTOR'));
  bytes32 public constant SWAP_FEE_RECEIVER_FACTOR_KEY = keccak256(abi.encode('SWAP_FEE_RECEIVER_FACTOR'));

  address marketToken;
  IGmxDataStore dataStore;

  constructor(address _marketToken, address _gmxReader, address _dataStore) {
    marketToken = _marketToken;
    dataStore = IGmxDataStore(_dataStore);
  }

  function getResultWithValidity() external view returns (uint256 _result, bool _validity) {
    _result;
    _validity = true;
  }

  function read() external view returns (uint256 _value) {
    _value;
  }
}
