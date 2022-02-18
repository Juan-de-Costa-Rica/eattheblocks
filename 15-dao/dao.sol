pragma solidity ^0.8.0;
//SPDX-License-Identifier: UNLICENSED

/**
 * DAO contract:
 * 1. Collects contributions in ETH during initial contribution period.
 * 2. Allows contributors to transfer shares at any time.
 * 3. Allows contributions to be redeemed during initial contribution period.
 * 4. Allows investment proposals to be created by contributors.
 * 5. Allows proposals to be voted on by contributors during voting period.
 * 6. Executes successful investment proposals.
 */

contract DAO {
  struct Proposal {
    string name;
    uint amount;
    address payable recipient;
    uint totalVotes;
    uint endVotingPeriod;
    bool executed;
    mapping(address => bool) votes;
  }

  mapping(address => uint) public $shares;
  mapping(uint => Proposal) public $proposals;
  uint public $totalShares;
  uint public $availableETH;
  uint public $endContributionPeriod;
  uint public $nextProposalId;
  uint public $quorum;
  address public $admin;

  constructor(
    uint _contributionTime, 
    uint _quorum
  ) {
    require(_quorum > 0 && _quorum < 100, 'quorum must be between 0 and 100');
    $endContributionPeriod = block.timestamp + _contributionTime;
    $quorum = _quorum;
    $admin = msg.sender;
  }

  function contribute() payable external {
    require(block.timestamp < $endContributionPeriod, 'Contribution Period Over');
    $shares[msg.sender] += msg.value;
    $totalShares += msg.value;
    $availableETH += msg.value;
  }

  function redeemShare(uint _amount) external {
    require(block.timestamp < $endContributionPeriod, 'Contribution Period Over');
    require($shares[msg.sender] >= _amount, 'Not Enough Shares');
    require($availableETH >= _amount, 'Not Enough Available ETH');
    $shares[msg.sender] -= _amount;
    $availableETH -= _amount;
    payable(msg.sender).transfer(_amount);
  }

  function transferShare(uint _amount, address _to) external {
    require($shares[msg.sender] >= _amount, 'Not Enough Shares');
    $shares[msg.sender] -= _amount;
    $shares[_to] += _amount;
  }

  function createProposal(
    string memory _name,
    uint _amount,
    address payable _recipient,
    uint _voteTime
  ) public {
    require($shares[msg.sender] > 0, 'Must Have Shares');
    require($availableETH >= _amount, 'Amount Too Big');
    Proposal storage proposal = $proposals[$nextProposalId];
    proposal.name = _name;
    proposal.amount = _amount;
    proposal.recipient = _recipient;
    proposal.endVotingPeriod = block.timestamp + _voteTime;
    $availableETH -= _amount;
    $nextProposalId++;
  }

  function vote(uint _proposalId) external {
    require($shares[msg.sender] > 0, 'Must Have Shares');
    Proposal storage proposal = $proposals[_proposalId];
    require(proposal.votes[msg.sender] == false, 'Already Voted For Proposal');
    require(block.timestamp < proposal.endVotingPeriod, 'Voting Period Over');
    proposal.votes[msg.sender] = true;
    proposal.totalVotes += $shares[msg.sender];
  }

  function executeProposal(uint _proposalId) external {
    require(msg.sender == $admin, 'Only Admin');
    Proposal storage proposal = $proposals[_proposalId];
    require(block.timestamp > proposal.endVotingPeriod, 'Voting Period Not Over');
    require(proposal.executed == false, 'Already Executed');
    require(proposal.totalVotes*(10**2)/$totalShares >= $quorum, 'No Quorum');
    $availableETH -= proposal.amount;
    payable(proposal.recipient).transfer(proposal.amount);
  }
}