# 5. Collateral Backed Tokens

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

- `touch contracts/CollateralBackedToken.sol`

---

### Contract Updates

- Add SPDX-License-Identifier

- Update pragma solidity version

- Solidity style guide

- _"Wrong argument count for function call: 1 arguments given but expected 2."_
  
  - From: `collateral.transfer(_tokenAmount / price);`
  
  - To: `collateral.transfer(msg.sender, _tokenAmount / price);`
