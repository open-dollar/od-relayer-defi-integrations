// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {IAuthorizable} from '@interfaces/utils/IAuthorizable.sol';

interface IChainlinkRelayerFactory is IAuthorizable {
  // --- Events ---
  /// @notice emitted when a new chainlink relayer is deployed
  event NewChainlinkRelayer(address indexed _chainlinkRelayer, address _aggregator, uint256 _staleThreshold);
  /// @notice emitted when a new chainlink relayer with L2 validity is deployed
  event NewChainlinkRelayerWithL2Validity(
    address indexed _chainlinkRelayer,
    address _priceAggregator,
    address _sequencerAggregator,
    uint256 _staleThreshold,
    uint256 _gracePeriod
  );

  // --- Methods ---

  /**
   * @notice deploys a chainlink relayer
   * @param _aggregator the address of the chainlink price aggregator
   * @param _staleThreshold time in seconds of the stale threshold (recommended 3600 seconds)
   * @return _relayer the IBaseOracle chainlink relayer
   */
  function deployChainlinkRelayer(address _aggregator, uint256 _staleThreshold) external returns (IBaseOracle _relayer);

  /**
   * @notice deploys a chainlink relayer with L2 validity
   * @param _priceAggregator the address of the chainlink price aggregator
   * @param _sequencerAggregator the address of the chainlink sequencer
   * @param _staleThreshold time in seconds of the stale threshold (recommended 3600 seconds)
   * @param _gracePeriod the grace period in seconds
   * @return _chainlinkRelayer the IBaseOracle chainlink relayer
   */
  function deployChainlinkRelayerWithL2Validity(
    address _priceAggregator,
    address _sequencerAggregator,
    uint256 _staleThreshold,
    uint256 _gracePeriod
  ) external returns (IBaseOracle _chainlinkRelayer);
}
