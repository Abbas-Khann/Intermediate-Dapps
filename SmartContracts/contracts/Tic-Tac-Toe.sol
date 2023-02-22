// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;

/*
=> User will enter the game by betting some Eth.
=> Second user will enter the game by betting the same amount.
=> Game will start now and last for about maximum of 2 minutes.
=> Users will start making moves in patterns.
=> Whoever forfeits will lose all the money and the other person will win.
=> If one user wins they win all the money and the owner of the contract gets 1% commission
*/

error NOT_ENOUGH_ETH();
error GAME_DOES_NOT_EXIST();
error YOU_HAVE_ALREADY_JOINED();

contract Tic_Tac_Toe {
    address owner;

    uint256 public constant TIMEOUT = 5 minutes;
    // Game Events here
    event NewGame(uint256 gameId, address creator);

    enum Turn {
        none,
        player1,
        player2
    }

    enum Result {
        none,
        active,
        player1Wins,
        player2Wins,
        draw,
        abandoned
    }

    constructor() {
        owner = msg.sender;
    }

    struct Game {
        address player1;
        address player2;
        uint256 startingTime;
        address winner;
        Turn currentTurn;
        Result result;
    }

    mapping(uint256 => Game) public games;
    uint256 private gameId;

    modifier enoughValue() {
        if (msg.value != 0.1 ether) {
            revert NOT_ENOUGH_ETH();
        }
        _;
    }

    modifier gameExists(uint256 _id) {
        if (games[_id].player1 == address(0)) {
            revert GAME_DOES_NOT_EXIST();
        }
        _;
    }

    modifier alreadyJoined(uint256 _id) {
        if (games[_id].player1 == games[_id].player1) {
            revert YOU_HAVE_ALREADY_JOINED();
        }
        _;
    }

    /*
    @dev Start a new game
    */

    function startGame() public payable enoughValue {
        Game storage game = games[gameId];
        game.player1 = msg.sender;
        game.currentTurn = Turn.player1;
        game.result = Result.active;
        gameId += 1;
        emit NewGame(gameId - 1, msg.sender);
    }

    /*
    @dev
    */
    function joinGame(
        uint256 _id
    ) public payable enoughValue gameExists(_id) alreadyJoined(_id) {}

    /*
    @dev Return the gameId
    */

    function getGameId() public view returns (uint256) {
        return gameId;
    }
}
