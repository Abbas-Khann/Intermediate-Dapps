// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/*
English Auction
English auction for NFT.

Auction
Seller of NFT deploys this contract.
Auction lasts for 7 days.
Participants can bid by depositing ETH greater than the current highest bidder.
All bidders can withdraw their bid if it is not the current highest bid.
After the auction
Highest bidder becomes the new owner of NFT.
The seller receives the highest bid of ETH.
*/

interface IERC721 {
    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function transferFrom(
        address,
        address,
        uint
    ) external;
}
contract EnglishAuction {

    error NOT_STARTED_YET();

    event BidStarted();
    event Bid(address highestBidder, uint256 amount);
    event Withdrawn(address withdrawer, uint256 amount);
    event Ended(uint256 timing, address highestBidder, uint256 highestBid);

    address payable public owner;
    IERC721 public nft;
    uint256 public nftId;

    uint256 public endingTime;
    bool public started;
    bool public ended;
    uint256 public highestBid;
    address public highestBidder;
    address[] public allBidders;

    mapping (address => uint256) public bids;
    mapping (address => bool) public hasBid;

    constructor (
        address _nft,
        uint256 _nftId,
        uint256 _startingBid
    ) 
    {
        nft = IERC721(_nft);
        nftId = _nftId;
        owner = payable(msg.sender);
        highestBid = _startingBid;
    }

    modifier notStarted() {
        if (!started) {
            revert NOT_STARTED_YET();
        }
        _;
    }

    modifier notSeller() {
        require(msg.sender == owner, "NOT_SELLER");
        _;
    }

    function startBidding() external notStarted notSeller {
        nft.transferFrom(
            msg.sender, 
            address(this), 
            nftId
            );
        started = true;
        endingTime = block.timestamp + 7 days;
        allBidders.push(msg.sender);
        emit BidStarted();
    }

    function placeBid() external payable notStarted {
        require(endingTime < block.timestamp, "AUCTION_ENDED");
        require(msg.value > highestBid, "NOT_HIGHEST_BID");
        
        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        hasBid[msg.sender] = true;
        emit Bid(msg.sender, highestBid);
    }

    modifier notEnded() {
        require(block.timestamp >= endingTime, "AUCTION_NOT_ENDED");
        _;
    }

    function withdraw() external {
        require(
        hasBid[msg.sender] == true,
         "NOT_BIDDER");
        uint256 balance = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(balance);

        emit Withdrawn(msg.sender, balance);
    }

    function endAuction() external notStarted notEnded {
        require(!ended, "ALREADY_ENDED");
        ended = true;
        if (highestBidder != address(0)) {
            nft.safeTransferFrom(
                address(this), 
                highestBidder, 
                nftId);
                owner.transfer(highestBid);
        }
        else {
            nft.safeTransferFrom(
                address(this),
                owner, 
                nftId);
        }

        emit Ended(block.timestamp, highestBidder, highestBid);
    }
}