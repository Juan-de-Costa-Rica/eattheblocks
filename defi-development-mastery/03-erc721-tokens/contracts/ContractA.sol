// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract ContractB is ERC721Holder {
    function deposit(uint256 _tokenId) external {}

    function withdraw(uint256 _tokenId) external {}
}

contract ContractA is ERC721Holder {
    IERC721 public token;
    ContractB public contractB;

    constructor(address _token, address _contractB) {
        token = IERC721(_token);
        contractB = ContractB(_contractB);
    }

    function deposit(uint256 _tokenId) external {
        token.safeTransferFrom(msg.sender, address(this), _tokenId);
        token.approve(address(contractB), _tokenId);
        contractB.deposit(_tokenId);
    }

    function withdraw(uint256 _tokenId) external {
        contractB.withdraw(_tokenId);
        token.safeTransferFrom(address(this), msg.sender, _tokenId);
    }
}
