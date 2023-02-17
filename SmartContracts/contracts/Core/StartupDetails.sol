// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

struct Startup_Details {
    uint256 id;
    string name;
    string tagline;
    string description;
    uint256 amount;
    address payable owner;
    uint128 upvotes;
    uint128 downvotes;
    address[] voters;
}

enum Vote {
    YAY,
    NAY
}
