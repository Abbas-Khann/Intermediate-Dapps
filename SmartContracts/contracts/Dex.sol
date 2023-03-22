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

    /*
    @dev Returns the reserve amount of `token` held in the contract
    */
    function getReserve() public view returns (uint256) {
        return ERC20Base(token).balanceOf(address(this));
    }

    /*
    @dev Adds liquidity to the exchange
    */
    function addLiquidity(uint256 _amount) public payable returns (uint256) {
        uint256 liquidity;
        uint256 ethBalance = address(this).balance;
        uint256 tokenReserve = getReserve();
        ERC20Base _token = ERC20Base(token);

        /*
        If the reserve is empty, take any user supplied value for `Ether` and `token`
        since there is no ratio currently
        */
        if (tokenReserve == 0) {
            _token.transferFrom(msg.sender, address(this), _amount);
            liquidity = ethBalance;
            _mint(msg.sender, liquidity);
        } else {
            /*
            If the reserve is not empty, intake any user supplied value for `Ether` and
            determine according to the ratio how many `tokens` need to be supplied in order
            to prevent large price impacts because of additional liquidity
            */
            /* 
            Reserved Ether in this case would be the amount of ether in the contract - amount sent  
            Let's say that the contract consists of 5 ether and we sent 3 ether to the contract to add liquidity
            the reserve in this case would be 5 - 3 which would be equal to 2
            */
            uint256 ethReserve = ethBalance - msg.value;
            /*
            To maintain the liquidity and avoid any large price impacts we need to maintain the ratio
            We can do that via the formula (amount sent * tokenReserve) / ethReserve
            For example: 
            amount sent = 1 ether
            tokenReserve = 10 tokens
            ethReserve = 5 ether in the contract
            In this case: tokenAmount = (1 ether * 10)/(5 ether) // remember that the value will be in wei for calculation
           */
            uint256 tokenAmount = (msg.value - tokenReserve) / (ethReserve);
            require(
                _amount >= tokenAmount,
                "Amount sent is less than tokens required"
            );
            _token.transferFrom(msg.sender, address(this), tokenAmount);
            /*
            The amount of LP tokens that would be sent to the user should be proportional to the liquidity of 
            ether added by the user
            by some maths -> liquidity =  (totalSupply of LP tokens in contract * (Eth sent by the user))/(Eth reserve in the contract)
           */
            liquidity = (totalSupply() * msg.value) / ethReserve;
            _mint(msg.sender, liquidity);
        }
        return liquidity;
    }
}
