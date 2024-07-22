// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';

interface IChainlinkOracleRegistry {
  event OracleAdded(address _token, address denominatedChainlinkFeed);
  event OracleCleared(address _token);

  function usdDenominatedChainlinkFeed(address _token) external returns (IBaseOracle);
  function addOracle(address _token, IBaseOracle _denominatedOracle) external;
  function clearOracle(address _token) external;
  function getResultWithValidity(address _token) external returns (uint256 _result, bool _validity);
  function read(address _token) external returns (uint256 _result);
}
