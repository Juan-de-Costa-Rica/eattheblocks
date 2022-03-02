# 6. Oracles

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

- `touch contracts/Oracle.sol`

- `touch contracts/IOracle.sol`

- `touch contracts/Consumer.sol`

- `touch migrations/2_deploy_contracts.js`

- `npm init -y`

- `npm install coingecko-api`

- `touch scripts/price-watcher.js`

---

### Contract Updates

- Add SPDX-License-Identifier

- Update pragma solidity version

- Solidity style guide
