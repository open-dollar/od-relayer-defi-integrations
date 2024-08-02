// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import '@script/Registry.s.sol';
import {Script} from 'forge-std/Script.sol';
import {IAuthorizable} from '@interfaces/utils/IAuthorizable.sol';
import {ChainlinkRelayerFactory} from '@contracts/factories/ChainlinkRelayerFactory.sol';
import {DenominatedOracleFactory} from '@contracts/factories/DenominatedOracleFactory.sol';
import {PendleRelayerFactory} from '@contracts/factories/pendle/PendleRelayerFactory.sol';
import {GmxRelayerFactory} from '@contracts/factories/gmx/GmxRelayerFactory.sol';
import {OracleRegistry} from '@contracts/oracles/OracleRegistry.sol';
import {IDelayedOracleFactory} from '@interfaces/factories/IDelayedOracleFactory.sol';

abstract contract CommonMainnet is Script {
  ChainlinkRelayerFactory public chainlinkRelayerFactory = ChainlinkRelayerFactory(MAINNET_CHAINLINK_RELAYER_FACTORY);
  DenominatedOracleFactory public denominatedOracleFactory =
    DenominatedOracleFactory(MAINNET_DENOMINATED_ORACLE_FACTORY);
  PendleRelayerFactory public pendleRelayerFactory = PendleRelayerFactory(MAINNET_PENDLE_RELAYER_FACTORY);
  GmxRelayerFactory public gmxRelayerFactory = GmxRelayerFactory(MAINNET_GMX_RELAYER_FACTORY);
  IDelayedOracleFactory public delayedOracleFactory = IDelayedOracleFactory(MAINNET_DELAYED_ORACLE_FACTORY);
  OracleRegistry public oracleRegistry = OracleRegistry(MAINNET_ORACLE_REGISTRY);
}

abstract contract CommonSepolia is Script {
  ChainlinkRelayerFactory public chainlinkRelayerFactory = ChainlinkRelayerFactory(SEPOLIA_CHAINLINK_RELAYER_FACTORY);
  DenominatedOracleFactory public denominatedOracleFactory =
    DenominatedOracleFactory(SEPOLIA_DENOMINATED_ORACLE_FACTORY);

  IAuthorizable public chainlinkRelayerFactoryAuth = IAuthorizable(SEPOLIA_CHAINLINK_RELAYER_FACTORY);
  IAuthorizable public denominatedOracleFactoryAuth = IAuthorizable(SEPOLIA_DENOMINATED_ORACLE_FACTORY);

  address public deployer = vm.envAddress('ARB_SEPOLIA_DEPLOYER_ADDR');
  address public admin = vm.envAddress('ARB_SEPOLIA_ADDR');

  function _revoke(IAuthorizable _contract, address _authorize, address _deauthorize) internal {
    _contract.addAuthorization(_authorize);
    _contract.removeAuthorization(_deauthorize);
  }

  function revokeFactories() internal {
    _revoke(chainlinkRelayerFactoryAuth, TEST_GOVERNOR, deployer);
    _revoke(denominatedOracleFactoryAuth, TEST_GOVERNOR, deployer);
  }

  // basePrice = OD, quotePrice = WETH
  // function initialPrice(
  //   uint256 _basePrice,
  //   uint256 _quotePrice,
  //   address _pool
  // ) internal view returns (uint160 _sqrtPriceX96) {
  //   bytes32 _symbol = keccak256(abi.encodePacked(IERC20Metadata(_token0).symbol()));
  //   uint256 _price;

  //   // price = token1 / token0
  //   if (_token0 == SEPOLIA_SYSTEM_COIN) {
  //     require(keccak256(abi.encodePacked('OD')) == _symbol, '!OD');
  //     _price = ((_quotePrice * WAD) / _basePrice);
  //   } else {
  //     require(keccak256(abi.encodePacked('WETH')) == _symbol, '!WETH');
  //     _price = ((_basePrice * WAD) / _quotePrice);
  //   }

  //   // check math @ https://uniswap-v3-calculator.netlify.app/
  //   _sqrtPriceX96 = uint160(Sqrt.sqrtAbs(int256(_price)) * (2 ** 96)) / 1e9;
  // }

  /**
   * note FOR TEST
   */
  function authOnlyFactories() internal {
    if (!chainlinkRelayerFactoryAuth.authorizedAccounts(admin)) {
      chainlinkRelayerFactoryAuth.addAuthorization(admin);
    }
    if (!denominatedOracleFactoryAuth.authorizedAccounts(admin)) {
      denominatedOracleFactoryAuth.addAuthorization(admin);
    }
  }
}
