// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@thirdweb-dev/contracts/token/TokenERC20.sol";

contract DEX is TokenERC20 {
    address public token;
    address immutable owner;

    constructor(
        string memory _name,
        string memory _symbol,
        address _primarySalesRecipient
    ) TokenERC20(_name, _symbol, msg.sender) {
        owner = msg.sender;
    }

    /*
    @dev contract Token balance
    */

    function getTokenBalance() public view returns (uint256) {
        return TokenERC20(token).balanceOf(address(this));
    }
}
