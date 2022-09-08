// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract imageStorage {

    string[] public images;
    
    function addImages(string memory _imageUrl) external {
        images.push(_imageUrl);
    }

    function getImages() public view returns(string[] memory) {
        return images;
    }

    function getArrayLength() public view returns(uint) {
        return images.length;
    }

}