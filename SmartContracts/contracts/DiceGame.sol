// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract DiceGame {

    error NOT_ENOUGH_ETH();
    error ALREADY_JOINED();
    error NOT_OWNER();
    error ONLY_PLAYERS_CAN_ROLL_DICE();

    address payable public immutable owner;
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
    bool public winnerRewarded;

    mapping(address => bool) public hasJoined;
    mapping(address => uint256) public playerMoves;

    constructor(uint256 _winningPoints) payable {
        owner = payable(msg.sender);
        _winningPoints = winningPoints;
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

    modifier notEnoughEth() {
        if (msg.value < 0.1 ether) {
            revert NOT_ENOUGH_ETH();
        }
        _;
    }

    function startGameTime() internal {
        gameTime = block.timestamp + 20 minutes;
        gameId++;
    }

    modifier onlyWhenNotStarted() {
        if(gameTime != 0) {
            revert("GAME_ALREADY_STARTED");
        }
        _;
    }

    function startGame() public onlyWhenNotStarted {
        if (players.length == 0) {
            startGameTime();
        }
    }
    
    function joinGame() public payable alreadyJoined notEnoughEth {
        require(players.length < 3, "ONLY_TWO_PLAYERS_CAN_PLAY");
        if (block.timestamp > gameTime) {
            revert("GAME_TIME_LIMIT_HAS_EXCEEDED");
        }
        require(gameTime > 0, "GAME_NOT_STARTED");
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

    function rollDicePlayerOne() 
    public
    onlyPlayerOne
    gameOngoing
    returns(uint256)
    {
        require(playerOnePoints < winningPoints && playerTwoPoints < winningPoints, "POINTS_EXCEEDED!!!");
        if (playerMoves[msg.sender] == 0) {
        playerOneMove = true;
        playerTwoMove = false;
        uint256 randomNumber = generateRandomNumber();
        playerOneNumbers.push(randomNumber);
        playerOnePoints = addPlayerOnePoints();
        playerMoves[msg.sender] += 1;
        }
        else {
        require(playerTwoMove, "Wait for player Two to finish his move");
        uint256 randomNumber = generateRandomNumber();
        playerOneNumbers.push(randomNumber);
        playerOnePoints = addPlayerOnePoints();
        playerMoves[msg.sender] += 1;
        playerOneMove = true;
        playerTwoMove = false;
        }
        return playerOnePoints;
    }

    function rollDicePlayerTwo() 
    public 
    onlyPlayerTwo 
    gameOngoing 
    returns(uint256) 
    {
        require(playerOnePoints < winningPoints && playerTwoPoints < winningPoints, "POINTS_EXCEEDED!!!");
        require(playerOneMove, "Wait for player One to finish his move");
        uint256 randomNumber = generateRandomNumber();
        playerTwoNumbers.push(randomNumber);
        playerTwoPoints = addPlayerTwoPoints();
        playerMoves[msg.sender] += 1;
        playerTwoMove = true;
        playerOneMove = false;
        return playerTwoPoints;
    }

    function restartGame()
    public
    onlyPlayers
    onlyOwner
    {
        require(block.timestamp > gameTime, "GAME_STILL_ONGOING");
        if (playerOnePoints >= winningPoints 
        || playerTwoPoints >= winningPoints 
        && winnerRewarded)
        {
           hasJoined[players[0]] = false;
           hasJoined[players[1]] = false;
           playerMoves[players[0]] = 0;
           playerMoves[players[1]] = 0;
           gameTime = 0;
           playerOneMove = false;
           playerTwoMove = false;
           playerOnePoints = 0; 
           playerTwoPoints = 0;
           winningPoints = 0;
           winnerRewarded = false;
           players = new address[](0);
           playerOneNumbers = new uint256[](0);
           playerTwoNumbers = new uint256[](0);
        }
    }

    function rewardWinner()
    external
    returns(address)
    {
        address winner;
        require(block.timestamp > gameTime, "TIME_LIMIT_NOT_EXCEEDED");
        require(winner != address(0), "NO_WINNER_YET");
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
        winnerRewarded = true;
        require(winner == players[0] || winner == players[1], "NO_WINNER_TO_REWARD");
        return winner;
    }

    function rewardWinnersPercentage() public view returns(uint256) {
        uint256 amount = (address(this).balance * 90) / 100;
        return amount;
    }

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

    function getWinningPoints() public view returns(uint256) {
        return winningPoints;
    }

}