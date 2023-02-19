// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./StartupDetails.sol";
import "../StartupIncubatorDaoFactory.sol";

error YOU_DONT_OWN_STARTUP_SBT();
error YOU_DONT_OWN_INVESTOR_SBT();
error ONLY_FOUNDERS_OR_INVESTORS();

contract Main {
    SIDAOFactory public SIDFactory;

    mapping(uint256 => Startup_Details) internal startup;
    mapping(address => mapping(uint256 => bool)) internal hasVoted;
    mapping(address => uint256) public amountInvested;
    uint256 startupId;

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
            SIDFactory.isStartupSBTOwner(msg.sender) == false ||
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
        startupDetails.amount = _amount;
        startupDetails.owner = payable(msg.sender);
        startupId += 1;
        allStartups.push(startupDetails);
    }

    function VoteOnStartup(uint256 _id, Vote vote) external InvestorOrFounder {
        require(!hasVoted[msg.sender][startupId], "ALREADY_VOTED");
        Startup_Details storage startupDetails = startup[_id];
        if (vote == Vote.YAY) {
            startupDetails.upvotes += 1;
            startupDetails.voters.push(msg.sender);
            hasVoted[msg.sender][startupId] = true;
        }
    }

    function investInStartup(
        uint256 _id
    ) external payable onlyInvestorSBTOwner {
        require(msg.value > 0, "BROKE_BUM!!!");
        Startup_Details storage startupDetails = startup[_id];
        require(
            startupDetails.amountRaised <= startupDetails.amount,
            "DONT_NEED_NO_MORE_INVESTORS"
        );
        uint256 commissionAmount = returnOnInvestment(_id);
        (bool sendCommission, ) = address(this).call{value: commissionAmount}(
            ""
        );
        require(sendCommission, "FAILED_TO_SEND_COMMISSION");
        (bool sendToFounder, ) = startupDetails.owner.call{value: msg.value}(
            ""
        );
        require(sendToFounder, "FAILED_TO_INVEST");
        amountInvested[msg.sender] += msg.value;
    }

    function returnOnInvestment(uint256 _id) public view returns (uint256) {
        unchecked {
            return (startup[_id].amount / 100) * 10;
        }
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

    fallback() external payable {}

    receive() external payable {}
}
