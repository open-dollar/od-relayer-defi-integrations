// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {IChainlinkRelayerFactory} from '@interfaces/factories/IChainlinkRelayerFactory.sol';
import {IDenominatedOracleFactory} from '@interfaces/factories/IDenominatedOracleFactory.sol';
import {IChainlinkRelayer} from '@interfaces/oracles/IChainlinkRelayer.sol';
import {IDenominatedOracle} from '@interfaces/oracles/IDenominatedOracle.sol';

contract Data {
  // Tokens
  address public tokenA;
  address public tokenB;

  // Factories
  IChainlinkRelayerFactory public chainlinkRelayerFactory;
  IDenominatedOracleFactory public denominatedOracleFactory;

  // Relayers
  IChainlinkRelayer public chainlinkRelayer;
  IDenominatedOracle public denominatedOracle;

  // function generateTickParams() public view returns (int24 bottomTick, int24 topTick) {
  //   (, int24 tick,,,,,) = pool.globalState();
  //   int24 tickSpacing = pool.tickSpacing();
  //   bottomTick = ((tick / tickSpacing) * tickSpacing) - 3 * tickSpacing;
  //   topTick = ((tick / tickSpacing) * tickSpacing) + 3 * tickSpacing;
  // }

  function setTokens(address _t0, address _t1) public {
    tokenA = _t0;
    tokenB = _t1;
  }

  function modifyFactory(bytes32 _param, address _factory) public {
    if (_param == 'chainlinkRelayerFactory') chainlinkRelayerFactory = IChainlinkRelayerFactory(_factory);
    else if (_param == 'denominatedOracleFactory') denominatedOracleFactory = IDenominatedOracleFactory(_factory);
    else revert('Factory not set');
  }

  function modifyOracle(bytes32 _param, address _oracle) public {
    if (_param == 'chainlinkRelayer') chainlinkRelayer = IChainlinkRelayer(_oracle);
    else if (_param == 'denominatedOracle') denominatedOracle = IDenominatedOracle(_oracle);
    else revert('Oracle not set');
  }
}
