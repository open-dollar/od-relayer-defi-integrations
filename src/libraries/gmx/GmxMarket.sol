// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import {GmxPrice} from './GmxPrice.sol';

/**
 * @title   GmxMarket
 *
 * @notice  GMX Market Library
 */
library GmxMarket {
  /**
   * @param marketToken the address of the gm token contract
   * @param indexToken the address of the contract of the token being traded in the perp market.  address(0) for a swap market
   * @param longToken the address of the token backing long positions.  often the same as the index token
   * @param shortToken the address of the token backing short positions.  often a stable coin
   */
  struct MarketProps {
    address marketToken;
    address indexToken;
    address longToken;
    address shortToken;
  }

  /**
   * @param indexTokenPrice the price of the index token
   * @param longToken price the price of the long token
   * @param shortTokenPrice the price of the short token
   */
  struct MarketPrices {
    GmxPrice.PriceProps indexTokenPrice;
    GmxPrice.PriceProps longTokenPrice;
    GmxPrice.PriceProps shortTokenPrice;
  }
}
