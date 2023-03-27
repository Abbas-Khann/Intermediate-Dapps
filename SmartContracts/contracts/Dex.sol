// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@thirdweb-dev/contracts/base/ERC20Base.sol";

contract DEX is ERC20Base {
    address public token;

    constructor(address _token) ERC20Base(name(), symbol()) {
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
    @dev modifier to check if the amount sent is 0
    */
    modifier enoughAmount() {
        require(msg.value != 0, "amount sent should be greater than 0");
        _;
    }

    /*
    @dev Adds liquidity to the exchange
    */
    function addLiquidity(
        uint256 _amount
    ) public payable enoughAmount returns (uint256) {
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
            mintTo(msg.sender, liquidity);
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
            uint256 tokenAmount = (msg.value * tokenReserve) / (ethReserve);
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
            mintTo(msg.sender, liquidity);
        }
        return liquidity;
    }

    /*
    @dev Returns the amount Eth/Custom tokens that would be returned to the user in the swap
    It removes Liquidity from the contract and gives the user their eth/custom token
    */

    function removeLiquidity(
        uint256 _amount
    ) public returns (uint256, uint256) {
        require(_amount > 0, "Amount should be greater than zero");
        uint256 ethReserve = address(this).balance;
        uint256 _totalSupply = totalSupply();
        // To calculate ethAmount we will multiply the reservedEth in the contract and multiply by the amount sent. divided by the totalSupply
        uint256 ethAmount = (ethReserve * _amount) / _totalSupply;
        // To calculate the tokenAmount we will get the reserve in the contract, multiply it by the amount sent and divide that with the totalSupply
        uint256 tokenAmount = (getReserve() * _amount) / _totalSupply;
        // After that we can perform the burn function and
        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(ethAmount);
        ERC20Base(token).transfer(msg.sender, tokenAmount);
        return (ethAmount, tokenAmount);
    }

    /*
    @dev Returns the amount Eth/token that would be returned to the user in the swap
    */

    function getTokenAmount(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) public pure returns (uint256) {
        require(inputReserve > 0 && outputReserve > 0, "Invalid reserves");
        uint256 inputAmountWithFee = inputAmount * 99;
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = (inputReserve * 100) + inputAmountWithFee;
        return numerator / denominator;
    }

    /*
    @dev Swap ether for token
    */

    function swapEtherForToken(uint256 _minTokens) public payable {
        uint256 tokenReserve = getReserve();
        uint256 tokensBought = getTokenAmount(
            msg.value,
            address(this).balance - msg.value,
            tokenReserve
        );
        require(tokensBought >= _minTokens, "Insufficient output amount");
        ERC20Base(token).transfer(msg.sender, tokensBought);
    }

    /*
    @dev Swap token for Ether
    */
    function swapTokenForEther(uint256 _tokensSold, uint256 _minEther) public {
        uint256 tokenReserve = getReserve();

        uint256 ethBought = getTokenAmount(
            _tokensSold,
            tokenReserve,
            address(this).balance
        );
        require(ethBought >= _minEther, "Insufficient output amount");
        // Transfer token from user's address to the contract
        ERC20Base(token).transferFrom(msg.sender, address(this), _tokensSold);
        payable(msg.sender).transfer(ethBought);
    }

    receive() external payable {}

    fallback() external payable {}
}
