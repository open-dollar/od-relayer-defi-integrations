// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {ChainlinkRelayerChild} from '@contracts/factories/ChainlinkRelayerChild.sol';
import {ChainlinkRelayerChildWithL2Validity} from '@contracts/factories/ChainlinkRelayerChildWithL2Validity.sol';
import {Authorizable} from '@contracts/utils/Authorizable.sol';
import {IChainlinkRelayerFactory} from '@interfaces/factories/IChainlinkRelayerFactory.sol';

contract ChainlinkRelayerFactory is Authorizable, IChainlinkRelayerFactory {
  uint256 public relayerId;
  uint256 public relayerWithL2ValidityId;

  // --- Data ---
  mapping(uint256 => address) public relayerById;
  mapping(uint256 => address) public relayerWithL2ValidityById;

  // --- Init ---
  constructor() Authorizable(msg.sender) {}

  // --- Methods ---

  /// @inheritdoc IChainlinkRelayerFactory
  function deployChainlinkRelayer(
    address _aggregator,
    uint256 _staleThreshold
  ) external isAuthorized returns (IBaseOracle _chainlinkRelayer) {
    _chainlinkRelayer = IBaseOracle(address(new ChainlinkRelayerChild(_aggregator, _staleThreshold)));
    relayerId++;
    relayerById[relayerId] = address(_chainlinkRelayer);
    emit NewChainlinkRelayer(address(_chainlinkRelayer), _aggregator, _staleThreshold);
  }

  /// @inheritdoc IChainlinkRelayerFactory
  function deployChainlinkRelayerWithL2Validity(
    address _priceAggregator,
    address _sequencerAggregator,
    uint256 _staleThreshold,
    uint256 _gracePeriod
  ) external isAuthorized returns (IBaseOracle _chainlinkRelayer) {
    _chainlinkRelayer = IBaseOracle(
      address(
        new ChainlinkRelayerChildWithL2Validity(_priceAggregator, _sequencerAggregator, _staleThreshold, _gracePeriod)
      )
    );
    relayerWithL2ValidityId++;
    relayerWithL2ValidityById[relayerWithL2ValidityId] = address(_chainlinkRelayer);
    emit NewChainlinkRelayerWithL2Validity(
      address(_chainlinkRelayer), _priceAggregator, _sequencerAggregator, _staleThreshold, _gracePeriod
    );
  }
}
