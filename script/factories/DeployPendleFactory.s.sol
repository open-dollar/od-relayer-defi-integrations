// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import '@script/Registry.s.sol';
import {Script} from 'forge-std/Script.sol';
import {PendleRelayerFactory} from '@contracts/factories/pendle/PendleRelayerFactory.sol';
import {IAuthorizable} from '@interfaces/utils/IAuthorizable.sol';
import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';

// BROADCAST
// source .env && forge script DeployPendleRelayerFactory --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --broadcast --verify --etherscan-api-key $ARB_ETHERSCAN_API_KEY --sender $DEFAULT_KEY_PUBLIC_ADDRESS --account defaultKey

// SIMULATE
// source .env && forge script DeployPendleRelayerFactory --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --account defaultKey --sender $DEFAULT_KEY_PUBLIC_ADDRESS

contract DeployPendleRelayerFactory is Script {
  IBaseOracle public pendleLpToSyRelayer;
  IBaseOracle public pendleYtToSyRelayer;
  IBaseOracle public pendlePtToSyRelayer;

  PendleRelayerFactory public pendleRelayerFactory;

  function run() public {
    vm.startBroadcast();
    pendleRelayerFactory = new PendleRelayerFactory();
    vm.stopBroadcast();
  }
}
