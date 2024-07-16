// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.6;

uint256 constant WAD = 1e18;

// -- Sepolia --

// DAO
address constant TEST_GOVERNOR = 0x37c5B029f9c3691B3d47cb024f84E5E257aEb0BB;

// Registry of protocol deployment
address constant SEPOLIA_SYSTEM_COIN = 0x36D197e6145B37b8E2c6Ed20B568860835b55584;
address constant SEPOLIA_WETH = 0x980B62Da83eFf3D4576C647993b0c1D7faf17c73;

address constant SEPOLIA_SYSTEM_COIN_NEW = 0x04f2d31052c1f5012C3296710700719FDFe40B41;

// Testnet Params
uint256 constant ORACLE_INTERVAL_TEST = 1 minutes;
uint256 constant MINT_AMOUNT = 1_000_000 ether;
uint256 constant INIT_WETH_AMOUNT = 1 ether;
uint256 constant INIT_OD_AMOUNT = 3500 ether; // $3300 as of April 3, 2024

// Members for governance
address constant H = 0x37c5B029f9c3691B3d47cb024f84E5E257aEb0BB;

// Data for dexrelayer script (for test) and Router for AlgebraPool
address constant RELAYER_DATA = 0x1F17CB9B80192E5C6E9BbEdAcc5F722a4e93f16e;
address constant ROUTER = 0x2a004eA6266eA1A340D1a7D78F1e0F4e9Ae2e685;
address constant RELAYER_ONE = 0xa430DD704aC39756fbA7C26FEAF9A220741c05b0; // DEX pool relayer for `dexrelayer` scripts

// Camelot Relayer
address constant SEPOLIA_CAMELOT_RELAYER_FACTORY = 0x7C85Bceb6DE55f317fe846a2e02100Ac84e94167; // from pre-deployment
address constant SEPOLIA_CAMELOT_RELAYER = address(0); // post setup

// Chainlink Relayer
address constant SEPOLIA_CHAINLINK_RELAYER_FACTORY = 0x67760796Ae4beD0b317ECcd4e482EFca46F10D68; // from pre-deployment
address constant SEPOLIA_CHAINLINK_RELAYER = address(0); // post setup

// Denominated Oracle
address constant SEPOLIA_DENOMINATED_ORACLE_FACTORY = 0x07ACBf81a156EAe49Eaa0eF80bBAe4E050f6278e; // from pre-deployment
address constant SEPOLIA_SYSTEM_ORACLE = address(0); // post setup

// Chainlink feeds
address constant SEPOLIA_CHAINLINK_ETH_USD_FEED = 0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165;
address constant SEPOLIA_CHAINLINK_ARB_USD_FEED = 0xD1092a65338d049DB68D7Be6bD89d17a0929945e;

// Algebra protocol (deployed by daopunk - not official camelot contracts)
address constant SEPOLIA_ALGEBRA_FACTORY = 0x21852176141b8D139EC5D3A1041cdC31F0F20b94;
address constant SEPOLIA_ALGEBRA_POOL_DEPLOYER = 0xca5C849a6ce036cdF83e8F87dCa71Dc2B309E59b;
address constant SEPOLIA_ALGEBRA_QUOTER = 0xf7E25be14E5F5e36d5c2FE7a7822A601d18CD120;
address constant SEPOLIA_ALGEBRA_SWAPROUTER = 0xD18583a01837c9Dc4dC02E2202955E9d71C08771;
address constant SEPOLIA_ALGEBRA_NFT_DESCRIPTOR = 0x88Fa9f46645C7c638fFA9675b36DfdeF2cbae296;
address constant SEPOLIA_ALGEBRA_PROXY = 0xDAed3376f8112570a9E319A1D425C9B37CA901B3;
address constant SEPOLIA_ALGEBRA_NFT_MANAGER = 0xAf588D87BaDE8654F26686D5502be8ceDbE8FFe0;
address constant SEPOLIA_ALGEBRA_INTERFACE_MULTICALL = 0xf94b8a5D6dBd8F4026Ae467fdDB96028F74b9B96;
address constant SEPOLIA_ALGEBRA_V3_MIGRATOR = 0x766682889b8A6070be210C2a821Ad671E3388ab3;
address constant SEPOLIA_ALGEBRA_LIMIT_FARMING = 0x62B46a9565C7ECEc4FE7Dd309174ac3B03AF44E2;
address constant SEPOLIA_ALGEBRA_ETERNAL_FARMING = 0xD8474356C6976E18275735531b22f3Aa872a8b3B;
address constant SEPOLIA_ALGEBRA_FARM_CENTER = 0x04e4A5A4E4D2A5a0fb48ECde0bbD5554652D254b;

// -- Mainnet --

////////// FACTORIES //////////
address constant MAINNET_CAMELOT_RELAYER_FACTORY = 0x36645830479170265A154Acb726780fdaE41A28F;
address constant MAINNET_CHAINLINK_RELAYER_FACTORY = 0x06C32500489C28Bd57c551afd8311Fef20bFaBB5;
address constant MAINNET_DENOMINATED_ORACLE_FACTORY = 0xBF760b23d2ef3615cec549F22b95a34DB0F8f5CD;
address constant MAINNET_ALGEBRA_FACTORY = 0x1a3c9B1d2F0529D97f2afC5136Cc23e58f1FD35B;
address constant MAINNET_DELAYED_ORACLE_FACTORY = 0x9Dd63fA54dEfd8820BCAb3e3cC39aeEc1aE88098;

////////// RELAYERS //////////
// Camelot
address constant MAINNET_CAMELOT_ODG_WETH_RELAYER = 0xF7Ec9ad3192d4ec1E54d52B3E492B5B66AB02889;
// Chainlink
address constant MAINNET_CHAINLINK_ETH_USD_RELAYER = 0x3e6C1621f674da311E57646007fBfAd857084383;
address constant MAINNET_CHAINLINK_L2VALIDITY_ETH_USD_RELAYER = 0x4617Feb8B72167c3b8253a1327CddE44e54670Ce;
address constant MAINNET_CHAINLINK_RETH_ETH_RELAYER = 0x2b98972Ee61e8928F9dFa6504301296f0e7645Ca;
address constant MAINNET_CHAINLINK_WSTETH_ETH_RELAYER = 0x48D3B7605B8dc3Ae231Bd59e40513C9e9Ac6D33a;
address constant MAINNET_CHAINLINK_ARB_USD_RELAYER = 0x2635f731BB6981E72F92A781578952450759F762;
// Denominated
address constant MAINNET_DENOMINATED_ODG_USD_ORACLE = 0xE90E52eb676bc00DD85FAE83D2FAC22062F7f470;
address constant MAINNET_DENOMINATED_RETH_USD_ORACLE = 0xE0ac4511A617cBee55ECb62667B08DB6864B9d8e;
address constant MAINNET_DENOMINATED_WSTETH_USD_ORACLE = 0x8746664d1E0F0e61275EF3B52A8a3b3dFC11CcAb;
// Delayed
address constant MAINNET_DELAYED_RETH_USD_ORACLE = 0x0859c0B3EF150fAb129E43B74a63da13F5d2Dd35;
address constant MAINNET_DELAYED_WSTETH_USD_ORACLE = 0xa8dEa011Ed90C53BA4601868Ccc9a36A6F442499;
address constant MAINNET_DELAYED_ARB_USD_ORACLE = 0xa4e0410E7eb9a02aa9C0505F629d01890c816A77;
address constant MAINNET_DELAYED_ETH_USD_ORACLE = 0x562CCE2F4dc383862dC6A926AF10DeFf5fCd172F;

////////// CHAINLINK //////////
// Price feeds to USD
address constant MAINNET_CHAINLINK_ETH_USD_FEED = 0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612;
address constant MAINNET_CHAINLINK_ARB_USD_FEED = 0xb2A824043730FE05F3DA2efaFa1CBbe83fa548D6;
// Price feeds to ETH
address constant MAINNET_CHAINLINK_RETH_ETH_FEED = 0xD6aB2298946840262FcC278fF31516D39fF611eF;
address constant MAINNET_CHAINLINK_WSTETH_ETH_FEED = 0xb523AE262D20A936BC152e6023996e46FDC2A95D;
address constant MAINNET_CHAINLINK_CBETH_ETH_FEED = 0xa668682974E3f121185a3cD94f00322beC674275;
address constant MAINNET_CHAINLINK_LINK_USD_FEED = 0x86E53CF1B870786351Da77A57575e79CB55812CB;
address constant MAINNET_CHAINLINK_GRT_USD_FEED = 0x0F38D86FceF4955B705F35c9e41d1A16e0637c73;

// Sequencer for Arbitrum One
address constant MAINNET_CHAINLINK_SEQUENCER_FEED = 0xFdB631F5EE196F0ed6FAa767959853A9F217697D;

////////// PARAMS //////////
address constant MAINNET_DEPLOYER = 0xF78dA2A37049627636546E0cFAaB2aD664950917;
uint256 constant MAINNET_ORACLE_DELAY = 1 hours;
uint256 constant MAINNET_CHAINLINK_L2VALIDITY_GRACE_PERIOD = 1 hours;
address constant MAINNET_PROTOCOL_TOKEN = 0x000D636bD52BFc1B3a699165Ef5aa340BEA8939c;
address constant MAINNET_WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
address constant ETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
address constant ARB = 0x912CE59144191C1204E64559FE8253a0e49E6548;
address constant ETH_ARB_POOL = 0xe51635ae8136aBAc44906A8f230C2D235E9c195F;

//////RENZO
address constant MAINNET_CHAINLINK_EZETH_ETH_FEED = 0x11E1836bFF2ce9d6A5bec9cA79dc998210f3886d;

//Pendle
uint32 constant MAINNET_PENDLE_TWAP_DURATION = 900;
address constant MAINNET_PENDLE_ORACLE = 0x9a9Fa8338dd5E5B2188006f1Cd2Ef26d921650C2;
address constant MAINNET_PENDLE_RETH_MARKET = 0x14FbC760eFaF36781cB0eb3Cb255aD976117B9Bd;
address constant MAINNET_PENDLE_WSTETH_MARKET = 0x08a152834de126d2ef83D612ff36e4523FD0017F;

