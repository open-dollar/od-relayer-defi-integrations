// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {IAuthorizable} from '@interfaces/utils/IAuthorizable.sol';

/**
 * @title IDenominatedOracleFactory
 * @author OpenDollar
 */
interface IDenominatedOracleFactory is IAuthorizable {
  // --- Events ---
  /// @notice emitted when a new denominated oracle is deployed
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
