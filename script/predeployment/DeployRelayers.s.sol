// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import '@script/Registry.s.sol';
import {CommonMainnet} from '@script/Common.s.sol';
import {IDelayedOracleFactory} from '@interfaces/factories/IDelayedOracleFactory.sol';
import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';

// BROADCAST
// source .env && forge script DeployEthUsdChainlinkRelayerMainnet --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --broadcast --verify --etherscan-api-key $ARB_ETHERSCAN_API_KEY

// SIMULATE
// source .env && forge script DeployEthUsdChainlinkRelayerMainnet --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC

contract DeployEthUsdChainlinkRelayerMainnet is CommonMainnet {
  function run() public {
    vm.startBroadcast(vm.envUint('ARB_MAINNET_DEPLOYER_PK'));
    chainlinkRelayerFactory.deployChainlinkRelayer(MAINNET_CHAINLINK_ETH_USD_FEED, MAINNET_ORACLE_DELAY);
    vm.stopBroadcast();
  }
}

// BROADCAST
// source .env && forge script DeployRethEthChainlinkRelayerMainnet --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --broadcast --verify --etherscan-api-key $ARB_ETHERSCAN_API_KEY

// SIMULATE
// source .env && forge script DeployRethEthChainlinkRelayerMainnet --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC

contract DeployRethEthChainlinkRelayerMainnet is CommonMainnet {
  function run() public {
    vm.startBroadcast(vm.envUint('ARB_MAINNET_DEPLOYER_PK'));
    IBaseOracle _chainlinkRethEthPriceFeed =
      chainlinkRelayerFactory.deployChainlinkRelayer(MAINNET_CHAINLINK_RETH_ETH_FEED, MAINNET_ORACLE_DELAY);

    IBaseOracle _rethUsdOracle = denominatedOracleFactory.deployDenominatedOracle(
      _chainlinkRethEthPriceFeed, IBaseOracle(MAINNET_CHAINLINK_ETH_USD_RELAYER), false
    );

    _rethUsdOracle.symbol(); // "(RETH / ETH) * (ETH / USD)"
    vm.stopBroadcast();
  }
}

// BROADCAST
// source .env && forge script DeployWstethEthChainlinkRelayerMainnet --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --broadcast --verify --etherscan-api-key $ARB_ETHERSCAN_API_KEY --account defaultKey --sender $DEFAULT_KEY_PUBLIC_ADDRESS

// SIMULATE
// source .env && forge script DeployWstethEthChainlinkRelayerMainnet --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC

contract DeployWstethEthChainlinkRelayerMainnet is CommonMainnet {
  function run() public {
    vm.startBroadcast(vm.envUint('ARB_MAINNET_DEPLOYER_PK'));
    IBaseOracle _chainlinkWstethEthPriceFeed =
      chainlinkRelayerFactory.deployChainlinkRelayer(MAINNET_CHAINLINK_WSTETH_ETH_FEED, MAINNET_ORACLE_DELAY);

    IBaseOracle _wstethUsdOracle = denominatedOracleFactory.deployDenominatedOracle(
      _chainlinkWstethEthPriceFeed, IBaseOracle(MAINNET_CHAINLINK_ETH_USD_RELAYER), false
    );

    _wstethUsdOracle.symbol(); // "(WSTETH / ETH) * (ETH / USD)"
    vm.stopBroadcast();
  }
}

// BROADCAST
// source .env && forge script DeployEzEthUSDPriceFeed rtEthOracles --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --broadcast --verify --etherscan-api-key $ARB_ETHERSCAN_API_KEY --account defaultKey --sender $DEFAULT_KEY_PUBLIC_ADDRESS
// SIMULATE
// source .env && forge script DeployEzEthUSDPriceFeed rtEthOracles --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --sender $DEFAULT_KEY_PUBLIC
contract DeployEzEthUSDPriceFeed is CommonMainnet {
  function run() public {
    vm.startBroadcast();
    IBaseOracle _ezEthEthPriceFeed = chainlinkRelayerFactory.deployChainlinkRelayerWithL2Validity(
      MAINNET_CHAINLINK_EZETH_ETH_FEED,
      MAINNET_CHAINLINK_SEQUENCER_FEED,
      MAINNET_ORACLE_DELAY,
      MAINNET_CHAINLINK_L2VALIDITY_GRACE_PERIOD
    );

    IBaseOracle _ezEthUsdOracle = denominatedOracleFactory.deployDenominatedOracle(
      _ezEthEthPriceFeed, IBaseOracle(MAINNET_CHAINLINK_ETH_USD_RELAYER), false
    );

    IBaseOracle _ezEthUsdDelayedOracle = delayedOracleFactory.deployDelayedOracle(_ezEthUsdOracle, MAINNET_ORACLE_DELAY);

    _ezEthUsdDelayedOracle.symbol(); // "(EZETH / ETH) * (ETH / USD)"
    vm.stopBroadcast();
  }
}
