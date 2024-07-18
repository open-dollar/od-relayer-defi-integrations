// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {Authorizable} from '@contracts/utils/Authorizable.sol';
import {GmxGmRelayerChild} from './GmxGmRelayerChild.sol';
import 'forge-std/console2.sol';

contract PendleRelayerFactory is Authorizable {
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
    address _dataStore
  ) external isAuthorized returns (IBaseOracle _gmxGmRelayerChild) {
    _gmxGmRelayerChild = IBaseOracle(address(new GmxGmRelayerChild(_marketToken, _gmxReader, _dataStore)));
    relayerId++;
    relayerById[relayerId] = address(_gmxGmRelayerChild);
    emit NewGmxGmRelayer(address(_gmxGmRelayerChild), _marketToken);
  }
}
