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
    event NewGame(uint256 gameId, address creator, uint256 timestamp);
    event GameJoined(uint256 gameId, address joinee, uint256 timestamp);

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
        uint8[] moves;
        address[9] _moves;
        Turn currentTurn;
        Turn[3][3] matrix;
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
        if (games[_id].player1 == msg.sender) {
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
        emit NewGame(gameId - 1, msg.sender, block.timestamp);
    }

    /*
    @dev Join an existing game as player 2
    */
    function joinGame(
        uint256 _id
    ) public payable enoughValue gameExists(_id) alreadyJoined(_id) {
        games[_id].player2 = msg.sender;
        games[_id].startingTime = block.timestamp;
        emit GameJoined(_id, msg.sender, block.timestamp);
    }

    /*
    @dev Checking if the columns are matched
    */
    function checkColumns(uint256 _id) public view returns (bool) {
        Game storage _game = games[_id];
        for (uint8 i = 0; i < 9; i++) {
            if (
                _game._moves[0] == _game.player1 &&
                _game._moves[1] == _game.player1 &&
                _game._moves[2] == _game.player1
            )
                if (
                    _game._moves[0] == _game.player2 &&
                    _game._moves[1] == _game.player2 &&
                    _game._moves[2] == _game.player2
                ) {
                    return true;
                } else if (
                    _game._moves[3] == _game.player1 &&
                    _game._moves[4] == _game.player1 &&
                    _game._moves[5] == _game.player1
                ) {
                    if (
                        _game._moves[3] == _game.player2 &&
                        _game._moves[4] == _game.player2 &&
                        _game._moves[5] == _game.player2
                    ) return true;
                } else if (
                    _game._moves[6] == _game.player1 &&
                    _game._moves[7] == _game.player1 &&
                    _game._moves[8] == _game.player1
                ) {
                    if (
                        _game._moves[6] == _game.player2 &&
                        _game._moves[7] == _game.player2 &&
                        _game._moves[8] == _game.player2
                    ) return true;
                }
        }
        return false;
    }

    /*
    @dev Return the gameId
    */
    function getGameId() public view returns (uint256) {
        return gameId;
    }
}
