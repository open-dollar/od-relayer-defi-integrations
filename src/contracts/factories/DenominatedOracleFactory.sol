// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {DenominatedOracleChild} from '@contracts/factories/DenominatedOracleChild.sol';
import {Authorizable} from '@contracts/utils/Authorizable.sol';
import {IDenominatedOracleFactory} from '@interfaces/factories/IDenominatedOracleFactory.sol';

contract DenominatedOracleFactory is Authorizable, IDenominatedOracleFactory {
  uint256 public oracleId;

  // --- Data ---
  mapping(uint256 => address) public oracleById;

  // --- Init ---
  constructor() Authorizable(msg.sender) {}

  // --- Methods ---
  /// @inheritdoc IDenominatedOracleFactory
  function deployDenominatedOracle(
    IBaseOracle _priceSource,
    IBaseOracle _denominationPriceSource,
    bool _inverted
  ) external isAuthorized returns (IBaseOracle _denominatedOracle) {
    _denominatedOracle =
      IBaseOracle(address(new DenominatedOracleChild(_priceSource, _denominationPriceSource, _inverted)));
    oracleId++;
    oracleById[oracleId] = address(_denominatedOracle);
    emit NewDenominatedOracle(
      address(_denominatedOracle), address(_priceSource), address(_denominationPriceSource), _inverted
    );
  }
}
