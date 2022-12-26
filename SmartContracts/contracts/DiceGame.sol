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
    error ONLY_PLAYERS_CAN_ROLL_DICE();

    address public immutable owner;
    uint256 public maxPlayers;
    address[] public players;
    uint256 public gameTime;
    uint256 gameId;
    uint256[] public playerOneNumbers;
    uint256[] public playerTwoNumbers;
    bool public playerOneMove;
    bool public playerTwoMove;
    uint256 playerOnePoints;
    uint256 playerTwoPoints;
    uint256 winningPoints;

    mapping(address => bool) public hasJoined;
    mapping(address => uint256) public playerMoves;

    constructor(uint256 _winningPoints) payable {
        owner = msg.sender;
        winningPoints = _winningPoints;
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
            rollDicePlayerOne();
        }
        hasJoined[msg.sender] = true;
        players.push(msg.sender);
    }

    modifier onlyPlayers() {
        if(msg.sender != players[0] || msg.sender != players[1]) {
            revert ONLY_PLAYERS_CAN_ROLL_DICE();
        }
        _;
    }

    modifier onlyPlayerOne {
        if (msg.sender != players[0]) {
            revert("NOT_PLAYER_ONE");
        }
        _;
    }
    modifier onlyPlayerTwo {
        if (msg.sender != players[1]) {
            revert("NOT_PLAYER_TWO");
        }
        _;
    }

    function rollDicePlayerOne() public onlyPlayerOne gameOngoing returns(uint256) {
        require(playerOnePoints < winningPoints && playerTwoPoints < winningPoints,         "POINTS_EXCEEDED!!!");
        require(playerTwoMove, "Wait for player Two to finish his move");
        uint256 randomNumber = generateRandomNumber();
        playerOneNumbers.push(randomNumber);
        playerOnePoints = addPlayerOnePoints();
        playerMoves[msg.sender] += 1;
        playerOneMove = true;
        playerTwoMove = false;
        return playerOnePoints;
    }

    function rollDicePlayerTwo() public onlyPlayerTwo gameOngoing returns(uint256) {
        require(playerOnePoints < winningPoints && playerTwoPoints < winningPoints,         "POINTS_EXCEEDED!!!");
        require(playerOneMove, "Wait for player One to finish his move");
        uint256 randomNumber = generateRandomNumber();
        playerTwoNumbers.push(randomNumber);
        playerTwoPoints = addPlayerTwoPoints();
        playerMoves[msg.sender] += 1;
        playerTwoMove = true;
        playerOneMove = false;
        return playerTwoPoints;
    }

    function checkWinner() external {
        if(playerOnePoints >= winningPoints) {
            
            // playerOne wins
        }
        else if(playerTwoPoints >= winningPoints) {
            
            // playerTwo wins
        }
    }

    // add prev points and winner maloomawal

    function addPlayerOnePoints() private view returns(uint256) {
        uint256 playerOneScores;
        for(uint256 i = 0; i < playerOneNumbers.length; i++) {
            playerOneScores += playerOneNumbers[i];
        }
        return playerOneScores;
    }

    function addPlayerTwoPoints() private view returns(uint256) {
        uint256 playerTwoScores;
        for(uint256 i = 0; i < playerTwoNumbers.length; i++) {
            playerTwoScores += playerTwoNumbers[i];
        }
        return playerTwoScores;
    }



    function generateRandomNumber() internal view returns(uint256) {
        uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 6 + 1;
        return rand;
    }

    function startGameTime() internal {
        gameTime = block.timestamp + 20 minutes;
        gameId++;
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

    function gameID() public view returns(uint256) {
        return gameId;
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