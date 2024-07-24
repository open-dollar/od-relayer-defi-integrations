// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {IChainlinkRelayer} from '@interfaces/oracles/IChainlinkRelayer.sol';
import {IOracleRegistry} from '@interfaces/oracles/IOracleRegistry.sol';
import {Authorizable} from '@contracts/utils/Authorizable.sol';

/**
 * @title  OracleRegistry
 * @author opendollar
 * @notice This contracts holds a registry of all the deployed oracles denominated in usd.
 * all oracles should be denominated in USD.
 */
contract OracleRegistry is Authorizable, IOracleRegistry {
  //token address => chainlink oracle (denominated in usd) for said token
  mapping(address => IBaseOracle) public usdDenominatedFeed;

  constructor(address[] memory _tokens, IBaseOracle[] memory _oracles) Authorizable(msg.sender) {
    addOracles(_tokens, _oracles);
  }

  modifier isSupportedToken(address _token) {
    require(address(usdDenominatedFeed[_token]) != address(0), 'ORACLE REGISTRY: TOKEN NOT SUPPORTED');
    _;
  }

  function addOracles(address[] memory _tokens, IBaseOracle[] memory _oracles) public isAuthorized {
    require(_tokens.length == _oracles.length, 'ORACLE REGISTRY: LENGTH MISMATCH');
    for (uint256 i; i < _tokens.length; i++) {
      addOracle(_tokens[i], _oracles[i]);
    }
  }

  function addOracle(address _token, IBaseOracle _denominatedOracle) public isAuthorized {
    require(_isValidOracle(address(_denominatedOracle)), 'ORACLE REGISTRY: INVALID ORACLE');
    require(_isValidToken(_token), 'ORACLE REGISTRY: INVALID TOKEN');
    usdDenominatedFeed[_token] = _denominatedOracle;
  }

  function clearOracle(address _token) public isAuthorized {
    delete usdDenominatedFeed[_token];
  }

  function getResultWithValidity(address _token)
    public
    view
    isSupportedToken(_token)
    returns (uint256 _result, bool _validity)
  {
    (_result, _validity) = usdDenominatedFeed[_token].getResultWithValidity();
  }

  function read(address _token) public view isSupportedToken(_token) returns (uint256 _result) {
    _result = usdDenominatedFeed[_token].read();
  }

  function isSupported(address _token) public view returns (bool) {
    return address(usdDenominatedFeed[_token]) != address(0);
  }

  function _isValidOracle(address _oracle) internal view returns (bool) {
    (, bytes memory _data) = _oracle.staticcall(abi.encodeWithSelector(IBaseOracle.symbol.selector));
    return _data.length != 0;
  }

  function _isValidToken(address _token) internal view returns (bool) {
    (, bytes memory _data) = _token.staticcall(abi.encodeWithSignature('decimals()'));
    return _data.length != 0;
  }
}
