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

contract Tic_Tac_Toe {
    address owner;

    uint256 public constant TIMEOUT = 5 minutes;

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

    mapping(uint256 => Game) public game;
    uint256 gameId;
}
