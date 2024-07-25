// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {GmxGmRelayer} from '@contracts/oracles/gmx/GmxGmRelayer.sol';
import {FactoryChild} from '@contracts/factories/FactoryChild.sol';

contract GmxGmRelayerChild is GmxGmRelayer, FactoryChild {
  // --- Init ---

  constructor(
    address _marketToken,
    address _gmxReader,
    address _dataStore,
    address _indexTokenOracle,
    address _longTokenOracle,
    address _shortTokenOracle
  ) GmxGmRelayer(_marketToken, _gmxReader, _dataStore, _indexTokenOracle, _longTokenOracle, _shortTokenOracle) {}
}
