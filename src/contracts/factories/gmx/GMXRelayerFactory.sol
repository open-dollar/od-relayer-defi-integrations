// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {Authorizable} from '@contracts/utils/Authorizable.sol';
import {GMXGmRelayerChild} from './GMXGmRelayerChild.sol';
import 'forge-std/console2.sol';

contract PendleRelayerFactory is Authorizable {
  uint256 public relayerId;

  // --- Events ---
  event NewGMXGmRelayer();

  // --- Data ---
  mapping(uint256 => address) public relayerById;

  // --- Init ---
  constructor() Authorizable(msg.sender) {}

  // --- Methods ---

  function deployGMXGmRelayer(address market) external isAuthorized returns (IBaseOracle _gmxGmRelayerChild) {
    _gmxGmRelayerChild = IBaseOracle(address(0));
    relayerId++;
    relayerById[relayerId] = address(_gmxGmRelayerChild);
    emit NewGMXGmRelayer();
  }
}
