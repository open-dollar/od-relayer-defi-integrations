// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {Authorizable} from '@contracts/utils/Authorizable.sol';
import {GmxGmRelayerChild} from './GmxGmRelayerChild.sol';
import {GmxGmRelayerWithRegistryChild} from './GmxGmRelayerWithRegistryChild.sol';
import {IGmxRelayerFactory} from '@interfaces/factories/IGmxRelayerFactory.sol';

contract GmxRelayerFactory is Authorizable, IGmxRelayerFactory {
  uint256 public relayerId;

  // --- Data ---
  mapping(uint256 => address) public relayerById;

  // --- Init ---
  constructor() Authorizable(msg.sender) {}

  // --- Methods ---

  /// @inheritdoc IGmxRelayerFactory
  function deployGmxGmRelayer(
    address _marketToken,
    address _gmxReader,
    address _dataStore,
    address _indexTokenOracle,
    address _longTokenOracle,
    address _shortTokenOracle
  ) external isAuthorized returns (IBaseOracle _gmxGmRelayerChild) {
    _gmxGmRelayerChild = IBaseOracle(
      address(
        new GmxGmRelayerChild(
          _marketToken, _gmxReader, _dataStore, _indexTokenOracle, _longTokenOracle, _shortTokenOracle
        )
      )
    );
    relayerId++;
    relayerById[relayerId] = address(_gmxGmRelayerChild);
    emit NewGmxGmRelayer(address(_gmxGmRelayerChild), _marketToken);
  }

  /// @inheritdoc IGmxRelayerFactory
  function deployGmxGmRelayerWithRegistry(
    address _marketToken,
    address _gmxReader,
    address _dataStore,
    address _oracleRegistry
  ) external isAuthorized returns (IBaseOracle _gmxGmRelayerChild) {
    _gmxGmRelayerChild =
      IBaseOracle(address(new GmxGmRelayerWithRegistryChild(_marketToken, _gmxReader, _dataStore, _oracleRegistry)));
    relayerId++;
    relayerById[relayerId] = address(_gmxGmRelayerChild);
    emit NewGmxGmRelayer(address(_gmxGmRelayerChild), _marketToken);
  }
}
