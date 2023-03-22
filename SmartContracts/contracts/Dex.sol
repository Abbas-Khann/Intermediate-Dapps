// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@thirdweb-dev/contracts/base/ERC20Base.sol";

contract DEX is ERC20Base {
    address public token;

    constructor(
        string memory _name,
        string memory _symbol,
        address _token
    ) ERC20Base(_name, _symbol) {
        require(_token != address(0), "Not a valid ERC20 token address");
        token = _token;
    }
}
