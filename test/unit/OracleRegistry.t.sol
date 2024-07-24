// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;
pragma abicoder v2;

import '@script/Registry.s.sol';
import {DSTestPlus} from '@test/utils/DSTestPlus.t.sol';
import {IERC20Metadata} from '@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol';
import {ChainlinkRelayerFactory} from '@contracts/factories/ChainlinkRelayerFactory.sol';
import {ChainlinkRelayerChild} from '@contracts/factories/ChainlinkRelayerChild.sol';
import {PendleRelayerFactory} from '@contracts/factories/pendle/PendleRelayerFactory.sol';
import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {DenominatedOracleFactory} from '@contracts/factories/DenominatedOracleFactory.sol';
import {DenominatedOracleChild} from '@contracts/factories/DenominatedOracleChild.sol';
import {IDelayedOracleFactory} from '@interfaces/factories/IDelayedOracleFactory.sol';
import {IAuthorizable} from '@interfaces/utils/IAuthorizable.sol';
import {IAuthorizable} from '@interfaces/utils/IAuthorizable.sol';
import {OracleRegistry} from '@contracts/oracles/OracleRegistry.sol';
import {IOracleRegistry} from '@interfaces/oracles/IOracleRegistry.sol';
import {IPendleRelayer} from '@interfaces/oracles/pendle/IPendleRelayer.sol';
import {IGmxRelayerFactory} from '@interfaces/factories/IGmxRelayerFactory.sol';
import {IGmxReader} from '@interfaces/oracles/gmx/IGmxReader.sol';
import {IGmxDataStore} from '@interfaces/oracles/gmx/IGmxDataStore.sol';
import {GmxRelayerFactory} from '@contracts/factories/gmx/GmxRelayerFactory.sol';
import {GmxMarket} from '@libraries/gmx/GmxMarket.sol';
import 'forge-std/console2.sol';

abstract contract Base is DSTestPlus {
  address deployer = label('deployer');
  address authorizedAccount = label('authorizedAccount');
  address mainnetAuthorizedAccount = 0xF78dA2A37049627636546E0cFAaB2aD664950917;
  address user = label('user');

  IERC20Metadata mockBaseToken = IERC20Metadata(mockContract('BaseToken'));
  IERC20Metadata mockQuoteToken = IERC20Metadata(mockContract('QuoteToken'));

  ChainlinkRelayerFactory chainlinkRelayerFactory;
  IBaseOracle chainlinkRelayerChild;

  DenominatedOracleFactory denominatedOracleFactory;
  IBaseOracle denominatedOracleChild;

  IDelayedOracleFactory delayedOracleFactory;
  IBaseOracle delayedOracleChild;

  IOracleRegistry oracleRegistry;

  IBaseOracle usdUsdcOracle;
  address mockAggregator = mockContract('ChainlinkAggregator');

  address[] public tokens;
  IBaseOracle[] public deployedOracles;

  function setUp() public virtual {
    vm.createSelectFork('mainnet');
    vm.startPrank(deployer);
    chainlinkRelayerFactory = new ChainlinkRelayerFactory();
    label(address(chainlinkRelayerFactory), 'ChainlinkRelayerFactory');

    chainlinkRelayerFactory.addAuthorization(authorizedAccount);

    denominatedOracleFactory = new DenominatedOracleFactory();
    label(address(denominatedOracleFactory), 'DenominatedOracleFactory');

    denominatedOracleFactory.addAuthorization(authorizedAccount);

    usdUsdcOracle = chainlinkRelayerFactory.deployChainlinkRelayerWithL2Validity(
      MAINNET_CHAINLINK_USDC_USD_FEED, MAINNET_CHAINLINK_SEQUENCER_FEED, 60, 60
    );

    tokens.push(ETH);
    tokens.push(USDC);
    deployedOracles.push(IBaseOracle(MAINNET_CHAINLINK_ETH_USD_RELAYER));
    deployedOracles.push(usdUsdcOracle);

    oracleRegistry = new OracleRegistry(tokens, deployedOracles);

    vm.stopPrank();
  }

  function _mockSymbol(string memory _symbol) internal {
    vm.mockCall(address(mockBaseToken), abi.encodeWithSignature('symbol()'), abi.encode(_symbol));
    vm.mockCall(address(mockQuoteToken), abi.encodeWithSignature('symbol()'), abi.encode(_symbol));
    vm.mockCall(address(mockAggregator), abi.encodeWithSignature('description()'), abi.encode(_symbol));
  }

  function _mockDecimals(uint8 _decimals) internal {
    vm.mockCall(address(mockBaseToken), abi.encodeWithSignature('decimals()'), abi.encode(_decimals));
    vm.mockCall(address(mockQuoteToken), abi.encodeWithSignature('decimals()'), abi.encode(_decimals));
    vm.mockCall(address(mockAggregator), abi.encodeWithSignature('decimals()'), abi.encode(_decimals));
  }
}

contract Unit_OracleRegistry_Deployment is Base {
  function test_Deployment() public {
    assertEq(address(oracleRegistry.usdDenominatedFeed(ETH)), MAINNET_CHAINLINK_ETH_USD_RELAYER);
    assertEq(address(oracleRegistry.usdDenominatedFeed(USDC)), address(usdUsdcOracle));
  }

  function test_Deployment_Revert_LengthMismatch() public {
    address[] memory shortTokens = new address[](1);
    shortTokens[0] = address(1111);
    vm.expectRevert('ORACLE REGISTRY: LENGTH MISMATCH');
    new OracleRegistry(shortTokens, deployedOracles);
  }
}

contract Unit_OracleRegistry_AddOracles is Base {
  function test_AddOracles() public {
    address[] memory newTokens = new address[](2);

    newTokens[0] = RETH;
    newTokens[1] = WSTETH;

    IBaseOracle[] memory newOracles = new IBaseOracle[](2);

    newOracles[0] = IBaseOracle(MAINNET_DENOMINATED_RETH_USD_ORACLE);
    newOracles[1] = IBaseOracle(MAINNET_DENOMINATED_WSTETH_USD_ORACLE);
    vm.prank(deployer);
    oracleRegistry.addOracles(newTokens, newOracles);

    assertEq(address(oracleRegistry.usdDenominatedFeed(RETH)), MAINNET_DENOMINATED_RETH_USD_ORACLE);
    assertEq(address(oracleRegistry.usdDenominatedFeed(WSTETH)), MAINNET_DENOMINATED_WSTETH_USD_ORACLE);
  }

  function test_AddOracles_Revert_LengthMismatch() public {
    address[] memory newTokens = new address[](2);

    newTokens[0] = RETH;
    newTokens[1] = WSTETH;

    IBaseOracle[] memory newOracles = new IBaseOracle[](1);

    newOracles[0] = IBaseOracle(MAINNET_DENOMINATED_RETH_USD_ORACLE);

    vm.expectRevert('ORACLE REGISTRY: LENGTH MISMATCH');
    vm.prank(deployer);
    oracleRegistry.addOracles(newTokens, newOracles);
  }
}

contract Unit_OracleRegistry_AddOracle is Base {
  function test_AddOracle() public {
    vm.prank(deployer);
    oracleRegistry.addOracle(RETH, IBaseOracle(MAINNET_DENOMINATED_RETH_USD_ORACLE));
    assertEq(address(oracleRegistry.usdDenominatedFeed(RETH)), MAINNET_DENOMINATED_RETH_USD_ORACLE);
  }

  function test_AddOracle_Revert_InvalidOracle() public {
    vm.expectRevert('ORACLE REGISTRY: INVALID ORACLE');
    vm.prank(deployer);
    oracleRegistry.addOracle(RETH, IBaseOracle(address(123_456_789)));
  }

  function test_AddOracle_Revert_InvalidToken() public {
    vm.expectRevert('ORACLE REGISTRY: INVALID TOKEN');
    vm.prank(deployer);
    oracleRegistry.addOracle(address(123_456_789), IBaseOracle(MAINNET_DENOMINATED_RETH_USD_ORACLE));
  }
}

contract Unit_OracleRegistry_GetResultWithValidity is Base {
  function test_GetResultWithValidity() public {
    (uint256 _result, bool _validity) = oracleRegistry.getResultWithValidity(ETH);
    assertGt(_result, 0);
    assertTrue(_validity);
  }

  function test_Read() public {
    uint256 _result = oracleRegistry.read(ETH);
    assertGt(_result, 0);
  }

  function test_Read_Revert_NotSupported() public {
    vm.expectRevert('ORACLE REGISTRY: TOKEN NOT SUPPORTED');
    oracleRegistry.read(address(1));
  }

  function test_GetResultWithValidity_Revert_NotSupported() public {
    vm.expectRevert('ORACLE REGISTRY: TOKEN NOT SUPPORTED');
    oracleRegistry.getResultWithValidity(address(1));
  }
}

contract Unit_GmxGmRelayerWithRegistry is Base {
  IGmxRelayerFactory public gmxFactory;
  IGmxReader public gmxReader;
  IGmxDataStore public gmxDataStore;

  function setUp() public virtual override {
    super.setUp();
    gmxFactory = IGmxRelayerFactory(address(new GmxRelayerFactory()));
    gmxReader = IGmxReader(MAINNET_GMX_READER);
    gmxDataStore = IGmxDataStore(MAINNET_GMX_DATA_STORE);

    label(address(delayedOracleFactory), 'DelayedOracleFactory');
    label(address(chainlinkRelayerFactory), 'ChainlinkRelayerFactory');
    label(address(denominatedOracleFactory), 'DenominatedOracleFactory');
    label(address(gmxFactory), 'gmxFactory');
  }

  function test_Create_GmxGmRelayerWithRegistry() public {
    IBaseOracle wethGmMarket = gmxFactory.deployGmxGmRelayerWithRegistry(
      MAINNET_GMX_WETH_PERP_MARKET_TOKEN, address(gmxReader), address(gmxDataStore), address(oracleRegistry)
    );
    (uint256 readValue, bool valid) = wethGmMarket.getResultWithValidity();
    assertGt(readValue, 0);
    assertTrue(valid);
  }
}
