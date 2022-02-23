# 2. ERC20 Tokens

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

- `touch contracts/TokenOpenZeppelin.sol`

- `touch contracts/ContractA.sol`

---

### Updates

- **TokenOpenZeppelin.sol**

  - Add SPDX-License-Identifier

  - Update pragma solidity version

  - Solidity style guide

- **ContractA.sol**

  - Add SPDX-License-Identifier

  - Update pragma solidity version

  - Solidity style guide
