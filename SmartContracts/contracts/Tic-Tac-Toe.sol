// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

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

    uint256 public constant timeout = 10 minutes;

    constructor() {
        owner = msg.sender;
    }
}
