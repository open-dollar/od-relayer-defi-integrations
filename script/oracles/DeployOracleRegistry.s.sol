// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import '@script/Registry.s.sol';
import {Script} from 'forge-std/Script.sol';
import {CommonMainnet} from '@script/Common.s.sol';
import {OracleRegistry} from '@contracts/oracles/OracleRegistry.sol';
import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import 'forge-std/console2.sol';

// BROADCAST
// source .env && forge script DeployOracleRegistryMainnet --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --broadcast --verify --etherscan-api-key $ARB_ETHERSCAN_API_KEY --account defaultKey --sender $DEFAULT_KEY_PUBLIC_ADDRESS

// SIMULATE
// source .env && forge script DeployOracleRegistryMainnet --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --account defaultKey --sender $DEFAULT_KEY_PUBLIC

contract DeployOracleRegistryMainnet is Script, CommonMainnet {
  address[] public tokens;
  IBaseOracle[] public oracles;

  function run() public {
    vm.startBroadcast();
    // add weth oracle
    tokens.push(ETH);
    oracles.push(IBaseOracle(MAINNET_CHAINLINK_ETH_USD_RELAYER));
    // add reth oracle
    tokens.push(RETH);
    oracles.push(IBaseOracle(MAINNET_DENOMINATED_RETH_USD_ORACLE));
    // add wsteth oracle
    tokens.push(ARB);
    oracles.push(IBaseOracle(MAINNET_CHAINLINK_ARB_USD_RELAYER));
    //add usdc oracle
    tokens.push(USDC);
    oracles.push(IBaseOracle(MAINNET_CHAINLINK_USDC_USD_FEED));

    address oracleRegistry = address(new OracleRegistry(tokens, oracles));

    console2.log('New Oracle Registry deployed at: ', oracleRegistry);

    vm.stopBroadcast();
  }
}

// BROADCAST
// source .env && forge script AddOracleToRegisty --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --broadcast --verify --etherscan-api-key $ARB_ETHERSCAN_API_KEY --account defaultKey --sender $DEFAULT_KEY_PUBLIC_ADDRESS

// SIMULATE
// source .env && forge script AddOracleToRegisty --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --account defaultKey --sender $DEFAULT_KEY_PUBLIC

contract AddOracleToRegisty is Script, CommonMainnet {
  address tokenToAdd = 0x0000000000000000000000000000000000000000; // the address of the token that the oracle is providing the price for
  IBaseOracle public oracleToAdd = IBaseOracle(0x0000000000000000000000000000000000000000); // the base oracle denominated in usd of for the above token price

  function run() public {
    vm.startBroadcast();

    oracleRegistry.addOracle(tokenToAdd, oracleToAdd);

    console2.log('New oracle added to registry');
    vm.stopBroadcast();
  }
}
