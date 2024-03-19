// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


struct Proposal {
    bytes32 txHash;
    address depositor;
    address receiver;
    uint256 amount;
    uint256 chainID;
    uint256 nonce;
    uint256 votes;
    bool executed;
}