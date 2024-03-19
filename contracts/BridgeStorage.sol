// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./common/common.sol";
import "./interfaces/IToken.sol";

abstract contract BridgeStorage {

    address _proposer;

    uint256 _nonce;
    uint256 _voteThreshold;

    IToken _token;

    mapping(bytes32 proposalID => Proposal proposal) _proposals;
    mapping(uint256 chainID => bool allowed) _chainIDs;
    mapping(uint256 chainID => mapping(uint256 nonce => bool)) _processedNonces;
    mapping(address validator => bool allowed) _validator;

}