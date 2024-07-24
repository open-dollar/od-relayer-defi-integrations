// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;
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
import {MAINNET_PENDLE_ORACLE, MAINNET_PENDLE_RETH_MARKET} from '@script/Registry.s.sol';
import {IAuthorizable} from '@interfaces/utils/IAuthorizable.sol';
import {IPendleRelayerFactory} from '@interfaces/factories/IPendleRelayerFactory.sol';
import {IPendleRelayer} from '@interfaces/oracles/pendle/IPendleRelayer.sol';
import {IGmxRelayerFactory} from '@interfaces/factories/IGmxRelayerFactory.sol';
import {IGmxReader} from '@interfaces/oracles/gmx/IGmxReader.sol';
import {IGmxDataStore} from '@interfaces/oracles/gmx/IGmxDataStore.sol';
import {GmxRelayerFactory} from '@contracts/factories/gmx/GmxRelayerFactory.sol';
import {GmxMarket} from '@libraries/gmx/GmxMarket.sol';

abstract contract Base is DSTestPlus {
  address deployer = label('deployer');
  address authorizedAccount = label('authorizedAccount');
  address user = label('user');

  IERC20Metadata mockBaseToken = IERC20Metadata(mockContract('BaseToken'));
  IERC20Metadata mockQuoteToken = IERC20Metadata(mockContract('QuoteToken'));

  ChainlinkRelayerFactory chainlinkRelayerFactory;
  IBaseOracle chainlinkRelayerChild;

  DenominatedOracleFactory denominatedOracleFactory;
  IBaseOracle denominatedOracleChild;

  IDelayedOracleFactory delayedOracleFactory;
  IBaseOracle delayedOracleChild;

  address mockAggregator = mockContract('ChainlinkAggregator');

  function setUp() public virtual {
    vm.startPrank(deployer);
    chainlinkRelayerFactory = new ChainlinkRelayerFactory();
    label(address(chainlinkRelayerFactory), 'ChainlinkRelayerFactory');

    chainlinkRelayerFactory.addAuthorization(authorizedAccount);

    denominatedOracleFactory = new DenominatedOracleFactory();
    label(address(denominatedOracleFactory), 'DenominatedOracleFactory');

    denominatedOracleFactory.addAuthorization(authorizedAccount);

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

contract Unit_ChainlinkRelayerFactory_Constructor is Base {
  event AddAuthorization(address _account);

  modifier happyPath() {
    vm.startPrank(user);
    _;
  }

  function test_Emit_AddAuthorization() public happyPath {
    vm.expectEmit();
    emit AddAuthorization(user);

    chainlinkRelayerFactory = new ChainlinkRelayerFactory();
  }
}

contract Unit_RelayerFactory_DeployChainlinkRelayer is Base {
  event NewChainlinkRelayer(address indexed _chainlinkRelayer, address _aggregator, uint256 _staleThreshold);

  address chainlinkRelayer = 0x7F85e9e000597158AED9320B5A5E11AB8cC7329A; //0x56D9e6a12fC3E3f589Ee5E685C9f118D62ce9C8D;

  modifier happyPath(string memory _symbol, uint8 _decimals, uint256 _staleThreshold) {
    vm.startPrank(authorizedAccount);
    vm.assume(_staleThreshold > 0);
    _assumeHappyPath(_decimals);
    _mockSymbol(_symbol);
    _mockDecimals(_decimals);
    _;
  }

  function _assumeHappyPath(uint8 _decimals) internal pure {
    vm.assume(_decimals <= 18 && _decimals > 0);
  }

  function test_Deploy_RelayerChild(
    string memory _symbol,
    uint8 _decimals,
    uint256 _staleThreshold
  ) public happyPath(_symbol, _decimals, _staleThreshold) {
    vm.expectEmit();
    emit NewChainlinkRelayer(address(chainlinkRelayer), mockAggregator, _staleThreshold);

    chainlinkRelayerChild = chainlinkRelayerFactory.deployChainlinkRelayer(mockAggregator, _staleThreshold);
    assertEq(chainlinkRelayerChild.symbol(), _symbol);
  }

  function test_Set_Relayers(
    string memory _symbol,
    uint8 _decimals,
    uint256 _staleThreshold
  ) public happyPath(_symbol, _decimals, _staleThreshold) {
    chainlinkRelayerChild = chainlinkRelayerFactory.deployChainlinkRelayer(mockAggregator, _staleThreshold);

    assertEq(chainlinkRelayerFactory.relayerById(1), address(chainlinkRelayerChild));
  }

  function test_Set_Relayers_WithL2Validity(
    string memory _symbol,
    uint8 _decimals,
    uint256 _staleThreshold
  ) public happyPath(_symbol, _decimals, _staleThreshold) {
    chainlinkRelayerChild = chainlinkRelayerFactory.deployChainlinkRelayerWithL2Validity(
      mockAggregator, mockAggregator, _staleThreshold, _staleThreshold
    );

    assertEq(chainlinkRelayerFactory.relayerWithL2ValidityById(1), address(chainlinkRelayerChild));
  }

  function test_Emit_NewRelayer(
    string memory _symbol,
    uint8 _decimals,
    uint256 _staleThreshold
  ) public happyPath(_symbol, _decimals, _staleThreshold) {
    vm.expectEmit();
    emit NewChainlinkRelayer(address(chainlinkRelayer), mockAggregator, _staleThreshold);

    chainlinkRelayerChild = chainlinkRelayerFactory.deployChainlinkRelayer(mockAggregator, _staleThreshold);
    assertEq(chainlinkRelayerChild.symbol(), _symbol);
  }

  function test_Return_Relayer(
    string memory _symbol,
    uint8 _decimals,
    uint256 _staleThreshold
  ) public happyPath(_symbol, _decimals, _staleThreshold) {
    assertEq(
      address(chainlinkRelayerFactory.deployChainlinkRelayer(mockAggregator, _staleThreshold)),
      address(chainlinkRelayer)
    );
  }
}

contract Unit_DenominatedPriceOracleFactory_Constructor is Base {
  event AddAuthorization(address _account);

  modifier happyPath() {
    vm.startPrank(user);
    _;
  }

  function test_Emit_AddAuthorization() public happyPath {
    vm.expectEmit();
    emit AddAuthorization(user);

    denominatedOracleFactory = new DenominatedOracleFactory();
  }
}

contract Unit_Pendle_Deploy_Oracle is Base {
  address mainnetAuthorizedAccount = 0xF78dA2A37049627636546E0cFAaB2aD664950917;
  IPendleRelayerFactory public pendleFactory;

  function setUp() public virtual override {
    super.setUp();
    vm.createSelectFork(vm.envString('ARB_MAINNET_RPC'));
    delayedOracleFactory = IDelayedOracleFactory(MAINNET_DELAYED_ORACLE_FACTORY);
    chainlinkRelayerFactory = ChainlinkRelayerFactory(MAINNET_CHAINLINK_RELAYER_FACTORY);
    denominatedOracleFactory = DenominatedOracleFactory(MAINNET_DENOMINATED_ORACLE_FACTORY);
    pendleFactory = IPendleRelayerFactory(address(new PendleRelayerFactory()));
    label(address(delayedOracleFactory), 'DelayedOracleFactory');
    label(address(chainlinkRelayerFactory), 'ChainlinkRelayerFactory');
    label(address(denominatedOracleFactory), 'DenominatedOracleFactory');
  }

  function test_Deploy_PendleFactory() public view {
    assertEq(pendleFactory.relayerId(), 0);
    assertEq(pendleFactory.authorizedAccounts()[0], address(this));
  }

  function test_Deploy_PT_Oracle() public {
    IBaseOracle ptOracle =
      pendleFactory.deployPendlePtRelayer(MAINNET_PENDLE_RETH_MARKET, MAINNET_PENDLE_ORACLE, uint32(900));
    assertTrue(keccak256(abi.encode(ptOracle.symbol())) != keccak256(abi.encode('')));
    assertEq(uint256(IPendleRelayer(address(ptOracle)).twapDuration()), 900);
    assertEq(address(IPendleRelayer(address(ptOracle)).market()), MAINNET_PENDLE_RETH_MARKET);
    assertEq(address(IPendleRelayer(address(ptOracle)).oracle()), MAINNET_PENDLE_ORACLE);
    assertEq(address(IPendleRelayer(address(ptOracle)).PT()), 0x685155D3BD593508Fe32Be39729810A591ED9c87);
    assertEq(address(IPendleRelayer(address(ptOracle)).SY()), 0xc0Cf4b266bE5B3229C49590B59E67A09c15b22f4);
  }

  function test_Deploy_YT_Oracle() public {
    IBaseOracle ytOracle =
      pendleFactory.deployPendleYtRelayer(MAINNET_PENDLE_RETH_MARKET, MAINNET_PENDLE_ORACLE, uint32(900));
    assertTrue(keccak256(abi.encode(ytOracle.symbol())) != keccak256(abi.encode('')));
    assertEq(uint256(IPendleRelayer(address(ytOracle)).twapDuration()), 900);
    assertEq(address(IPendleRelayer(address(ytOracle)).market()), MAINNET_PENDLE_RETH_MARKET);
    assertEq(address(IPendleRelayer(address(ytOracle)).oracle()), MAINNET_PENDLE_ORACLE);
    assertEq(address(IPendleRelayer(address(ytOracle)).YT()), 0xe822AE44EB2466B4E263b1cbC94b4833dDEf9700);
    assertEq(address(IPendleRelayer(address(ytOracle)).SY()), 0xc0Cf4b266bE5B3229C49590B59E67A09c15b22f4);
  }

  function test_Deploy_LP_Oracle() public {
    IBaseOracle lpOracle =
      pendleFactory.deployPendleLpRelayer(MAINNET_PENDLE_RETH_MARKET, MAINNET_PENDLE_ORACLE, uint32(900));
    assertTrue(keccak256(abi.encode(lpOracle.symbol())) != keccak256(abi.encode('')));
    assertEq(uint256(IPendleRelayer(address(lpOracle)).twapDuration()), 900);
    assertEq(address(IPendleRelayer(address(lpOracle)).market()), MAINNET_PENDLE_RETH_MARKET);
    assertEq(address(IPendleRelayer(address(lpOracle)).oracle()), MAINNET_PENDLE_ORACLE);
    assertEq(address(IPendleRelayer(address(lpOracle)).SY()), 0xc0Cf4b266bE5B3229C49590B59E67A09c15b22f4);
  }

  function test_Deploy_Oracle_Revert_Invalid_Twap() public {
    vm.expectRevert('Invalid TWAP duration');
    pendleFactory.deployPendlePtRelayer(MAINNET_PENDLE_RETH_MARKET, MAINNET_PENDLE_ORACLE, uint32(0));
    vm.expectRevert('Invalid TWAP duration');
    pendleFactory.deployPendleYtRelayer(MAINNET_PENDLE_RETH_MARKET, MAINNET_PENDLE_ORACLE, uint32(0));
    vm.expectRevert('Invalid TWAP duration');
    pendleFactory.deployPendleLpRelayer(MAINNET_PENDLE_RETH_MARKET, MAINNET_PENDLE_ORACLE, uint32(0));
  }

  function test_Deploy_Oracle_Revert_Invalid_Address() public {
    vm.expectRevert('Invalid address');
    pendleFactory.deployPendlePtRelayer(address(0), MAINNET_PENDLE_ORACLE, uint32(900));
    vm.expectRevert('Invalid address');
    pendleFactory.deployPendleYtRelayer(address(0), MAINNET_PENDLE_ORACLE, uint32(900));
    vm.expectRevert('Invalid address');
    pendleFactory.deployPendleLpRelayer(address(0), MAINNET_PENDLE_ORACLE, uint32(900));
  }
}

contract Unit_GMX_Relayer_Factory is Base {
  IGmxRelayerFactory public gmxFactory;
  IGmxReader public gmxReader;
  IGmxDataStore public gmxDataStore;
  IBaseOracle public wethUsdFeed;
  IBaseOracle public usdcUsdFeed;
  address mainnetAuthorizedAccount = 0xF78dA2A37049627636546E0cFAaB2aD664950917;

  function setUp() public virtual override {
    super.setUp();
    vm.createSelectFork(vm.envString('ARB_MAINNET_RPC'));
    delayedOracleFactory = IDelayedOracleFactory(MAINNET_DELAYED_ORACLE_FACTORY);
    chainlinkRelayerFactory = ChainlinkRelayerFactory(MAINNET_CHAINLINK_RELAYER_FACTORY);
    denominatedOracleFactory = DenominatedOracleFactory(MAINNET_DENOMINATED_ORACLE_FACTORY);

    gmxFactory = IGmxRelayerFactory(address(new GmxRelayerFactory()));
    gmxReader = IGmxReader(MAINNET_GMX_READER);
    gmxDataStore = IGmxDataStore(MAINNET_GMX_DATA_STORE);

    vm.startPrank(mainnetAuthorizedAccount);
    usdcUsdFeed = chainlinkRelayerFactory.deployChainlinkRelayerWithL2Validity(
      MAINNET_CHAINLINK_USDC_USD_FEED, MAINNET_CHAINLINK_SEQUENCER_FEED, 3600, 3600
    );
    wethUsdFeed = chainlinkRelayerFactory.deployChainlinkRelayerWithL2Validity(
      MAINNET_CHAINLINK_ETH_USD_FEED, MAINNET_CHAINLINK_SEQUENCER_FEED, 3600, 3600
    );
    vm.stopPrank();

    label(address(delayedOracleFactory), 'DelayedOracleFactory');
    label(address(chainlinkRelayerFactory), 'ChainlinkRelayerFactory');
    label(address(denominatedOracleFactory), 'DenominatedOracleFactory');
    label(address(gmxFactory), 'gmxFactory');
    label(address(usdcUsdFeed), 'usdcUsdFeed');
    label(address(wethUsdFeed), 'wethUsdFeed');
  }

  function test_GmxFactory_Deployment() public view {
    assertEq(gmxFactory.relayerId(), 0);
    assertEq(gmxFactory.authorizedAccounts()[0], address(this));
  }

  function test_Create_GmxGm_Relayer() public {
    IBaseOracle wethGmMarket = gmxFactory.deployGmxGmRelayer(
      MAINNET_GMX_WETH_PERP_MARKET_TOKEN,
      address(gmxReader),
      address(gmxDataStore),
      address(wethUsdFeed),
      address(wethUsdFeed),
      address(usdcUsdFeed)
    );
    (uint256 readValue, bool valid) = wethGmMarket.getResultWithValidity();
    assertGt(readValue, 0);
    assertTrue(valid);
  }
}
