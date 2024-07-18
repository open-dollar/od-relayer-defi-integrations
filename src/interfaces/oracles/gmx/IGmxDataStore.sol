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
  function getInt(bytes32 key) external view returns (int256);
  function getAddress(bytes32 key) external view returns (address);
  function getString(bytes32 key) external view returns (string memory);
  function getBytes32(bytes32 key) external view returns (bytes32);
  function getUintArray(bytes32 key) external view returns (uint256[] memory);
  function getAddressArray(bytes32 key) external view returns (address[] memory);
  function getBoolArray(bytes32 key) external view returns (bool[] memory);
  function getStringArray(bytes32 key) external view returns (string[] memory);
  function getBytes32Array(bytes32 key) external view returns (bytes32[] memory);
  function getBytes32Count(bytes32 setKey) external view returns (uint256);
  function getBytes32ValuesAt(bytes32 setKey, uint256 start, uint256 end) external view returns (bytes32[] memory);
  function getAddressCount(bytes32 setKey) external view returns (uint256);
  function getAddressValuesAt(bytes32 setKey, uint256 start, uint256 end) external view returns (address[] memory);
  function getUintCount(bytes32 setKey) external view returns (uint256);
  function roleStore() external view returns (IGmxRoleStore);
}
