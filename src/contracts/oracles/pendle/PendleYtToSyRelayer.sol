// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import '@interfaces/oracles/pendle/IPOracle.sol';
import '@interfaces/oracles/pendle/IPMarket.sol';

/**
 * @title  PendleRelayer
 * @notice This contracts transforms a Pendle TWAP price feed into a standard IBaseOracle feed
 *
 */
contract PendleYtToSyRelayer {
  IStandardizedYield public SY;
  IPYieldToken public YT;

  IPMarket public market;
  IPOracle public oracle;

  uint32 public twapDuration;
  string public symbol;

  constructor(address _market, address _oracle, uint32 _twapDuration) {
    require(_market != address(0) && _oracle != address(0), 'Invalid address');
    require(_twapDuration != 0, 'Invalid TWAP duration');

    market = IPMarket(_market);
    oracle = IPOracle(_oracle);
    twapDuration = _twapDuration;

    (SY,, YT) = market.readTokens();

    symbol = string(abi.encodePacked(YT.symbol(), ' / ', SY.symbol()));
    // test if oracle is ready
    (bool increaseCardinalityRequired,, bool oldestObservationSatisfied) = oracle.getOracleState(_market, _twapDuration);
    // It's required to call IPMarket(market).increaseObservationsCardinalityNext(cardinalityRequired) and wait
    // for at least the twapDuration, to allow data population.
    // also
    // It's necessary to wait for at least the twapDuration, to allow data population.
    require(!increaseCardinalityRequired && oldestObservationSatisfied, 'Oracle not ready');
  }

  function getResultWithValidity() external view returns (uint256 _result, bool _validity) {
    _result = oracle.getYtToSyRate(address(market), twapDuration);
    _validity = true;
  }

  function read() external view returns (uint256 _value) {
    _value = oracle.getYtToSyRate(address(market), twapDuration);
  }
}
