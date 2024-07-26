// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {Script} from 'forge-std/Script.sol';
import {GmxRelayerFactory} from '@contracts/factories/gmx/GmxRelayerFactory.sol';
import 'forge-std/console2.sol';
// BROADCAST
// source .env && forge script DeployGmxFactory --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --broadcast --verify --etherscan-api-key $ARB_ETHERSCAN_API_KEY --account defaultKey --sender $DEFAULT_KEY_PUBLIC_ADDRESS

// SIMULATE
// source .env && forge script DeployGmxFactory --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --account defaultKey --sender $DEFAULT_KEY_PUBLIC_ADDRESS

contract DeployGmxFactory is Script {
  address gmxRelayerFactory;

  function run() public {
    vm.startBroadcast();
    gmxRelayerFactory = address(new GmxRelayerFactory());

    console2.log('GMX Factory deployed at: ', gmxRelayerFactory);
    vm.stopBroadcast();
  }
}
