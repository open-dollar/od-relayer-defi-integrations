// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.9;

/**
 * @title   IGmxRoleStore
 *
 * @notice  Gmx RoleStore interface
 */
interface IGmxRoleStore {
  /**
   * @dev Returns the members of the specified role.
   *
   * @param  _roleKey The key of the role.
   * @param  _start   The start index, the value for this index will be included.
   * @param  _end     The end index, the value for this index will not be included.
   * @return          The members of the role.
   */
  function getRoleMembers(bytes32 _roleKey, uint256 _start, uint256 _end) external view returns (address[] memory);
}
