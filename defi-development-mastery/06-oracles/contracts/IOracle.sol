// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

interface IOracle {
    function updateReporter(address reporter, bool isReporter) external;

    function updateData(bytes32 key, uint256 payload) external;

    function getData(bytes32 key)
        external
        view
        returns (
            bool result,
            uint256 date,
            uint256 payload
        );
}
