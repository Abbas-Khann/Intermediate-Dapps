// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;

/*
=> User will enter the game by betting some Eth.
=> Second user will enter the game by betting the same amount.
=> Game will start now and last for about maximum of 2 minutes.
=> Users will start making moves in patterns.
=> Whoever forfeits will lose all the money and the other person will win.
=> If one user wins they win all the money and the owner of the contract gets 10% commission
*/

error NOT_ENOUGH_ETH();
error GAME_DOES_NOT_EXIST();
error YOU_HAVE_ALREADY_JOINED();
error GAME_NOT_STARTED_YET();
error NOT_PLAYER();
error MOVE_NOT_MADE();
error ONLY_PLAYER_ONE_CAN_REFUND();
error GAME_NOT_ACTIVE();

// claimRefund if player two doesn't join
// check for draw and pay the players back
// check for forfeit conditions

contract Tic_Tac_Toe {
    address owner;

    uint256 public constant TIMEOUT = 4 minutes;
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
        address[9] _moves;
        uint256 amountSent;
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

    modifier isGameActive(uint256 _id) {
        if (games[_id].result != Result.active) {
            revert GAME_NOT_ACTIVE();
        }
        _;
    }

    modifier onlyPlayerOne(uint256 _id) {
        if (games[_id].player1 != msg.sender) {
            revert ONLY_PLAYER_ONE_CAN_REFUND();
        }
        _;
    }

    modifier isCalledByPlayer(uint256 _id) {
        if (
            msg.sender != games[_id].player1 && msg.sender != games[_id].player2
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
        game.amountSent += msg.value;
        gameId += 1;
        emit NewGame(gameId - 1, msg.sender, block.timestamp);
    }

    /*
    @dev Join an existing game as player 2
    */
    function joinGame(
        uint256 _id
    )
        public
        payable
        isGameActive(_id)
        enoughValue
        gameExists(_id)
        alreadyJoined(_id)
    {
        require(games[_id].player2 == address(0), "ALREADY_JOINED!!!");
        games[_id].player2 = msg.sender;
        games[_id].startingTime = block.timestamp;
        games[_id].amountSent += msg.value;
        emit GameJoined(_id, msg.sender, block.timestamp);
    }

    /*
    @dev Make a move in the game
    */
    function makeMove(
        uint256 _id,
        uint8 x
    ) public gameExists(_id) gameStarted(_id) isCalledByPlayer(_id) {
        Game storage _game = games[_id];
        require(msg.sender == getCurrentPlayer(_id), "NOT_YOUR_TURN");
        require(x <= 8, "INVALID_MOVE");
        require(_game._moves[x] == address(0), "THIS_BOARD_IS_ALREADY_FILLED");
        require(_game.winner == address(0), "GAME_ALREADY_ENDED");
        _game._moves[x] = getCurrentPlayer(_id);
        if (checkRows(_id) || checkColumns(_id) || checkDiagonals(_id)) {
            _game.winner = getCurrentPlayer(_id);
            (bool sendCommission, ) = owner.call{value: getGameCommission(_id)}(
                ""
            );
            require(sendCommission, "Failed to send game commission to owner");
        }
        if (_game.winner == _game.player1) {
            _game.result = Result.player1Wins;
            (bool rewardPlayerOne, ) = _game.player1.call{
                value: getWinnerReward(_id)
            }("");
            require(rewardPlayerOne, "FAILED_TO_REWARD_PLAYER_ONE");
        } else if (_game.winner == _game.player2) {
            _game.result = Result.player2Wins;
            (bool rewardPlayerTwo, ) = _game.player2.call{
                value: getWinnerReward(_id)
            }("");
            require(rewardPlayerTwo, "FAILED_TO_REWARD_PLAYER_TWO");
        }
        if (checkDraw(_id) && _game.winner == address(0)) {
            _game.result = Result.draw;
            (bool sendBackToPlayer1, ) = _game.player1.call{
                value: _game.amountSent / 2
            }("");
            require(sendBackToPlayer1, "FAILED_TO_SEND_BACK");
            (bool sendBackToPlayer2, ) = _game.player2.call{
                value: _game.amountSent / 2
            }("");
            require(sendBackToPlayer2, "FAILED_TO_SEND_BACK");
        }
        _game.currentTurn = getNextPlayer(_game.currentTurn);
        emit MoveMade(_id, msg.sender, block.timestamp);
    }

    /*
    @dev Claim refund if player2 doesn't join inside 5 minutes
    */
    function claimRefund(
        uint256 _id
    )
        external
        isGameActive(_id)
        gameExists(_id)
        onlyPlayerOne(_id)
        returns (bool success)
    {
        Game storage _game = games[_id];
        require(
            _game.player2 == address(0),
            "Cannot claim refund player2 has joined!!!"
        );
        (bool refund, ) = msg.sender.call{value: _game.amountSent}("");
        require(refund, "Failed to refund");
        _game.result = Result.abandoned;
        // timestamp here
        return true;
    }

    /*
    @dev Checking if the columns are matched
    */
    function checkColumns(uint256 _id) public view returns (bool) {
        Game storage _game = games[_id];
        if (
            _game._moves[0] == getCurrentPlayer(_id) &&
            _game._moves[1] == getCurrentPlayer(_id) &&
            _game._moves[2] == getCurrentPlayer(_id)
        ) {
            return true;
        }
        if (
            _game._moves[3] == getCurrentPlayer(_id) &&
            _game._moves[4] == getCurrentPlayer(_id) &&
            _game._moves[5] == getCurrentPlayer(_id)
        ) {
            return true;
        }
        if (
            _game._moves[6] == getCurrentPlayer(_id) &&
            _game._moves[7] == getCurrentPlayer(_id) &&
            _game._moves[8] == getCurrentPlayer(_id)
        ) {
            return true;
        }
        return false;
    }

    /*
    @dev Checking if the rows are matched
    */
    function checkRows(uint256 _id) public view returns (bool) {
        Game storage _game = games[_id];
        if (
            _game._moves[0] == getCurrentPlayer(_id) &&
            _game._moves[3] == getCurrentPlayer(_id) &&
            _game._moves[6] == getCurrentPlayer(_id)
        ) {
            return true;
        }
        if (
            _game._moves[1] == getCurrentPlayer(_id) &&
            _game._moves[4] == getCurrentPlayer(_id) &&
            _game._moves[7] == getCurrentPlayer(_id)
        ) {
            return true;
        }
        if (
            _game._moves[2] == getCurrentPlayer(_id) &&
            _game._moves[5] == getCurrentPlayer(_id) &&
            _game._moves[8] == getCurrentPlayer(_id)
        ) {
            return true;
        }
        return false;
    }

    /*
    @dev Checking for diagonals now
    */
    function checkDiagonals(uint256 _id) public view returns (bool) {
        Game storage _game = games[_id];
        if (
            _game._moves[2] == getCurrentPlayer(_id) &&
            _game._moves[4] == getCurrentPlayer(_id) &&
            _game._moves[6] == getCurrentPlayer(_id)
        ) {
            return true;
        }
        if (
            _game._moves[0] == getCurrentPlayer(_id) &&
            _game._moves[4] == getCurrentPlayer(_id) &&
            _game._moves[8] == getCurrentPlayer(_id)
        ) {
            return true;
        }
        return false;
    }

    /*
    @dev Check for draw
    */
    function checkDraw(uint256 _id) public view returns (bool) {
        Game storage _game = games[_id];
        for (uint8 i = 0; i < _game._moves.length; i++) {
            if (_game._moves[i] == address(0)) {
                return false;
            }
        }
        return true;
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

    /*
    @dev Getter function to get game array from the struct
    */
    function getMoves(uint256 _id) public view returns (address[9] memory) {
        return games[_id]._moves;
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getGameCommission(uint256 _id) public view returns (uint256) {
        return (games[_id].amountSent / 100) * 10;
    }

    function getWinnerReward(uint256 _id) public view returns (uint256) {
        return (games[_id].amountSent / 100) * 90;
    }

    receive() external payable {}

    fallback() external payable {}
}
