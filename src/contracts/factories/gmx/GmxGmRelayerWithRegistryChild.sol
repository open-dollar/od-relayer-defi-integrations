// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {GmxGmRelayerWithRegistry} from '@contracts/oracles/gmx/GmxGmRelayerWithRegistry.sol';
import {FactoryChild} from '@contracts/factories/FactoryChild.sol';

contract GmxGmRelayerWithRegistryChild is GmxGmRelayerWithRegistry, FactoryChild {
  // --- Init ---

  /**
   */
  constructor(
    address _marketToken,
    address _gmxReader,
    address _dataStore,
    address _oracleRegistry
  ) GmxGmRelayerWithRegistry(_marketToken, _gmxReader, _dataStore, _oracleRegistry) {}
}
