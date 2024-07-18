// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {Authorizable} from '@contracts/utils/Authorizable.sol';
import {GMXGmRelayerChild} from './GMXGmRelayerChild.sol';
import 'forge-std/console2.sol';

contract PendleRelayerFactory is Authorizable {
  uint256 public relayerId;

  // --- Events ---
  event NewGMXGmRelayer(address indexed _market, address _oracle, uint32 _twapDuration);

  // --- Data ---
  mapping(uint256 => address) public relayerById;

  // --- Init ---
  constructor() Authorizable(msg.sender) {}

  // --- Methods ---

  function deployGMXGmRelayer(address market) external isAuthorized returns (IBaseOracle _pendlePtRelayerChild) {
    _gmxGmRelayerChild = IBaseOracle(address(0));
    relayerId++;
    relayerById[relayerId] = address(_pendlePtRelayerChild);
    emit NewPendlePtRelayer(address(_market), _oracle, _twapDuration);
  }
}
