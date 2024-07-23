// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {IAuthorizable} from '@interfaces/utils/IAuthorizable.sol';

interface IGmxRelayerFactory is IAuthorizable {
  // --- Events ---
  event NewGmxGmRelayer(address _newGmxRelayerChild, address _marketToken);

  // --- Methods ---

  function relayerId() external view returns (uint256);

  function deployGmxGmRelayer(
    address _marketToken,
    address _gmxReader,
    address _dataStore,
    address _indexTokenOracle,
    address _longTokenOracle,
    address _shortTokenOracle
  ) external returns (IBaseOracle _gmxGmRelayerChild);
}
