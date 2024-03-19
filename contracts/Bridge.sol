// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IBridge.sol";
import "./BridgeStorage.sol";

abstract contract Bridge is BridgeStorage, IBridge {

    modifier onlyProposer() {
        require(msg.sender == _proposer, "ERR: INVALID PROPOSER");
        _;
    }

    modifier onlyValidator() {
        require(_validator[msg.sender], "ERR: NOT VALIDATOR");
        _;
    }

    function nonce() public view returns(uint256) {
        return _nonce;
    }

    function token() public view returns(IToken) {
        return _token;
    }

    function proposer() public view returns(address) {
        return _proposer;
    }

    function chainId() public view returns(uint256) {
        return block.chainid;
    }

    function voteThreshold() public view returns(uint256) {
        return _voteThreshold;
    }

    function isValidator(address validator) public view returns(bool) {
        return _validator[validator];
    }

    function getProposal(bytes32 proposalId) public view returns(Proposal memory) {
        return _proposals[proposalId];
    }

    function deposit(
        address recepient,
        uint256 amount,
        uint256 chainID
    ) public virtual {
        require(amount > 0, "ERR: NON ZERO AMOUNT REQUIRED");
        require(_chainIDs[chainID] && chainID != chainId(), "ERR: UNSUPPORTED CHAIN ID");
        require(recepient != address(0), "ERR: BRIDGE TO ZERO ADDRESS");

        _token.transferFrom(msg.sender, address(this), amount);
    }

    function propose(
        bytes32 txHash,
        address receiver,
        uint256 amount,
        uint256 proposalNonce,
        uint256 chainID
    ) external onlyProposer {
        require(!_processedNonces[chainID][proposalNonce], "ERR: NONCE ALREADY PROCESSED");
        bytes32 proposeID = _propose(txHash, receiver, amount, proposalNonce, chainID);
        emit ProposalEvent(
            proposeID,
            receiver,
            txHash,
            chainID,
            proposalNonce,
            amount
        );
    }

    function vote(
        bytes32 proposalID
    ) public virtual onlyValidator {
        Proposal storage proposal = _proposals[proposalID];
        require(proposal.chainID != 0, "ERR: INVALID PROPOSAL");
        proposal.votes += 1;
    }

    function addChainID(uint256 chainID) public onlyProposer {
        _chainIDs[chainID] = true;
    }

    function addValidator(
        address validator
    ) public onlyProposer {
        _validator[validator] = true;
    }

    function removeValidator(
        address validator
    ) public onlyProposer {
        _validator[validator] = false;
    }

    function setProposer(
        address proposer_
    ) public onlyProposer {
        _proposer = proposer_;
    }

    function setVotingThreshold(uint256 threshold) public onlyProposer {
        _voteThreshold = threshold;
    }

    function getProposalID(
        bytes32 txHash,
        address receiver,
        uint256 amount,
        uint256 proposalNonce,
        uint256 chainID
    ) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(
            txHash,
            receiver,
            amount,
            proposalNonce,
            chainID
            ));
    }

    function _propose(
        bytes32 txHash,
        address receiver,
        uint256 amount,
        uint256 proposalNonce,
        uint256 chainID
    ) private returns(bytes32) {
        bytes32 proposeID = getProposalID(txHash, receiver, amount, proposalNonce, chainID);
        Proposal storage proposal = _proposals[proposeID];
        proposal.txHash = txHash;
        proposal.receiver = receiver;
        proposal.amount = amount;
        proposal.nonce = proposalNonce;
        proposal.chainID = chainID;
        _processedNonces[chainID][proposalNonce] = true;

        return proposeID;
    }

    function _vote(bytes32 proposalID) private returns(uint256) {
        Proposal storage proposal = _proposals[proposalID];
        proposal.votes += 1;
        return proposal.votes;
    }
}