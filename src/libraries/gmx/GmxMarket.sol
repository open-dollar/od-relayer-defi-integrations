// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import {GmxPrice} from './GmxPrice.sol';

/**
 * @title   GmxMarket
 *
 * @notice  GMX Market Library
 */
library GmxMarket {
  struct MarketProps {
    address marketToken;
    address indexToken;
    address longToken;
    address shortToken;
  }

  struct MarketPrices {
    GmxPrice.PriceProps indexTokenPrice;
    GmxPrice.PriceProps longTokenPrice;
    GmxPrice.PriceProps shortTokenPrice;
  }
}
