// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {IPOracle} from '@interfaces/oracles/pendle/IPOracle.sol';
import {IPMarket, IStandardizedYield, IPPrincipalToken} from '@interfaces/oracles/pendle/IPMarket.sol';
import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';

/**
 * @title  PendleRelayer
 * @notice This contracts transforms a Pendle TWAP price feed into a standard IBaseOracle feed
 *
 */
contract PendlePtToSyRelayer is IBaseOracle {
  IStandardizedYield public SY;
  IPPrincipalToken public PT;

  IPMarket public market;
  IPOracle public oracle;

  uint32 public twapDuration;
  string public symbol;

  /**
   * @dev at the end of the constructor we must call IPMarket(market).getOracleState(_market, _twapDuration) and check that
   * increaseObservationsCardinalityRequired is false.  If not we must wait for at least the twapDuration,
   * to allow data population.
   * @param _market the address of the pendle market we want to get the prices from
   * @param _oracle the pendle oracle contract
   * @param _twapDuration the desired TWAP duration in seconds (recommended 900s);
   */
  constructor(address _market, address _oracle, uint32 _twapDuration) {
    require(_market != address(0) && _oracle != address(0), 'Invalid address');
    require(_twapDuration != uint32(0), 'Invalid TWAP duration');

    market = IPMarket(_market);
    oracle = IPOracle(_oracle);
    twapDuration = _twapDuration;

    (SY, PT,) = market.readTokens();

    symbol = string(abi.encodePacked(PT.symbol(), ' / ', SY.symbol()));

    (bool increaseCardinalityRequired,, bool oldestObservationSatisfied) = oracle.getOracleState(_market, _twapDuration);

    require(!increaseCardinalityRequired && oldestObservationSatisfied, 'Oracle not ready');
  }

  function getResultWithValidity() external view returns (uint256 _result, bool _validity) {
    _result = oracle.getPtToSyRate(address(market), twapDuration);
    _validity = true;
  }

  function read() external view returns (uint256 _value) {
    _value = oracle.getPtToSyRate(address(market), twapDuration);
  }
}
