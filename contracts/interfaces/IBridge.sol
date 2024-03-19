// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../common/common.sol";

interface IBridge {

    event DepositEvent(
        address sender,
        address recepient,
        uint256 amount,
        uint256 nonce,
        uint256 chainID
    );

    event ProposalEvent(
        bytes32 proposalID,
        address recepient,
        bytes32 txHash,
        uint256 chainID,
        uint256 nonce,
        uint256 amount
    );

    event ProposalVote(
        bytes32 proposalID
    );

    event ProposalExecuted(
        bytes32 proposalID
    );

    function deposit(
        address recepient,
        uint256 amount,
        uint256 chainID
    ) external;

    function propose(
        bytes32 txHash,
        address receiver,
        uint256 amount,
        uint256 nonce,
        uint256 chainID
    ) external;

    function vote(
        bytes32 proposalID
    ) external;

}