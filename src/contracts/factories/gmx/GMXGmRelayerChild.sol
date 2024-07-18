// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {GMXGmRelayer} from '@contracts/oracles/gmx/GMXGmRelayer.sol';
import {FactoryChild} from '@contracts/factories/FactoryChild.sol';

contract GMXGmRelayerChild is GMXGmRelayer, FactoryChild {
  // --- Init ---

  /**
   * @param  _market The address pendle market
   * @param  _oracle The address of the pendle oracle
   * @param _twapDuration the amount in seconds of the desired twap observations (recommended 900s)
   */
  constructor() GMXGmRelayer() {}
}
