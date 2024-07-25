// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';

interface IOracleRegistry {
  // --- Events ---

  /**
   * @notice emmitted when an oracle is added to the registry
   * @param _token the token that the oracle is giving the usd denominated price of
   * @param _denominatedChainlinkFeed the address of the IBaseOracle
   */
  event OracleAdded(address _token, address _denominatedChainlinkFeed);

  /**
   * @notice emitted when an oracle is deleted from the registry
   * @param _token the token whose oracle was cleared
   */
  event OracleCleared(address _token);

  // --- Methods ---

  /**
   * @notice Returns an an IBaseOracle, denominated in usd, for getting the price of the input token
   * @param _token the address of the token who's price you need
   */
  function usdDenominatedFeed(address _token) external returns (IBaseOracle);

  /**
   * @notice Adds a single new oracle to the registry
   * @param _token the address of the token who's oracle is being added
   * @param _denominatedOracle the oracle being added
   */
  function addOracle(address _token, IBaseOracle _denominatedOracle) external;

  /**
   * @notice Adds a multiple new oracles to the registry
   * @param _tokens the address of the token who's oracle is being added
   * @param _denominatedOracles the oracles being added
   */
  function addOracles(address[] memory _tokens, IBaseOracle[] memory _denominatedOracles) external;

  /**
   * @notice Deletes a single oracle in the registry
   * @param _token the address of the token being removed
   */
  function clearOracle(address _token) external;

  /**
   * @notice Fetch the latest oracle result and whether it is valid or not
   * @param _token the address of the token who's result is being fetched
   * @return _result , _validity the oracle result and a bool indicating whether the price is valid
   */
  function getResultWithValidity(address _token) external view returns (uint256 _result, bool _validity);

  /**
   * @notice Fetch the latest oracle result, reverts if invalid
   * @param _token the address of the token who's result is being fetched
   * @return _result
   */
  function read(address _token) external view returns (uint256 _result);

  /**
   * @notice Fetch the symbol of the token oracle
   * @param _token the address of the token who's oracle you'd like the symbol of
   * @return _symbol the oracle symbol
   */
  function symbol(address _token) external view returns (string memory _symbol);

  /**
   * @notice find out if a token has an oracle in the registry
   * @param _token the address of the token you'd like to check
   */
  function isSupported(address _token) external view returns (bool);
}
