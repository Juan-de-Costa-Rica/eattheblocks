// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ERC721OpenZeppelin is ERC721 {
    constructor() ERC721("Token Name", "Token Symbol") {}
}

contract ERC721OpenZeppelin2 is ERC721 {
    constructor() ERC721("Token Name", "Token Symbol") {
        _safeMint(msg.sender, 0);
    }
}

contract ERC721OpenZeppelin3 is ERC721 {
    address public admin;

    constructor() ERC721("Token Name", "Token Symbol") {
        admin = msg.sender;
    }

    function mint(address _to, uint256 _tokenId) external {
        require(msg.sender == admin, "only admin");
        _safeMint(_to, _tokenId);
    }
}

contract ERC721OpenZeppelin4 is ERC721 {
    constructor() ERC721("Token Name", "Token Symbol") {}

    function faucet(address _to, uint256 _tokenId) external {
        _safeMint(_to, _tokenId);
    }
}
