// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {IChainlinkRelayer} from '@interfaces/oracles/IChainlinkRelayer.sol';
import {IChainlinkOracleRegistry} from '@interfaces/oracles/IChainlinkOracleRegistry.sol';
import {Authorizable} from '@contracts/utils/Authorizable.sol';

/**
 * @title  ChainlinkOracleRegistry
 * @notice This contracts holds a registry of all the deployed chainlink denominated oracles.
 * all oracles should be denominated in USD.
 */
contract ChainlinkOracleRegistry is Authorizable, IChainlinkOracleRegistry {
  //token address => chainlink oracle (denominated in usd) for said token
  mapping(address => IBaseOracle) public usdDenominatedChainlinkFeed;

  constructor() Authorizable(msg.sender) {}

  modifier isSupportedToken(address _token) {
    require(address(usdDenominatedChainlinkFeed[_token]) != address(0), 'ORACLE REGISTRY: TOKEN NOT SUPPORTED');
    _;
  }

  function addOracle(address _token, IBaseOracle _denominatedOracle) public isAuthorized {
    require(
      keccak256(abi.encode(IChainlinkRelayer(address(_denominatedOracle)).symbol())) != keccak256(abi.encode('')),
      'ORACLE REGISTRY: INVALID ORACLE'
    );
    usdDenominatedChainlinkFeed[_token] = _denominatedOracle;
  }

  function clearOracle(address _token) public isAuthorized {
    delete usdDenominatedChainlinkFeed[_token];
  }

  function getResultWithValidity(address _token)
    public
    view
    isSupportedToken(_token)
    returns (uint256 _result, bool _validity)
  {
    (_result, _validity) = usdDenominatedChainlinkFeed[_token].getResultWithValidity();
  }

  function read(address _token) public view isSupportedToken(_token) returns (uint256 _result) {
    _result = usdDenominatedChainlinkFeed[_token].read();
  }
}
