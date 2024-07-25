// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';

/**
 * @title IDenominatedOracleFactory
 * @author OpenDollar
 */
interface IDenominatedOracleFactory {
  // --- Events ---
  event NewDenominatedOracle(
    address indexed _denominatedOracle, address _priceSource, address _denominationPriceSource, bool _inverted
  );

  /**
   * @notice deploys a denominated chainlink oracle
   * @param _priceSource the address of the price source token -> eth
   * @param _denominationPriceSource the address of the denomination source eth -> usd
   * @return _denominatedOracle the denominated base oracle
   */
  function deployDenominatedOracle(
    IBaseOracle _priceSource,
    IBaseOracle _denominationPriceSource,
    bool _inverted
  ) external returns (IBaseOracle _denominatedOracle);
}
