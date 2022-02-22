##### DAO contract overview:

- Collects contributions in ETH during initial contribution period
- Allows contributors to transfer shares at any time
- Allows contributions to be redeemed during initial contribution period
- Allows investment proposals to be created by contributors
- Allows proposals to be voted on by contributors during voting period
- Executes successful investment proposals

###### 

##### Collects contributions in ETH during initial contribution period

- Contract states to keep track of:
  
  - Amount of shares each address has contributed  (Mapping)
  
  - Total amount of shares in the contract
  
  - Total available ETH in the contract
  
  - End time of the contribution period

- Contract initialization:
  
  - Take contribution period in unix time
  
  - Calculate and set contribution end time from taken period

- Contribute:
  
  - Require that current time is in the contribution period
  
  - Increase address amount of shares
  
  - Increase total shares
  
  - Increase available ETH

```javascript
mapping(address => uint) public $shares;
uint public $totalShares;
uint public $availableETH;
uint public $endContributionPeriod;

constructor(uint _contributionTime) {
    $endContributionPeriod = block.timestamp + _contributionTime;
}

function contribute() payable external {
    require(block.timestamp < $endContributionPeriod, 'Contribution Period Over');
    $shares[msg.sender] += msg.value;
    $totalShares += msg.value;
    $availableETH += msg.value;
}
```

###### 

##### Allows contributors to transfer shares at any time

- Contract states to keep track of:
  
  - ✅ Amount of shares each address has contributed (Mapping) 
  
  - ✅ Has address contributed or not? (Mapping)

- Transfer Shares:
  
  - Take amount of shares to transfer
  
  - Take address to transfer shares to
  
  - Require address has contributed enough shares to transfer
  
  - Decrease amount of shares of transfer-er
  
  - Increase amount of shares of transfer-ee

```javascript
function transferShare(uint _amount, address _to) external {
    require($shares[msg.sender] >= _amount, 'Not Enough Shares');
    $shares[msg.sender] -= _amount;
    $shares[_to] += _amount;
  }
```

###### 

##### Allows contributions to be redeemed during initial contribution period

- Contract states to keep track of:
  
  - ✅ Amount of shares each address has contributed (Mapping) 
  
  - ✅ Total available ETH in the contract

- Redeem Shares:
  
  - Take amount of shares to redeem
  
  - Require that current time is in the contribution period
  
  - Require address has contributed enough shares to redeem
  
  - Require that there is enough available ETH in contract
  
  - Decrease amount of shares of redeemer address
  
  - Decrease total shares
  
  - Decrease available ETH
  
  - Transfer ETH to address.

```javascript
function redeemShare(uint amount) external {
    require(block.timestamp < contributionEnd, 'Contribution Period Over');
    require(shares[msg.sender] >= amount, 'not enough shares');
    require(availableFunds >= amount, 'not enough available funds');
    shares[msg.sender] -= amount;
    availableFunds -= amount;
    payable(msg.sender).transfer(amount);
  }
```

###### 

##### Allows investment proposals to be created by contributors

- Contract data structures
  
  - Proposals
    
    - Identifier of the proposal
    
    - Display name of the proposal
    
    - Recipient of the proposal
    
    - Amount ETH the recipient will receive
    
    - Amount of votes the proposal has received?
    
    - End time of voting period
    
    - if proposal has been executed or not

- Contract states to keep track of:
  
  - List of all proposals
  
  - Identifier of next proposal
  
  - ✅ Total available ETH in the contract
  
  - ✅ Amount of shares each address has contributed (Mapping)

- Create Proposal
  
  - Take proposal display name
  
  - Take proposal amount
  
  - Take proposal recipient
  
  - Take vote time
  
  - Require address has shares
  
  - Require that there is enough funds in the contract 
  
  - Create proposal and add to list of proposals with next identifier
  
  - Decrease available ETH
  
  - Increment next proposal identifier

```javascript
struct Proposal {
    string name;
    uint amount;
    address payable recipient;
    uint totalVotes;
    uint endVotingPeriod;
    bool executed;
    mapping(address => bool) votes;
}

mapping(uint => Proposal) public proposals;

function createProposal(
    string memory _name,
    uint _amount,
    address payable _recipient,
    uint _voteTime
) public {
    require($shares[msg.sender] > 0, 'Must Have Shares')
    require($availableETH >= _amount, 'Amount Too Big');
    Proposal storage proposal = $proposals[$nextProposalId];
    proposal.name = _name;
    proposal.amount = _amount;
    proposal.recipient = _recipient;
    proposal.endVotingPeriod = block.timestamp + _voteTime;
    $availableETH -= _amount;
    $nextProposalId++;
  }
```

###### 

##### Allows proposals to be voted on by contributors during vote period

- Contract states to keep track of
  
  - ✅ List of all proposals
  
  - ✅ Amount of shares each address has contributed (Mapping)

- Vote:
  
  - Take identifier of proposal to vote for
  
  - Require address has shares
  
  - Require address has not voted for this proposal
  
  - Require that current time is in the voting period
  
  - Set address as voting for proposal identifier
  
  - Increase votes of proposal by shares of address

```javascript
function vote(uint proposalId) external {
    require($shares[msg.sender] > 0, 'Must Have Shares');
    Proposal storage proposal = $proposals[_proposalId];
    require(proposal.votes[msg.sender] == false, 'Already Voted For Proposal');
    require(block.timestamp < proposal.endVotingPeriod, 'Voting Period Over);
    proposal.votes[msg.sender] = true;
    proposal.totalVotes += $shares[msg.sender];
}
```

###### 

##### Executes successful investment proposals

- Contract states to keep track of:
  
  - Quorum percentage of vote needed to pass proposal 
  
  - Address of admin
  
  - ✅ List of all proposals
  
  - ✅ Total amount of shares in the contract
  
  - ✅ Total available ETH in the contract

- Contract initialization
  
  - Take voting quorum
  
  - Require quorum is between 0 and 100
  
  - Set voting quorum
  
  - Set admin address as creator of contract

- Execute Proposal:
  
  - Take identifier of proposal
  
  - Require execution by admin
  
  - Require proposal voting period is over
  
  - Require proposal has not be executed already
  
  - Require proposal votes  have reached the quorum percentage
  
  - Decrease available ETH
  
  - Transfer ETH to proposal recipient

```javascript
address public $admin;
uint public $quorum;

constructor(
    ...
    uint _quorum
) {
    ...
    require(_quorum > 0 && _quorum < 100, 'quorum must be between 0 and 100');
    $quorum = _quorum;
    $admin = msg.sender;
}

function executeProposal(uint proposalId) external {
    require(msg.sender == $admin, 'Only Admin');
    Proposal storage proposal = $proposals[_proposalId];
    require(block.timestamp > proposal.endVotingPeriod, 'Voting Period Not Over');
    require(proposal.executed == false, 'Already Executed');
    require(proposal.totalVotes*(10**2)/$totalShares >= $quorum, 'No Quorum');
    $availableETH -= proposal.amount;
    payable(proposal.recipient).transfer(proposal.amount);
}
```