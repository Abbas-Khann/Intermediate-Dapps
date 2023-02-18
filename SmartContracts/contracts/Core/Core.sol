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

    function VoteOnStartup(Vote vote) external InvestorOrFounder {
        require(!hasVoted[msg.sender][startupId], "ALREADY_VOTED");
        Startup_Details storage startupDetails = startup[startupId];
        if (vote == Vote.YAY) {
            startupDetails.upvotes += 1;
            startupDetails.voters.push(msg.sender);
            hasVoted[msg.sender][startupId] = true;
        }
    }

    function getAllStartups() public view returns (Startup_Details[] memory) {
        return allStartups;
    }
}
