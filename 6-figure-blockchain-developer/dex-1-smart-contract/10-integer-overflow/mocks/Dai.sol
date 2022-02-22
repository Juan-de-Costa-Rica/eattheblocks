// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Dai is ERC20 {
  constructor() ERC20('Dai', 'Dai Stablecoin') {}
}