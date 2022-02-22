// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.12;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract Dex {
    
    enum Side {
        BUY,
        SELL
    }
    struct Token {
        bytes32 ticker;  
        address tokenAddress;
    }

    struct Order {
        uint id;
        Side side;
        bytes32 ticker;
        uint amount;
        uint filled;
        uint price;
        uint date;
    }

    mapping(bytes32 => Token) public tokens;
    bytes32[] public tokenList;
    mapping(address => mapping(bytes32 => uint)) public traderBalances;
    mapping(bytes32 => mapping(uint => Order[])) public orderBook;
    address public admin;
    uint public nextOrderId;
    bytes32 constant DAI = bytes32('DAI');

    constructor() {
        admin = msg.sender;
    }

    function addToken(
        bytes32 ticker,
        address tokenAddress
    ) external onlyAdmin {
        tokens[ticker] = Token(ticker, tokenAddress);
        tokenList.push(ticker);
    }

    function deposit(
        uint amount,
        bytes32 ticker
    ) external tokenExist(ticker) {
        IERC20(tokens[ticker].tokenAddress).transferFrom(
            msg.sender,
            address(this),
            amount
        );
        traderBalances[msg.sender][ticker] += amount;
    }

    function withdraw(
        uint amount,
        bytes32 ticker
    ) external tokenExist(ticker){
        require(
            traderBalances[msg.sender][ticker] >= amount,
            'balance too low'
        ); 
        traderBalances[msg.sender][ticker] -= amount;
        IERC20(tokens[ticker].tokenAddress).transfer(msg.sender, amount);
    }

    function createLimitOrder(
        bytes32 ticker,
        uint amount,
        uint price,
        Side side
    ) external tokenExist(ticker)  {
        require(ticker != DAI, 'cannot trade DAI');
        if(side == Side.SELL) {
            require(
                traderBalances[msg.sender][ticker] >= amount, 
                'token balance too low'
            );
        } else {
            require(
                traderBalances[msg.sender][DAI] >= amount * price,
                'dai balance too low'
            );
        }
        Order[] storage orders = orderBook[ticker][uint(side)];
        orders.push(Order(
            nextOrderId,
            side,
            ticker,
            amount,
            0,
            price,
            block.timestamp
        ));
        
        uint i = orders.length - 1;
        while(i > 0) {
            if(side == Side.BUY && orders[i - 1].price > orders[i].price) {
                break;   
            }
            if(side == Side.SELL && orders[i - 1].price < orders[i].price) {
                break;   
            }
            Order memory order = orders[i - 1];
            orders[i - 1] = orders[i];
            orders[i] = order;
            i--;
        }
        nextOrderId++;
    }

    modifier tokenExist(bytes32 ticker) {
        require(
            tokens[ticker].tokenAddress != address(0),
            'this token does not exist'
        );
        _;
    }

    modifier onlyAdmin {
        require(msg.sender == admin, 'only admin');
        _;
    }
}