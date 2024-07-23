// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import '@script/Registry.s.sol';
import {Script} from 'forge-std/Script.sol';
import {IChainlinkRelayerFactory} from '@interfaces/factories/IChainlinkRelayerFactory.sol';
import {IDenominatedOracleFactory} from '@interfaces/factories/IDenominatedOracleFactory.sol';
import {IChainlinkRelayer} from '@interfaces/oracles/IChainlinkRelayer.sol';
import {IDenominatedOracle} from '@interfaces/oracles/IDenominatedOracle.sol';
import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {MintableERC20} from '@contracts/for-test/MintableERC20.sol';
import {Data} from '@contracts/for-test/Data.sol';

// BROADCAST
// source .env && forge script DeployOracles --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_SEPOLIA_RPC --broadcast --verify --etherscan-api-key $ARB_ETHERSCAN_API_KEY

// SIMULATE
// source .env && forge script DeployOracles --with-gas-price 2000000000 -vvvvv --rpc-url $ARB_SEPOLIA_RPC

contract DeployOracles is Script {
  Data public data = Data(RELAYER_DATA);

  IBaseOracle public chainlinkEthUSDPriceFeed;
  IBaseOracle public denominatedOracle;

  IChainlinkRelayerFactory public chainlinkRelayerFactory;
  IDenominatedOracleFactory public denominatedOracleFactory;

  function run() public {
    vm.startBroadcast(vm.envUint('ARB_SEPOLIA_PK'));

    // chainlinkRelayerFactory = data.chainlinkRelayerFactory();
    // denominatedOracleFactory = data.denominatedOracleFactory();

    // // deploy chainlink relayer
    // chainlinkEthUSDPriceFeed =
    //   chainlinkRelayerFactory.deployChainlinkRelayer(SEPOLIA_CHAINLINK_ETH_USD_FEED, ORACLE_INTERVAL_TEST);
    // data.modifyOracle(bytes32('chainlinkRelayer'), address(chainlinkEthUSDPriceFeed));

    // // deploy denominated oracle
    // denominatedOracle =
    //   denominatedOracleFactory.deployDenominatedOracle(chainlinkEthUSDPriceFeed, camelotRelayer, false);
    // data.modifyOracle(bytes32('denominatedOracle'), address(denominatedOracle));

    vm.stopBroadcast();
  }
}
