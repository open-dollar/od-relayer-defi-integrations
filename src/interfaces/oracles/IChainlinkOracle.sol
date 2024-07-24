// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

interface IChainlinkOracle {
  /**
   * @notice returns the decimals of the result
   */
  function decimals() external view returns (uint8 _decimals);

  /**
   * @notice returns the oracle description
   */
  function description() external view returns (string memory _description);

  /**
   * @notice gets the answer for a specific roundId
   * @param _roundId the round Id
   * @return _answer the answer
   */
  function getAnswer(uint256 _roundId) external view returns (int256 _answer);

  /**
   * @notice Retrieves Round data for a specific round
   * @param __roundId the id of the desired round
   * @return _roundId , _answer , _startedAt , _updateAt , _answeredInRound the round data
   */
  function getRoundData(uint256 __roundId)
    external
    view
    returns (uint256 _roundId, int256 _answer, uint256 _startedAt, uint256 _updatedAt, uint256 _answeredInRound);

  /**
   * @notice Retrieves the timestamp of a spcific round
   * @param _roundId the round Id
   * @return _timestamp the timestamp of the round
   */
  function getTimestamp(uint256 _roundId) external view returns (uint256 _timestamp);

  /**
   * @notice Retrieves the latest round answer
   * @return _latestAnswer the latest answer
   */
  function latestAnswer() external view returns (int256 _latestAnswer);

  /**
   * @notice Retrieves the roundId of the latest round
   * @return _latestRound the latest round Id
   */
  function latestRound() external view returns (uint256 _latestRound);

  /**
   * @notice Retrieves Round data for the latest round
   * @return _roundId , _answer , _startedAt , _updateAt , _answeredInRound the round data
   */
  function latestRoundData()
    external
    view
    returns (uint256 _roundId, int256 _answer, uint256 _startedAt, uint256 _updatedAt, uint256 _answeredInRound);
  function latestTimestamp() external view returns (uint256 _latestTimestamp);
}
