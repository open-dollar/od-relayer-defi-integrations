// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {Authorizable} from '@contracts/utils/Authorizable.sol';
import {GmxGmRelayerChild} from './GmxGmRelayerChild.sol';
import {GmxGmRelayerWithRegistryChild} from './GmxGmRelayerWithRegistryChild.sol';

contract GmxRelayerFactory is Authorizable {
  uint256 public relayerId;

  // --- Events ---
  event NewGmxGmRelayer(address _newGmxRelayerChild, address _marketToken);

  // --- Data ---
  mapping(uint256 => address) public relayerById;

  // --- Init ---
  constructor() Authorizable(msg.sender) {}

  // --- Methods ---

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
