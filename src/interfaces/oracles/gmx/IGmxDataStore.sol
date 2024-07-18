// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.9;

import {IGmxRoleStore} from './IGmxRoleStore.sol';

/**
 * @title   IGmxDataStore
 *
 * @notice  Gmx DataStore interface
 */
interface IGmxDataStore {
  function setUint(bytes32 _key, uint256 _value) external returns (uint256);

  function setBool(bytes32 _key, bool _bool) external returns (bool);

  function getBool(bytes32 _key) external view returns (bool);

  function getUint(bytes32 _key) external view returns (uint256);

  function roleStore() external view returns (IGmxRoleStore);
}
