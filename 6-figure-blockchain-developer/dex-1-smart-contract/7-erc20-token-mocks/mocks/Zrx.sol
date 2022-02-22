// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';

contract Zrx is ERC20 {
  constructor() ERC20('ZRX', '0x token') {}
}