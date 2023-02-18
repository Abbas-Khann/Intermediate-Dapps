// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./StartupDetails.sol";
import "../StartupIncubatorDaoFactory.sol";

error YOU_DONT_OWN_STARTUP_SBT();

contract Main {
    SIDAOFactory public SIDFactory;

    mapping(uint256 => Startup_Details) public startup;
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

    function getAllStartups() public view returns (Startup_Details[] memory) {
        return allStartups;
    }
}
