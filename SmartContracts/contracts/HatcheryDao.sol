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

    struct Investor {
        string name;
        string description;
        address userAddress;
        uint256 valuation;
        bool registered;
    }

    struct Founder {
        string name;
        string description;
        string nativeToken;
        address companyWalletAddress;
        string videoHash;
        bool registered;
    }

    mapping (address => bool) public hasJoined;
    mapping (uint256 => Investor) public investor;
    mapping (address => bool) public isInvestor;
    mapping (uint256 => Founder) public founder;
    mapping (address => bool) public isFounder;

    uint256 investorId;
    uint256 founderId;

    address[] public DAO_Members;

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

    modifier enoughWallabyToJoin () {
        if(msg.value <= 0.1 ether) {
            revert("DAO_NOT_FOR_BROKIES");
        }
        _;
    }

    // Registration part
    function joinDao() external payable enoughWallabyToJoin  {
        require(!hasJoined[msg.sender], "ALREADY_JOINED!!!");
        DAO_Members.push(msg.sender);
        hasJoined[msg.sender] = true;
    }

    // Registor as a startup founder
    function registerAsFounder(
        string memory _name,
        string memory _description,
        string memory _nativeToken,
        address _companyWalletAddress,
        string memory _videoHash
    )
    public 
    payable 
    {
        require(hasJoined[msg.sender], "YOU_NEED_TO_JOIN_FIRST");
        require(msg.value == 0.5 ether, "BROKE_BUMS_CAN'T_REGISTER_AS_FOUNDERS");
        Founder memory thisFounder = founder[founderId];
        thisFounder.name = _name;
        thisFounder.description = _description;
        thisFounder.nativeToken = _nativeToken;
        thisFounder.companyWalletAddress = _companyWalletAddress;
        thisFounder.videoHash = _videoHash;
        thisFounder.registered = true;
        isFounder[msg.sender] = true;
        founderId++;
    }

    // Register as an investor
    function registerAsInvestor(
        string memory _name,
        string memory _description,
        address _investorWalletAddress,
        uint256 _valuation
    )
    public
    payable
    {
        require(hasJoined[msg.sender], "YOU_NEED_TO_JOIN_DAO_FIRST");
        require(msg.value == 1 ether, "BROKE_SO_CALLED_INVESTORS_NOT_ALLOWED");
        Investor memory thisInvestor = investor[investorId];
        thisInvestor.name = _name;
        thisInvestor.description = _description;
        thisInvestor.userAddress = _investorWalletAddress;
        thisInvestor.valuation = _valuation;
        thisInvestor.registered = true;
        isInvestor[msg.sender] = true;
        investorId++;
    }
    
    // These two will make you eligible for certain function calls
    modifier onlyInvestor(uint256 _id) {
        if (investor[_id].registered != true) {
            revert("ONLY_INVESTORS_CAN_CLAIM");
        }
        _;
    }

    modifier onlyFounder(uint256 _id) {
        if (founder[_id].registered != true) {
            revert("ONLY_FOUNDERS_CAN_CLAIM");
        }
        _;
    }

    function claimTokens(uint256 _id) 
    public
    onlyInvestor(_id)
    onlyFounder(_id)
    {
        if(isInvestor[msg.sender] == true) {
            _transfer(address(this), msg.sender, 200);
        }
        else if (isFounder[msg.sender] == true) {
            _transfer(address(this), msg.sender, 150);
        }
        else {
            revert("YOU_ARE_NOT_ELIGIBLE_TO_CLAIM");
        }
    }
        
}