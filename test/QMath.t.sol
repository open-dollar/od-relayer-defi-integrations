// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;
pragma abicoder v2;

import 'forge-std/Test.sol';
import '@script/Registry.s.sol';
import {ChainlinkRelayerFactory} from '@contracts/factories/ChainlinkRelayerFactory.sol';
import {DenominatedOracleFactory} from '@contracts/factories/DenominatedOracleFactory.sol';
import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {MintableERC20} from '@contracts/for-test/MintableERC20.sol';

// forge test --match-contract QMath -vvvvv

/**
 * @dev large price fluctuations in the price of ETH may break these tests
 * in the case of large price fluctuation, adjust INIT_OD_AMOUNT in the Registry to set OD / ETH price
 */
contract QMath is Test {
// using SafeMath for uint256;

// // -- Factories --
// IAlgebraFactory public algebraFactory = IAlgebraFactory(SEPOLIA_ALGEBRA_FACTORY);
// CamelotRelayerFactory public camelotRelayerFactory;
// ChainlinkRelayerFactory public chainlinkRelayerFactory;
// DenominatedOracleFactory public denominatedOracleFactory;

// // -- Tokens --
// MintableERC20 public mockWeth;
// IERC20Metadata public token0;
// IERC20Metadata public token1;

// // -- Liquidity Pool --
// address public pool;
// uint256 public initPrice;

// // -- Relayers
// IBaseOracle public camelotOdWethOracle;
// IBaseOracle public chainlinkEthUSDPriceFeed;
// IBaseOracle public systemOracle;

// function setUp() public {
// uint256 forkId = vm.createFork(vm.rpcUrl('sepolia'));
// vm.selectFork(forkId);
// camelotRelayerFactory = new CamelotRelayerFactory();
// chainlinkRelayerFactory = new ChainlinkRelayerFactory();
// denominatedOracleFactory = new DenominatedOracleFactory();

// mockWeth = new MintableERC20('Wrapped ETH', 'WETH', 18);

// algebraFactory.createPool(SEPOLIA_SYSTEM_COIN, address(mockWeth));
// pool = algebraFactory.poolByPair(SEPOLIA_SYSTEM_COIN, address(mockWeth));

// token0 = IERC20Metadata(IAlgebraPool(pool).token0());
// token1 = IERC20Metadata(IAlgebraPool(pool).token1());

// uint256 inverted;

// // price = token1 / token0
// if (address(token0) == SEPOLIA_SYSTEM_COIN) {
//   require(keccak256(abi.encodePacked('OD')) == keccak256(abi.encodePacked(token0.symbol())), '!OD');
//   initPrice = ((INIT_WETH_AMOUNT * WAD) / INIT_OD_AMOUNT);
// } else {
//   require(keccak256(abi.encodePacked('WETH')) == keccak256(abi.encodePacked(token0.symbol())), '!WETH');
//   initPrice = ((INIT_OD_AMOUNT * WAD) / INIT_WETH_AMOUNT);
//   inverted = 1;
// }

// emit log_named_uint('Inverted', inverted);

// uint256 _sqrtPriceX96 = (Sqrt.sqrtAbs(int256(initPrice)) * (2 ** 96)) / 1e9;

// IAlgebraPool(pool).initialize(uint160(_sqrtPriceX96));

// camelotOdWethOracle = camelotRelayerFactory.deployAlgebraRelayer(
//   SEPOLIA_ALGEBRA_FACTORY, SEPOLIA_SYSTEM_COIN, address(mockWeth), uint32(ORACLE_INTERVAL_TEST)
// );

// chainlinkEthUSDPriceFeed =
//   chainlinkRelayerFactory.deployChainlinkRelayer(SEPOLIA_CHAINLINK_ETH_USD_FEED, ORACLE_INTERVAL_TEST);

// systemOracle =
//   denominatedOracleFactory.deployDenominatedOracle(camelotOdWethOracle, chainlinkEthUSDPriceFeed, false);
// }

// function testChainlinkRelayerPrice() public {
//   uint256 _result = chainlinkEthUSDPriceFeed.read();
//   emit log_named_uint('Chainlink ETH/USD', _result); // 2347556500000000000000 / 1e18 = 2347.556500000000000000

//   assertApproxEqAbs(INIT_OD_AMOUNT / 1e18, _result / 1e18, 500); // $500 flux
// }
}
