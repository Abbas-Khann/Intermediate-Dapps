// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.11;

// =================================================== //
//  KHATTAK OPTICS //
// =================================================== //

/*
=> Display daily Income/Expense
=> Weekly Income/Expenses
=> Monthly Income/Expenses
=> Daily Sales / Monthly Sales / Yearly Sales
=> 
*/
contract Expense_Tracker {
    address owner;

    struct Transaction {
        string text;
        uint256 amount;
    }

    constructor() {
        owner = msg.sender;
    }

    Transaction[] public transaction;

    modifier onlyOwner() {
        require(msg.sender == owner, "NOT_OWNER");
        _;
    }

    function addExpense(
        string memory _text,
        uint256 _amount
    ) external onlyOwner {
        transaction.push(Transaction(_text, _amount));
    }
}
