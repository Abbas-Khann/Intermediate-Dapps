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
error GAME_NOT_STARTED_YET();
error NOT_PLAYER();
error MOVE_NOT_MADE();

contract Tic_Tac_Toe {
    address owner;

    uint256 public constant TIMEOUT = 5 minutes;
    // Game Events here
    event NewGame(uint256 gameId, address creator, uint256 timestamp);
    event GameJoined(uint256 gameId, address joinee, uint256 timestamp);
    event MoveMade(uint256 gameId, address movee, uint256 timestamp);

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

    modifier gameStarted(uint256 _id) {
        if (games[_id].player2 == address(0)) {
            revert GAME_NOT_STARTED_YET();
        }
        _;
    }

    modifier isCalledByPlayer(uint256 _id) {
        if (
            msg.sender != games[_id].player1 || msg.sender != games[_id].player2
        ) {
            revert NOT_PLAYER();
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
    @dev Make a move in the game
    */
    function makeMove(
        uint256 _id,
        uint8 x,
        uint8 y
    ) public gameExists(_id) gameStarted(_id) isCalledByPlayer(_id) {
        Game storage _game = games[_id];
        require(msg.sender == getCurrentPlayer(_id), "NOT_YOUR_TURN");
        // check for invalid move here
        if (getCurrentPlayer(_id) == _game.player1) {
            _game.moves[x] = x;
            _game._moves[x] = msg.sender;
        } else if (getCurrentPlayer(_id) == _game.player2) {
            _game.moves[y] = y;
            _game._moves[y] = msg.sender;
        } else {
            revert MOVE_NOT_MADE();
        }
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
    @dev Fetch the current player supposed to make a move
    */
    function getCurrentPlayer(uint256 _id) public view returns (address) {
        if (games[_id].currentTurn == Turn.player1) {
            return games[_id].player1;
        } else if (games[_id].currentTurn == Turn.player2) {
            return games[_id].player2;
        } else {
            revert("Unexpected Error Occurred");
        }
    }

    /*
    @dev Fetch the next player supposed to make a move
    */
    function getNextPlayer(Turn _currentTurn) public pure returns (Turn) {
        if (_currentTurn == Turn.player1) {
            return Turn.player2;
        } else if (_currentTurn == Turn.player2) {
            return Turn.player1;
        } else revert("Err fetching next player");
    }

    /*
    @dev Return the gameId
    */
    function getGameId() public view returns (uint256) {
        return gameId;
    }
}
