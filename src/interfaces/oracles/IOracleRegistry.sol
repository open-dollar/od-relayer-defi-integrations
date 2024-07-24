// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';

interface IOracleRegistry {
  event OracleAdded(address _token, address denominatedChainlinkFeed);
  event OracleCleared(address _token);

  function usdDenominatedFeed(address _token) external returns (IBaseOracle);
  function addOracle(address _token, IBaseOracle _denominatedOracle) external;
  function addOracles(address[] memory _token, IBaseOracle[] memory _denominatedOracle) external;
  function clearOracle(address _token) external;
  function getResultWithValidity(address _token) external returns (uint256 _result, bool _validity);
  function read(address _token) external returns (uint256 _result);
  function isSupported(address _token) external view returns (bool);
}
