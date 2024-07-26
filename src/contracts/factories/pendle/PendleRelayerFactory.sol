// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {IPendleRelayerFactory} from '@interfaces/factories/IPendleRelayerFactory.sol';
import {PendlePtToSyRelayerChild} from '@contracts/factories/pendle/PendlePtToSyRelayerChild.sol';
import {PendleYtToSyRelayerChild} from '@contracts/factories/pendle/PendleYtToSyRelayerChild.sol';
import {PendleLpToSyRelayerChild} from '@contracts/factories/pendle/PendleLpToSyRelayerChild.sol';
import {Authorizable} from '@contracts/utils/Authorizable.sol';

contract PendleRelayerFactory is Authorizable, IPendleRelayerFactory {
  uint256 public relayerId;

  // --- Data ---
  mapping(uint256 => address) public relayerById;

  // --- Init ---
  constructor() Authorizable(msg.sender) {}

  // --- Methods ---

  /// @inheritdoc IPendleRelayerFactory
  function deployPendlePtRelayer(
    address _market,
    address _oracle,
    uint32 _twapDuration
  ) external isAuthorized returns (IBaseOracle _pendlePtRelayerChild) {
    _pendlePtRelayerChild = IBaseOracle(address(new PendlePtToSyRelayerChild(_market, _oracle, _twapDuration)));
    relayerId++;
    relayerById[relayerId] = address(_pendlePtRelayerChild);
    emit NewPendlePtRelayer(address(_market), _oracle, _twapDuration);
  }

  /// @inheritdoc IPendleRelayerFactory
  function deployPendleYtRelayer(
    address _market,
    address _oracle,
    uint32 _twapDuration
  ) external isAuthorized returns (IBaseOracle _pendleYtRelayerChild) {
    _pendleYtRelayerChild = IBaseOracle(address(new PendleYtToSyRelayerChild(_market, _oracle, _twapDuration)));
    relayerId++;
    relayerById[relayerId] = address(_pendleYtRelayerChild);
    emit NewPendleYtRelayer(address(_market), _oracle, _twapDuration);
  }

  /// @inheritdoc IPendleRelayerFactory
  function deployPendleLpRelayer(
    address _market,
    address _oracle,
    uint32 _twapDuration
  ) external isAuthorized returns (IBaseOracle _pendleLpRelayerChild) {
    _pendleLpRelayerChild = IBaseOracle(address(new PendleLpToSyRelayerChild(_market, _oracle, _twapDuration)));
    relayerId++;
    relayerById[relayerId] = address(_pendleLpRelayerChild);
    emit NewPendleLpRelayer(address(_market), _oracle, _twapDuration);
  }
}
