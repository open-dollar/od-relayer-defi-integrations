// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {Math, WAD} from '@libraries/Math.sol';

/**
 * @notice Transforms two price feeds with a shared token into a new denominated price feed between the other two tokens of the feeds
 * @dev    Requires an external base price feed with a shared token between the price source and the denomination price source
 */
contract DenominatedOracle is IBaseOracle {
  using Math for uint256;

  bool public immutable INVERTED;

  // --- Registry ---
  IBaseOracle public priceSource;
  IBaseOracle public denominationPriceSource;

  // --- Data ---
  string public symbol;

  /**
   *
   * @param  _priceSource Address of the base price source that is used to calculate the price
   * @param  _denominationPriceSource Address of the denomination price source that is used to calculate price
   * @param  _inverted Flag that indicates whether the price source quote should be INVERTED or not
   */
  constructor(IBaseOracle _priceSource, IBaseOracle _denominationPriceSource, bool _inverted) {
    require(address(_priceSource) != address(0));
    require(address(_denominationPriceSource) != address(0));

    priceSource = _priceSource;
    denominationPriceSource = _denominationPriceSource;
    INVERTED = _inverted;

    if (_inverted) {
      symbol = string(abi.encodePacked('(', priceSource.symbol(), ')^-1 / (', denominationPriceSource.symbol(), ')'));
    } else {
      symbol = string(abi.encodePacked('(', priceSource.symbol(), ') * (', denominationPriceSource.symbol(), ')'));
    }
  }

  /// @inheritdoc IBaseOracle
  function getResultWithValidity() external view returns (uint256 _result, bool _validity) {
    (uint256 _priceSourceValue, bool _priceSourceValidity) = priceSource.getResultWithValidity();
    (uint256 _denominationPriceSourceValue, bool _denominationPriceSourceValidity) =
      denominationPriceSource.getResultWithValidity();

    if (INVERTED) {
      if (_priceSourceValue == 0) return (0, false);
      _result = WAD.wmul(_denominationPriceSourceValue).wdiv(_priceSourceValue);
    } else {
      _result = _priceSourceValue.wmul(_denominationPriceSourceValue);
    }

    _validity = _priceSourceValidity && _denominationPriceSourceValidity;
  }

  /// @inheritdoc IBaseOracle
  function read() external view returns (uint256 _result) {
    uint256 _priceSourceValue = priceSource.read();
    uint256 _denominationPriceSourceValue = denominationPriceSource.read();

    if (INVERTED) {
      if (_priceSourceValue == 0) revert('InvalidPriceFeed');
      _priceSourceValue = WAD.wdiv(_priceSourceValue);
    }

    return _priceSourceValue.wmul(_denominationPriceSourceValue);
  }
}
