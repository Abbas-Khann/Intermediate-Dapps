// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
/*
User will land on the website 

see the details and buy the token  (on the separate page)
e.g -> 100 token will give the access to creating a startup and 200 tokens will give the access to post the startup as well as to DO THE INVESTING

access control will be given on the basis of amount of nft or token that he have (Soulbound Tokens projects have won in the past so keep this in mind)

after they have bought the token they will be pushed to a new page where they will see the list of all the startups that have posted their proposal to get the investment.

(
There will be a mega form page to fill the info of startups
name (editable only twice) (string)
description (editable)     (string)
Native token (erc20)       (string)
Amount                     (number)
address
startupID                  (optional)
mapping of address to a string (to save the hash of video)
--------------------------OR--------------------

If he is investor then his details like
name 
comapany
description
valuation             ++ Address




=> Users should be able to join the DAO
=> Users should be able to buy the tokens
=> Users should be able to create a post for a startup
=> Users should be able to invest in a startup
=> Users should be able to add themselves as investors or Startup founders
*/

contract HatcheryDao is ERC20 {
    error NOT_OWNER();

    address public owner;

    address[] public owners;

    constructor(uint256 initialSupply) ERC20("HETCHToken", "HDT") {
            _mint(msg.sender, initialSupply);
            owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) {
            revert NOT_OWNER();
        }
        _;
    }

    function addNewOwner(address _newOwner) external onlyOwner {
        owners.push(_newOwner);
    }

    modifier enoughWallabyToJoin () {
        if(msg.value <= 0.1 ether) {
            revert("DAO_NOT_FOR_BROKIES");
        }
        _;
    }

    // registration part
    function joinDao() external payable enoughWallabyToJoin  {
        
    }

}