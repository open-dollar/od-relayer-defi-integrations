// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';

interface IOracleRegistry {
  event OracleAdded(address token, address denominatedChainlinkFeed);
  event OracleCleared(address token);

  function addOracle(address token, IBaseOracle _denominatedOracle) external;
  function denominatedChainlinkFeed(address token) external returns (IBaseOracle);
  function clearOracle(address token) external;
  function getResultWithValidity(address token) external returns (uint256 _result, bool _validity);
  function read(address token) external returns (uint256);
}
