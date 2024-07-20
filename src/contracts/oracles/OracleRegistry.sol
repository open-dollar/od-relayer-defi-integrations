// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {IOracleRegistry} from '@interfaces/oracles/IOracleRegistry.sol';
import {Authorizable} from '@contracts/utils/Authorizable.sol';

contract OracleRegistry is Authorizable, IOracleRegistry {
  //token address => chainlink oracle (denominated in usd) for said token
  mapping(address => IBaseOracle) public denominatedChainlinkFeed;

  constructor() Authorizable(msg.sender) {}

  function addOracle(address token, IBaseOracle _denominatedOracle) public isAuthorized {
    denominatedChainlinkFeed[token] = _denominatedOracle;
  }

  function clearOracle(address token) public isAuthorized {
    delete denominatedChainlinkFeed[token];
  }

  function getResultWithValidity(address token) public returns (uint256 _result, bool _validity) {}
  function read(address token) public returns (uint256) {}
}
