// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {GMXGmRelayer} from '@contracts/oracles/gmx/GMXGmRelayer.sol';
import {FactoryChild} from '@contracts/factories/FactoryChild.sol';

contract GMXGmRelayerChild is GMXGmRelayer, FactoryChild {
  // --- Init ---

  /**
   */
  constructor() GMXGmRelayer() {}
}
