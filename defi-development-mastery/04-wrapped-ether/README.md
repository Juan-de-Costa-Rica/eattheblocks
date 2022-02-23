# 4. Wrapped Ether

### Setup

- `truffle init`

- *Edit truffle-config.js*
  
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

- `touch contracts/Weth.sol`

---

### Contract Updates

- Add SPDX-License-Identifier

- Update pragma solidity version

- Solidity style guide

- *"send" and "transfer" are only available for objects of type "address payable", not "address"*
  
  - From: `msg.sender.transfer(_amount);`
  
  - To: `payable(msg.sender).transfer(_amount);`
