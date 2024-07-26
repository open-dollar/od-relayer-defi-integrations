// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {IAuthorizable} from '@interfaces/utils/IAuthorizable.sol';

/**
 * @title IPendleRelayerFactory
 * @author OpenDollar
 */
interface IPendleRelayerFactory is IAuthorizable {
  // --- Events ---
  event NewPendlePtRelayer(address indexed _market, address _oracle, uint32 _twapDuration);
  event NewPendleYtRelayer(address indexed _market, address _oracle, uint32 _twapDuration);
  event NewPendleLpRelayer(address indexed _market, address _oracle, uint32 _twapDuration);

  // --- Methods ---

  /**
   * @return the current relayer id
   */
  function relayerId() external view returns (uint256);

  /**
   * @notice deploys a pendle Principal Token oracle.
   * @param _market the address of the pendle market
   * @param _oracle the address of the pendle oracle contract
   * @param _twapDuration the desired twap interval in seconds (recommended 900s)
   */
  function deployPendlePtRelayer(
    address _market,
    address _oracle,
    uint32 _twapDuration
  ) external returns (IBaseOracle _pendlePtRelayerChild);

  /**
   * @notice deploys a pendle Yield Token oracle
   * @param _market the address of the pendle market
   * @param _oracle the address of the pendle oracle contract
   * @param _twapDuration the desired twap interval in seconds (recommended 900s)
   */
  function deployPendleYtRelayer(
    address _market,
    address _oracle,
    uint32 _twapDuration
  ) external returns (IBaseOracle _pendleYtRelayerChild);

  /**
   * @notice deploys a pendle liquidity pool token oracle
   * @param _market the address of the pendle market
   * @param _oracle the address of the pendle oracle contract
   * @param _twapDuration the desired twap interval in seconds (recommended 900s)
   */
  function deployPendleLpRelayer(
    address _market,
    address _oracle,
    uint32 _twapDuration
  ) external returns (IBaseOracle _pendleLpRelayerChild);
}
