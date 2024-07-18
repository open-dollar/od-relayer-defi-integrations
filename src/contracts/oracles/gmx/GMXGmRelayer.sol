// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

/**
 * @title  PendleRelayer
 * @notice This contracts transforms a Pendle TWAP price feed into a standard IBaseOracle feed
 *
 */
contract GMXGmRelayer {
  string public symbol;

  constructor(address _market, address _oracle, uint32 _twapDuration) {}

  function getResultWithValidity() external view returns (uint256 _result, bool _validity) {
    _result;
    _validity = true;
  }

  function read() external view returns (uint256 _value) {
    _value;
  }
}
