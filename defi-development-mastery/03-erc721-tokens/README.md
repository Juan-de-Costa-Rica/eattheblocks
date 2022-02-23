# 3. ERC721 Tokens

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

- `touch contracts/ERC721OpenZeppelin.sol`

- `touch contracts/ContractA.sol`

---

### Contract Updates

- Add SPDX-License-Identifier

- Update pragma solidity version

- Solidity style guide

- **ContractA.sol**

  - OpenZeppelin ERC721Holder.sol import file path

    - `import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";`
