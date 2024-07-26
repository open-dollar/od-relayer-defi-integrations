// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import '@script/Registry.s.sol';
import {CommonMainnet} from '@script/Common.s.sol';
import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import 'forge-std/console2.sol';

// BROADCAST
// source .env && forge script DeployGmxWethMarketRelayerMainnet --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --broadcast --verify --etherscan-api-key $ARB_ETHERSCAN_API_KEY --account defaultKey --sender $DEFAULT_KEY_PUBLIC_ADDRESS
// SIMULATE
// source .env && forge script DeployGmxWethMarketRelayerMainnet --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --account defaultKey --sender $DEFAULT_KEY_PUBLIC
contract DeployGmxWethMarketRelayerMainnet is CommonMainnet {
  function run() public {
    vm.startBroadcast();
    IBaseOracle _gmWethPerpMarketOracle = gmxRelayerFactory.deployGmxGmRelayerWithRegistry(
      MAINNET_GMX_WETH_PERP_MARKET_TOKEN, MAINNET_GMX_READER, MAINNET_GMX_DATA_STORE, MAINNET_ORACLE_REGISTRY
    );

    console2.log('GM WEth perp market oracle deployed at: ', address(_gmWethPerpMarketOracle));
    vm.stopBroadcast();
  }
}
