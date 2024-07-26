// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

/**
 * @title   GmxPrice
 * @notice  GMX Price Library
 */
library GmxPrice {
  /**
   * @param min the minimum acceptable price
   * @param max the maximum acceptable price
   */
  struct PriceProps {
    uint256 min;
    uint256 max;
  }
}
