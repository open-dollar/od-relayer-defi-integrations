// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {IAuthorizable} from '@interfaces/utils/IAuthorizable.sol';

/**
 * @title IGmxRelayerFactory
 * @author OpenDollar
 */
interface IGmxRelayerFactory is IAuthorizable {
  // --- Events ---
  event NewGmxGmRelayer(address _newGmxRelayerChild, address _marketToken);

  // --- Methods ---

  /**
   * @return the current relayer id
   */
  function relayerId() external view returns (uint256);

  /**
   * @notice deploys a Gm token oracle with fixed chainlink oracles
   * @param _marketToken the address of the gmx Market token
   * @param _gmxReader the address of the gmx reader contract
   * @param _dataStore the address of the gmx data store contract
   * @param _indexTokenOracle the address of the usd denominated chainlink relayer for the index token
   * @param _longTokenOracle the address of the usd denominated chainlink relayer for the long token
   * @param _shortTokenOracle the address of the usd denominated chainlink relayer for the short token
   * @return _gmxGmRelayerChild the IBaseOracle contract
   */
  function deployGmxGmRelayer(
    address _marketToken,
    address _gmxReader,
    address _dataStore,
    address _indexTokenOracle,
    address _longTokenOracle,
    address _shortTokenOracle
  ) external returns (IBaseOracle _gmxGmRelayerChild);

  /**
   * @notice deploys a Gm token oracle with using the oracle registry
   * @param _marketToken the address of the gmx Market token
   * @param _gmxReader the address of the gmx reader contract
   * @param _dataStore the address of the gmx data store contract
   * @param _oracleRegistry the address of the openDollar oracle registry
   * @return _gmxGmRelayerChild the IBaseOracle contract
   */
  function deployGmxGmRelayerWithRegistry(
    address _marketToken,
    address _gmxReader,
    address _dataStore,
    address _oracleRegistry
  ) external returns (IBaseOracle _gmxGmRelayerChild);
}
