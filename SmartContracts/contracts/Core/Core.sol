// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./StartupDetails.sol";
import "../StartupIncubatorDaoFactory.sol";

error YOU_DONT_OWN_STARTUP_SBT();
error YOU_DONT_OWN_INVESTOR_SBT();
error ONLY_FOUNDERS_OR_INVESTORS();

contract Main {
    SIDAOFactory public SIDFactory;

    mapping(uint256 => Startup_Details) public startup;
    mapping(address => mapping(uint256 => bool)) public hasVoted;
    mapping(address => uint256) public amountInvested;
    uint256 public startupId;

    Startup_Details[] internal allStartups;

    constructor(address _addr) {
        SIDFactory = SIDAOFactory(_addr);
    }

    modifier onlyStartupSBTOwner() {
        if (SIDFactory.isStartupSBTOwner(msg.sender) == false) {
            revert YOU_DONT_OWN_STARTUP_SBT();
        }
        _;
    }

    modifier onlyInvestorSBTOwner() {
        if (SIDFactory.isInvestorSBTOwner(msg.sender) == false) {
            revert YOU_DONT_OWN_INVESTOR_SBT();
        }
        _;
    }

    modifier InvestorOrFounder() {
        if (
            SIDFactory.isStartupSBTOwner(msg.sender) == false &&
            SIDFactory.isInvestorSBTOwner(msg.sender) == false
        ) {
            revert ONLY_FOUNDERS_OR_INVESTORS();
        }
        _;
    }

    /*
    @dev Creating a new startup
    */
    function createStartup(
        string memory _name,
        string memory _tagline,
        string memory _description,
        uint256 _amount
    ) external onlyStartupSBTOwner {
        Startup_Details storage startupDetails = startup[startupId];
        startupDetails.name = _name;
        startupDetails.tagline = _tagline;
        startupDetails.description = _description;
        startupDetails.amount = _amount * 10 ** 18;
        startupDetails.owner = payable(msg.sender);
        startupId += 1;
        allStartups.push(startupDetails);
    }

    function VoteOnStartup(uint256 _id, Vote vote) external InvestorOrFounder {
        // startup should exist check
        require(!hasVoted[msg.sender][_id], "ALREADY_VOTED");
        Startup_Details storage startupDetails = startup[_id];
        if (vote == Vote.YAY) {
            startupDetails.upvotes += 1;
            startupDetails.voters.push(msg.sender);
            hasVoted[msg.sender][_id] = true;
        }
    }

    function investInStartup(
        uint256 _id
    ) external payable onlyInvestorSBTOwner {
        // startup should exist check
        require(msg.value > 0, "BROKE_BUM!!!");
        Startup_Details storage startupDetails = startup[_id];
        require(
            startupDetails.amountRaised <= startupDetails.amount,
            "DONT_NEED_NO_MORE_INVESTORS"
        );
        uint256 commissionAmount = (msg.value / 100) * 10;
        startupDetails.owner.transfer(msg.value - commissionAmount);
        amountInvested[msg.sender] += msg.value - commissionAmount;
        startupDetails.amountRaised += msg.value - commissionAmount;
    }

    function withdraw() public {
        require(msg.sender == SIDFactory.getOwner(), "NOT_OWNER");
        require(
            address(this).balance > 0,
            "WHAT_ARE_YOU_TRYING_TO_WITHDRAW???"
        );
        (bool withdrawn, ) = msg.sender.call{value: address(this).balance}("");
        require(withdrawn, "FAILED_TO_WITHDRAW");
    }

    function getAllStartups() public view returns (Startup_Details[] memory) {
        return allStartups;
    }

    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    fallback() external payable {}

    receive() external payable {}
}
