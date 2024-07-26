// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {ChainlinkRelayer} from '@contracts/oracles/ChainlinkRelayer.sol';
import {DataConsumerSequencerCheck} from '@contracts/oracles/DataConsumerSequencerCheck.sol';
import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';

contract ChainlinkRelayerWithL2Validity is IBaseOracle, ChainlinkRelayer, DataConsumerSequencerCheck {
  constructor(
    address _priceAggregator,
    address _sequencerAggregator,
    uint256 _staleThreshold,
    uint256 _gracePeriod
  ) ChainlinkRelayer(_priceAggregator, _staleThreshold) DataConsumerSequencerCheck(_sequencerAggregator, _gracePeriod) {}

  /// @inheritdoc IBaseOracle
  function getResultWithValidity()
    public
    view
    override(IBaseOracle, ChainlinkRelayer)
    returns (uint256 _result, bool _validity)
  {
    (_result, _validity) = super.getResultWithValidity();
    if (_validity) {
      _validity = getSequencerFeedValidation();
    }
  }

  /// @inheritdoc IBaseOracle
  function read() public view override(IBaseOracle, ChainlinkRelayer) returns (uint256 _result) {
    require(getSequencerFeedValidation(), 'SequencerDown');
    _result = super.read();
  }
}
