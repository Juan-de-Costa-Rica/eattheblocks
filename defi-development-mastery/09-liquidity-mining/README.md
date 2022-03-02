# 9. Liquidity Mining

### Setup

- `truffle init`

- _Edit truffle-config.js_
  
  - ```javascript
      // Configure your compilers
      compilers: {
        solc: {
          version: "0.8.12", // Fetch exact version from solc-bin
        },
    ```
  
  - ```javascript
        development: {
          host: "127.0.0.1", // Localhost (default: none)
          port: 8545, // Standard Ethereum port (default: none)
          network_id: "*", // Any network (default: none)
        },
    ```

- `npm init -y`

- `npm install @openzeppelin/contracts`

- `touch contracts/GovernanceToken.sol`

- `touch contracts/LiquidityPool.sol`

- `touch contracts/LpToken.sol`

- `touch contracts/UnderlyingToken.sol`



### GovernanceToken.sol

- Import @openzeppelin  and create contract with `ERC20` and `Ownable`
  
  - ```javascript
    // SPDX-License-Identifier: UNLICENSED
    pragma solidity 0.8.12;
    
    import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
    import "@openzeppelin/contracts/access/Ownable.sol";
    
    contract GovernanceToken is ERC20, Ownable {
        ...
    }
    ```
  
  - Only the owner of the contract will be able to mint new governance tokens
  
  - The owner of this contract will be the liquidity pool
    
    

- **Constructor**
  
  - ```javascript
        constructor() ERC20("Governance Token", "GTK") Ownable() {}
    ```
  
  - Call `Ownable()` on constructor so the deployer of the contract will be the owner
    
    

- **Mint function**
  
  - ```javascript
    function mint(address to, uint256 amount) external onlyOwner {
            _mint(to, amount);
        }
    ```
  
  - `onlyOwner()` function provided by the `Ownable` contract of openzeppelin
  
  - `_mint()`_function provided by `ERC20` contract of openzeppelin
    
    - When we want to distribute the governance token we will call this function



### LpToken.sol

- **Basic ERC20 token**
  
  - ```javascript
    // SPDX-License-Identifier: UNLICENSED
    pragma solidity 0.8.12;
    
    import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
    
    contract LpToken is ERC20 {
        constructor() ERC20("Lp Token", "LTK") {}
    }
    ```

### UnderlyingToken.sol

- **Basic ERC20 token**
  
  - ```javascript
    // SPDX-License-Identifier: UNLICENSED
    pragma solidity 0.8.12;
    
    import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
    
    contract UnderlyingToken is ERC20 {
        constructor() ERC20("Lp Token", "LTK") {}
    }
    ```
    
    

- **Faucet function**
  
  - ```javascript
    function faucet(address to, uint256 amount) external {
            _mint(to, amount);
        }
    ```
  
  - For development purposes, not for production





### LiquidityPool.sol

- Contract where  investors will send their liquidity in exchange for governance token

- **Basic contract layout** 
  
  - ```javascript
    // SPDX-License-Identifier: UNLICENSED
    pragma solidity 0.8.12;
    
    import "./UnderlyingToken.sol";
    import "./LpToken.sol";
    import "./GovernanceToken.sol";
    
    contract LiquidityPool is LpToken {
        
    }
    ```

- **State variables**
  
  - ```javascript
    mapping(address => uint256) public checkpoints;
    UnderlyingToken public underlyingToken;
    GovernanceToken public governanceToken;
    uint256 public constant REWARD_PER_BLOCK = 1;
    ```
  
  - Investors will earn 1 governance token per block for each underlying token they invest
    
    

- **Constructor**
  
  - ```javascript
    constructor(address _underlyingToken, address _governanceToken) {
        underlyingToken = UnderlyingToken(_underlyingToken);
        governanceToken = GovernanceToken(_governanceToken);
    }
    ```
  
  - Now with these two variables we can interact with token contracts
    
    

- **Deposit**
  
  - ```javascript
    function deposit(uint256 amount) external {
        if (checkpoints[msg.sender] == 0) {
                checkpoints[msg.sender] = block.number;
        }
        _distributeRewards(msg.sender);
        underlyingToken.transferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);
    }
    ```
  
  - Function so investor can provide liquidity
  
  - Checkpoints are used as a reference to distribute the governance token reward
  
  - If first time depositing, won't distribute anything (update checkpoint from 0)
  
  - Always redistributing rewards on ever deposit  so multiple deposits don't have multiple block lengths for rewards to keep track of
  
  - Underlying token gets sent from investor to this contract and after new LP tokens get minted to investor
    
    
    
    

- **Distribute Rewards function**
  
  - ```javascript
    function _distributeRewards(address beneficiary) internal {
        uint checkpoint = checkpoints[beneficiary];
        if(block.number - checkpoint > 0) {
          uint distributionAmount = (balanceOf(beneficiary) * (block.number - checkpoint) * REWARD_PER_BLOCK);
          governanceToken.mint(beneficiary, distributionAmount);
          checkpoints[beneficiary] = block.number; 
        }
    }
    ```
  
  - `internal` can only be called from within the contract
  
  - if `block.number` an `checkpoint` are the same there will be no distribution



- **Withdraw function**
  
  - ```javascript
    function withdraw(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "not enough lp token");
        _distributeRewards(msg.sender);
        underlyingToken.transfer(msg.sender, amount);
        _burn(msg.sender, amount);
    }
    ```
  
  - This is not amount of underlying token, but the amount of LP token to withdraw
  
  - Investor needs to have enough token to withdraw
  
  - For every interaction of the investor with the contract we distribute rewards
  
  - With the checkpoint we can make sure we never do a double distribution



# 
