// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CollateralBackedToken is ERC20 {
    IERC20 public collateral;
    uint256 public price = 1;

    constructor(address _collateral) ERC20("Collateral Backed Token", "CBT") {
        collateral = IERC20(_collateral);
    }

    function deposit(uint256 _collateralAmount) external {
        collateral.transferFrom(msg.sender, address(this), _collateralAmount);
        _mint(msg.sender, _collateralAmount * price);
    }

    function withdraw(uint256 _tokenAmount) external {
        require(balanceOf(msg.sender) >= _tokenAmount, "balance too low");
        _burn(msg.sender, _tokenAmount);
        collateral.transfer(msg.sender, _tokenAmount / price);
    }
}
