// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract SIDAOFactory is ERC721, ERC721URIStorage, AccessControl {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string private startupURI;
    string private investorURI;

    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 public constant STARTUP = keccak256("STARTUP");
    bytes32 public constant INVESTOR = keccak256("INVESTOR");

    address owner;
    mapping(address => bool) private hasMintedStartupSBT;
    mapping(address => bool) private hasMintedInvestorSBT;

    constructor() ERC721("SIPF", "SID") {
        _grantRole(OWNER_ROLE, msg.sender);
        owner = msg.sender;
    }

    /*
     @dev Buying SBT to get DAO Access as a Startup Founder
    */

    function mintStartupNFT(address _to) public payable {
        require(
            !hasMintedStartupSBT[msg.sender],
            "YOU_ALREADY_OWN_STARTUP_SBT"
        );
        require(msg.value == 0.1 ether, "NOT_FOR_BROKE_INVESTORS");
        uint256 _tokenId = _tokenIdCounter.current();
        _safeMint(_to, _tokenId);
        _setTokenURI(_tokenId, startupURI);
        hasMintedStartupSBT[msg.sender] = true;
        _tokenIdCounter.increment();
    }

    /*
    @dev Buying SBT to get DAO access as an Investor
   */

    function mintInvestorNFT(address _to) public payable {
        require(
            !hasMintedInvestorSBT[msg.sender],
            "YOU_ALREADY_OWN_INVESTOR_SBT"
        );
        require(msg.value == 0.2 ether, "BROKE_INVESTOR???");
        uint256 _tokenId = _tokenIdCounter.current();
        _safeMint(_to, _tokenId);
        _setTokenURI(_tokenId, investorURI);
        hasMintedInvestorSBT[msg.sender] = true;
        _tokenIdCounter.increment();
    }

    function isStartupSBTOwner(address _operator) public view returns (bool) {
        return hasMintedStartupSBT[_operator] ? true : false;
    }

    function isInvestorSBTOwner(address _operator) public view returns (bool) {
        return hasMintedInvestorSBT[_operator] ? true : false;
    }

    function contractOwner() public view returns (address) {
        return owner;
    }

    function setStartupURI(string memory URI) external onlyRole(OWNER_ROLE) {
        startupURI = URI;
    }

    function setInvestorURI(string memory URI) external onlyRole(OWNER_ROLE) {
        investorURI = URI;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, AccessControl) returns (bool) {
        super.supportsInterface(interfaceId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        super.tokenURI(tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public pure override {
        require(from == address(0) || to == address(0), "CANT_SELL_SBTs");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public pure override {
        require(from == address(0) || to == address(0), "CANT_SELL_SBTs");
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    // Two burn functions to see change the states accordingly
    function burnStartupSBT(uint256 tokenId) external {
        require(hasMintedStartupSBT[msg.sender], "YOU_DONT_OWN_STARTUP_SBT");
        _burn(tokenId);
        hasMintedStartupSBT[msg.sender] = false;
    }

    function burnInvestorSBT(uint256 tokenId) external {
        require(hasMintedInvestorSBT[msg.sender], "YOU_DONT_OWN_INVESTOR_SBT");
        _burn(tokenId);
        hasMintedInvestorSBT[msg.sender] = false;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "NOT_OWNER");
        _;
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "NOTHING_TO_WITHDRAW");
        (bool withdrawn, ) = msg.sender.call{value: address(this).balance}("");
        require(withdrawn, "FAILED_TO_WITHDRAW");
    }
}
