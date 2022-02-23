// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Weth is ERC20 {
    constructor() ERC20("Wrapped Ether", "WETH") {}

    function deposit() external payable {
        _mint(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external {
        require(balanceOf(msg.sender) >= _amount, "balance too low");
        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(_amount);
    }
}
