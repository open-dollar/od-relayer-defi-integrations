// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import '@script/Registry.s.sol';
import {Script} from 'forge-std/Script.sol';
import {ChainlinkRelayerFactory} from '@contracts/factories/ChainlinkRelayerFactory.sol';
import {DenominatedOracleFactory} from '@contracts/factories/DenominatedOracleFactory.sol';

// BROADCAST
// source .env && forge script DeployFactoriesMain --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --broadcast --verify --etherscan-api-key $ARB_ETHERSCAN_API_KEY

// SIMULATE
// source .env && forge script DeployFactoriesMain --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC

contract DeployFactoriesMain is Script {
  ChainlinkRelayerFactory internal _chainlinkRelayerFactory;
  DenominatedOracleFactory internal _denominatedOracleFactory;

  function run() public {
    vm.startBroadcast(vm.envUint('ARB_MAINNET_DEPLOYER_PK'));
    _chainlinkRelayerFactory = new ChainlinkRelayerFactory();
    _denominatedOracleFactory = new DenominatedOracleFactory();

    _chainlinkRelayerFactory.addAuthorization(MAINNET_DEPLOYER);
    _denominatedOracleFactory.addAuthorization(MAINNET_DEPLOYER);
    vm.stopBroadcast();
  }
}

// BROADCAST
// source .env && forge script DeployFactoriesSepolia --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_SEPOLIA_RPC --broadcast --verify --etherscan-api-key $ARB_ETHERSCAN_API_KEY

// SIMULATE
// source .env && forge script DeployFactoriesSepolia --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_SEPOLIA_RPC

contract DeployFactoriesSepolia is Script {
  ChainlinkRelayerFactory internal _chainlinkRelayerFactory;
  DenominatedOracleFactory internal _denominatedOracleFactory;

  function run() public {
    vm.startBroadcast(vm.envUint('ARB_SEPOLIA_DEPLOYER_PK'));
    _chainlinkRelayerFactory = new ChainlinkRelayerFactory();
    _denominatedOracleFactory = new DenominatedOracleFactory();
    vm.stopBroadcast();
  }
}
