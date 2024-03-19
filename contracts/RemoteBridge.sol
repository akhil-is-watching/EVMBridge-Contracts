// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Bridge.sol";

contract RemoteBridge is Bridge {

    constructor(address proposer_, IToken token_, uint256 voteThreshold_) {
        _proposer = proposer_;
        _token = token_;
        _voteThreshold = voteThreshold_;
    }

    function deposit(
        address recepient,
        uint256 amount,
        uint256 chainID
    ) public override {
        super.deposit(recepient, amount, chainID);
        uint256 currentNonce = _nonce;
        _deposit(amount);
        emit DepositEvent(
            msg.sender,
            recepient,
            amount,
            currentNonce,
            chainID
        );
    }
    
    
    function vote(bytes32 proposalID) public override {
        super.vote(proposalID);
        bool executed = _executeProposal(proposalID);
        if(executed) {
            emit ProposalExecuted(proposalID);
        }
    }

    function _deposit(uint256 amount) internal {
        _token.burn(amount);
        _nonce += 1;
    }

    function _executeProposal(bytes32 proposalID) internal returns(bool) {
        Proposal storage proposal = _proposals[proposalID];
        if(proposal.votes >= _voteThreshold && !proposal.executed) {
            _token.mint(proposal.receiver, proposal.amount);
            proposal.executed = true;
            return proposal.executed;
        }
        return proposal.executed;
    }
}