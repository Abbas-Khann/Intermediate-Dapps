// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract DiceGame {

    error NOT_ENOUGH_ETH();
    error ALREADY_JOINED();
    error NOT_OWNER();
    error ONLY_PLAYERS_CAN_ROLL_DICE();

    address payable public immutable owner;
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
        owner = payable(msg.sender);
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

    function rewardWinner() external returns(address) {
        address winner;
        uint256 _amount = rewardWinnersPercentage();
        if(playerOnePoints >= winningPoints) {
            winner = players[0];
            (bool sent, ) = winner.call{ value: _amount }("");
            require(sent, "FAILED TO REWARD WINNER 1");
        }
        else if(playerTwoPoints >= winningPoints) {
            winner = players[1];
            (bool sent, ) = winner.call{ value: _amount }("");
            require(sent, "FAILED TO REWARD WINNER 2");
        }
        return winner;
    }

    function rewardWinnersPercentage() public view returns(uint256) {
        uint256 amount = (address(this).balance * 90) / 100;
        return amount;
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

    function withdraw() external onlyOwner {
        uint256 contractBalance = getContractBalance();
        require(contractBalance > 0, "NO_BALANCE_TO_WITHDRAW");
        require(block.timestamp > gameTime, "GAME_ONGOING");
        owner.transfer(contractBalance);
    }

    // this should fetch the balance of the smart contract
    function getContractBalance() 
    public
    view
    returns (uint256) 
    {
        return address(this).balance;
    }

    function gameID() public view returns(uint256) {
        return gameId;
    }

}