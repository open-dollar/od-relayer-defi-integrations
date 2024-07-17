// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.6;
pragma abicoder v2;

import '@script/Registry.s.sol';
import {DSTestPlus} from '@test/utils/DSTestPlus.t.sol';
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

  address chainlinkRelayer = 0x56D9e6a12fC3E3f589Ee5E685C9f118D62ce9C8D;

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

contract Unit_DenominatedPriceOracleFactory_DeployDenominatedOracle is Base {
  event NewDenominatedOracle(
    address indexed _denominatedOracle, address _priceSource, address _denominationPriceSource, bool _inverted
  );

  address denominatedOracle = 0xb2A72B7BA8156A59fD84c61e5eF539d385D8652a;

  modifier happyPath() {
    vm.startPrank(authorizedAccount);
    _;
  }

  function setUp() public override {
    super.setUp();
    vm.startPrank(authorizedAccount);
    vm.mockCall(address(mockBaseToken), abi.encodeWithSignature('symbol()'), abi.encode('BaseToken'));
    vm.mockCall(address(mockQuoteToken), abi.encodeWithSignature('symbol()'), abi.encode('QuoteToken'));
    vm.mockCall(address(mockAggregator), abi.encodeWithSignature('description()'), abi.encode('Aggregator'));
    vm.mockCall(address(mockBaseToken), abi.encodeWithSignature('decimals()'), abi.encode(18));
    vm.mockCall(address(mockQuoteToken), abi.encodeWithSignature('decimals()'), abi.encode(18));
    vm.mockCall(address(mockAggregator), abi.encodeWithSignature('decimals()'), abi.encode(18));

    chainlinkRelayerChild = chainlinkRelayerFactory.deployChainlinkRelayer(mockAggregator, 100);
    _mockToken0(address(mockBaseToken));
    _mockToken1(address(mockQuoteToken));

    vm.stopPrank();
  }

  function test_Deploy_RelayerChild() public happyPath {
    vm.expectEmit();
    emit NewDenominatedOracle(
      address(denominatedOracle), address(camelotRelayerChild), address(chainlinkRelayerChild), false
    );
    denominatedOracleChild =
      denominatedOracleFactory.deployDenominatedOracle(camelotRelayerChild, chainlinkRelayerChild, false);

    string memory symbol =
      string(abi.encodePacked('(', mockBaseToken.symbol(), ' / ', mockQuoteToken.symbol(), ') * (Aggregator)'));
    assertEq(denominatedOracleChild.symbol(), symbol);
  }

  function test_Deploy_RelayerChildInverted() public happyPath {
    vm.expectEmit();
    emit NewDenominatedOracle(
      address(denominatedOracle), address(camelotRelayerChild), address(chainlinkRelayerChild), true
    );
    denominatedOracleChild =
      denominatedOracleFactory.deployDenominatedOracle(camelotRelayerChild, chainlinkRelayerChild, true);

    string memory symbol =
      string(abi.encodePacked('(', mockBaseToken.symbol(), ' / ', mockQuoteToken.symbol(), ')^-1 / (Aggregator)'));
    assertEq(denominatedOracleChild.symbol(), symbol);
  }

  function test_Set_Relayers() public happyPath {
    denominatedOracleChild =
      denominatedOracleFactory.deployDenominatedOracle(camelotRelayerChild, chainlinkRelayerChild, false);
    assertEq(denominatedOracleFactory.oracleById(1), address(denominatedOracleChild));
  }

  function test_Emit_NewRelayer() public happyPath {
    vm.expectEmit();
    emit NewDenominatedOracle(
      address(denominatedOracle), address(camelotRelayerChild), address(chainlinkRelayerChild), false
    );
    denominatedOracleChild =
      denominatedOracleFactory.deployDenominatedOracle(camelotRelayerChild, chainlinkRelayerChild, false);
  }

  function test_Return_Relayer() public happyPath {
    assertEq(
      address(denominatedOracleFactory.deployDenominatedOracle(camelotRelayerChild, chainlinkRelayerChild, false)),
      address(denominatedOracle)
    );
  }
}

contract Unit_Pendle_Renzo_Deploy_Oracle is Base {
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

  function test_DeployEzEthRelayer() public {
    vm.startPrank(mainnetAuthorizedAccount);
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

    string memory _ezEthSymbol = _ezEthUsdDelayedOracle.symbol(); // "(EZETH / ETH) * (ETH / USD)"
    vm.stopPrank();
    assertEq(_ezEthSymbol, '(ezETH / ETH) * (ETH / USD)');
  }

  function test_Deploy_PendleFactory() public {
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
    assertEq(address(IPendleRelayer(address(ptOracle)).YT()), 0xe822AE44EB2466B4E263b1cbC94b4833dDEf9700);
    assertEq(address(IPendleRelayer(address(ptOracle)).SY()), 0xc0Cf4b266bE5B3229C49590B59E67A09c15b22f4);
  }

  function test_Deploy_YT_Oracle() public {
    IBaseOracle ytOracle =
      pendleFactory.deployPendleYtRelayer(MAINNET_PENDLE_RETH_MARKET, MAINNET_PENDLE_ORACLE, uint32(900));
    assertTrue(keccak256(abi.encode(ytOracle.symbol())) != keccak256(abi.encode('')));
    assertEq(uint256(IPendleRelayer(address(ytOracle)).twapDuration()), 900);
    assertEq(address(IPendleRelayer(address(ytOracle)).market()), MAINNET_PENDLE_RETH_MARKET);
    assertEq(address(IPendleRelayer(address(ytOracle)).oracle()), MAINNET_PENDLE_ORACLE);
    assertEq(address(IPendleRelayer(address(ytOracle)).PT()), 0x685155D3BD593508Fe32Be39729810A591ED9c87);
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
    assertEq(address(IPendleRelayer(address(lpOracle)).PT()), 0x685155D3BD593508Fe32Be39729810A591ED9c87);
    assertEq(address(IPendleRelayer(address(lpOracle)).YT()), 0xe822AE44EB2466B4E263b1cbC94b4833dDEf9700);
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
