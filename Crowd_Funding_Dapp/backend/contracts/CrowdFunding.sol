// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
/*
-> So in crowd funding an organization collects money from different wallets or people and uses it for a purpose
-> The contract should consist of a target, minimum contribution and a deadline
-> 
-> We will have a manager who will only be able to deposit money from the contract under certain conditions
-> If the target does not meet, the contributors can withdraw their money back.
-> The manager should be able to use the money for the cause once the money is raised in the given time
-> We should have a function where users can create requests, Another one where users can vote on the requests and for makingPayment once the money is raised
*/

contract CrowdFunding {
    mapping (address => uint) public contributors;
    address public manager;
    uint256 public target;
    uint256 public minContribution;
    uint256 public deadline;
    uint256 public raisedAmount;
    uint256 public numOfContributors;

    struct Request {
        string description;
        address payable recipient;
        uint256 value;
        uint256 votersAmount;
        bool completed;
        mapping(address => bool) voters;
    }

    mapping(uint256 => Request) public request;
    uint256 public numOfRequests;

    constructor (uint256 _target, uint256 _deadline) {
        target = (_target * 1 ether);
        deadline = block.timestamp + _deadline;
        manager = msg.sender;
        minContribution = 0.1 ether;
    }

    modifier passedDeadline {
        require(block.timestamp < deadline, "Deadline has already exceeded, You can't send Eth Anymore");
        _;
    }

    modifier enoughContribution {
        require(msg.value >= minContribution, "You broke bitch you need to pay at least 0.1 eth");
        _;
    }

    function sendEth() external payable passedDeadline {
        if (contributors[msg.sender] == 0) {
            numOfContributors++;
        }
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    function getContractBalance() external view returns(uint256) {
        return address(this).balance;
    }

    modifier onGoingRequest() {
        require(
            block.timestamp > deadline,
            "The request is still on going you can't get a refund now"
        );
        _;
    }

    modifier notRefundable() {
        require(
            target >= raisedAmount,
            "The target for the crowdFunding was met, So you can't get a refund now!"
        );
        _;
    }

    function refund() external {
        require(contributors[msg.sender] == 0, 
        "You're not a contributor, Stop trying to steal money you bitch!");
        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender] = 0;
    }

    modifier onlyManager() {
        require(manager == msg.sender, "You are not the manager so you can't call this function");
        _;
    }

    function createRequest(
        string memory _description,
        uint256 _value,
        address payable _recipient
    ) external onlyManager {
        Request storage newReq = request[numOfRequests];
        newReq.description = _description;
        newReq.value = _value;
        newReq.recipient = _recipient;
        newReq.completed = false;
        newReq.votersAmount = 0;
        numOfRequests++;
    }

    function voteRequests(uint256 _reqNumber) external onlyManager {
        require(contributors[msg.sender] > 0, "You must be a contributor in order to vote!");
        Request storage thisRequest = request[_reqNumber];
        thisRequest.votersAmount++;
        require(thisRequest.voters[msg.sender] == false, "You have already voted once!");
        require(thisRequest.voters[msg.sender] = true);
    }

    function makePayment(uint256 _reqNumber) external onlyManager {
        require(raisedAmount >= target, "You can't make the payment yet since we haven't reached our target yet");
        Request storage thisRequest = request[_reqNumber];
        require(thisRequest.completed == false, "The request has been completed!");
        require(thisRequest.votersAmount > numOfContributors / 2, "Majority do not support this request");
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;
    }

}

