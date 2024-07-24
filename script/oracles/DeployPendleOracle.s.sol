// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import '@script/Registry.s.sol';
import {Script} from 'forge-std/Script.sol';
import {CommonMainnet} from '@script/Common.s.sol';
import 'forge-std/console2.sol';
import {ChainlinkRelayerFactory} from '@contracts/factories/ChainlinkRelayerFactory.sol';
import {DenominatedOracleFactory} from '@contracts/factories/DenominatedOracleFactory.sol';
import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';

// BROADCAST
// source .env && forge script DeployRethPtToSyPendleRelayerMainnet rtEthOracles --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --broadcast --verify --etherscan-api-key $ARB_ETHERSCAN_API_KEY --account defaultKey --sender $DEFAULT_KEY_PUBLIC_ADDRESS
// SIMULATE
// source .env && forge script DeployRethPtToSyPendleRelayerMainnet rtEthOracles --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --account defaultKey --sender $DEFAULT_KEY_PUBLIC
contract DeployRethPtToSyPendleRelayerMainnet is CommonMainnet {
  function run() public {
    vm.startBroadcast();
    IBaseOracle _pendleRethPtToSyFeed = pendleRelayerFactory.deployPendlePtRelayer(
      MAINNET_PENDLE_RETH_MARKET, MAINNET_PENDLE_ORACLE, MAINNET_PENDLE_TWAP_DURATION
    );

    IBaseOracle _rethToUSDOracle = denominatedOracleFactory.deployDenominatedOracle(
      _pendleRethPtToSyFeed, IBaseOracle(MAINNET_DENOMINATED_L2VALIDITY_RETH_USD_ORACLE), false
    );

    IBaseOracle _rethToUSDOracleDelayedOracle =
      delayedOracleFactory.deployDelayedOracle(_rethToUSDOracle, MAINNET_ORACLE_DELAY);

    _rethToUSDOracleDelayedOracle.symbol();
    vm.stopBroadcast();
  }
}

// BROADCAST
// source .env && forge script DeployWsethPtToSyPendleRelayerMainnet --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --broadcast --verify --etherscan-api-key $ARB_ETHERSCAN_API_KEY --account defaultKey --sender $DEFAULT_KEY_PUBLIC_ADDRESS

// SIMULATE
// source .env && forge script DeployWsethPtToSyPendleRelayerMainnet --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_MAINNET_RPC --account defaultKey --sender $DEFAULT_KEY_PUBLIC

contract DeployWstethPtToSyPendleRelayerMainnet is CommonMainnet {
  function run() public {
    vm.startBroadcast();
    IBaseOracle _pendleWstethPtToSyFeed = pendleRelayerFactory.deployPendlePtRelayer(
      MAINNET_PENDLE_WSTETH_MARKET, MAINNET_PENDLE_ORACLE, MAINNET_PENDLE_TWAP_DURATION
    );

    IBaseOracle _wstethToUSDOracle = denominatedOracleFactory.deployDenominatedOracle(
      _pendleWstethPtToSyFeed, IBaseOracle(MAINNET_DENOMINATED_WSTETH_USD_ORACLE), false
    );

    IBaseOracle _wstethToUSDDelayedOracle =
      delayedOracleFactory.deployDelayedOracle(_wstethToUSDOracle, MAINNET_ORACLE_DELAY);

    _wstethToUSDDelayedOracle.symbol();
    vm.stopBroadcast();
  }
}
