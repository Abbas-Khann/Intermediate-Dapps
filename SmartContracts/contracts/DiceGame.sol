// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/*
=> Dice Game where users have to pay a certain amount of money in order to join
=> Only 2 players can play at a time
=> The numbers generated would be from 1 to 6 as in the dice
=> The numbers need to be randomly generated from the chainlink oracle
=> 
=> Winner gets all 
*/

contract DiceGame {
    error NOT_ENOUGH_ETH();
    error ALREADY_JOINED();
    error NOT_OWNER();


    address public immutable owner;
    uint256 public maxPlayers;
    address[] public players;
    uint256 public gameTime;

    mapping(address => bool) public hasJoined;
    constructor() payable {
        owner = msg.sender;
    }

    modifier alreadyJoined() {
        if (hasJoined[msg.sender]) {
            revert ALREADY_JOINED();
        }
        _;
    }

    modifier gameOngoing() {
        if (block.timestamp > gameTime) {
            revert("GAME_TIME_LIMIT_HAS_EXCEEDED");
        }
        _;
    }
    // game should be ongoing in order for it to work and not more than 2 players should be able to join
    function joinGame() public payable alreadyJoined gameOngoing {
        require(players.length < 3, "ONLY_TWO_PLAYERS_CAN_PLAY");
        if (msg.value < 0.1 ether) {
            revert NOT_ENOUGH_ETH();
        }
        if (players.length == 0) {
            startGameTime();
        }
        hasJoined[msg.sender] = true;
        players.push(msg.sender);
    }

    function startGameTime() internal {
        gameTime = block.timestamp + 20 minutes;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NOT_OWNER();
        }
        _;
    }

    // this should fetch the balance of the smart contract
    function getContractBalance() 
    public
    view
    onlyOwner
    returns (uint256) 
    {
        return address(this).balance;
    }

    

}

 /*
function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number - 1));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
*/