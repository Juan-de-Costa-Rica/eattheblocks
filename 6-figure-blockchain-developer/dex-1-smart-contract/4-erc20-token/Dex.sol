// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.12;


contract Dex {
    struct Token {
        bytes32 ticker;
        address tokenAddress;
    }

    mapping(bytes32 => Token) public tokenMap;
    bytes32[] public tokenList;
    mapping(address => mapping(bytes32 => uint)) public traderBalances;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function addToken(
        bytes32 ticker,
        address tokenAddress
    ) external onlyAdmin {
        tokenMap[ticker] = Token(ticker, tokenAddress);
        tokenList.push(ticker);
    }

    modifier onlyAdmin {
        require(msg.sender == admin, 'only admin');
        _;
    }
}