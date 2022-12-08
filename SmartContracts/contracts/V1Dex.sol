// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DEX is ERC20 {
    
    address public token;
    address immutable owner;

    constructor (address _token) ERC20(name(), symbol()) {
        owner = msg.sender;
        token = _token;
    }

    // Returns the amount of tokens in the contract

    function getTokensInContract() public view returns (uint256) {
        return ERC20(token).balanceOf(address(this));
    }

    // adding liquidity to exchange

    function addLiquidity(uint256 _amount) public payable returns (uint256) {
        uint256 _liquidity;
        uint256 balanceInEth = address(this).balance;
        uint256 tokenReserve = getTokensInContract();
        ERC20 _token = ERC20(token);

        // If the reserve is empty, intake any user supplied value for Eth and token due to no ratio

        if (tokenReserve == 0) {
            _token.transferFrom(msg.sender, address(this), _amount);
            _liquidity = balanceInEth;
            _mint(msg.sender, _liquidity);
        }
        // If it is not empty, intake user supplied value for eth and determine according to the ratio on the amount 
        // of tokens that need to be suppied to prevent large price impacts due to additional liquidity
        else {
            uint256 reservedEth = balanceInEth - msg.value;
            require(
            _amount >= (msg.value * tokenReserve) / reservedEth,
            "Amount of tokens sent is less than the minimum tokens required"
            );
            _token.transferFrom(msg.sender, address(this), _amount);
        unchecked {
            _liquidity = (totalSupply() * msg.value) / reservedEth;
        }
        _mint(msg.sender, _liquidity);
        }
        return _liquidity;
    }

    // Returns the amount of Eth/tokens that would be returned to the user in the swap

    function removeLiquidity(uint256 _amount) public returns (uint256, uint256) {
        require(
            _amount > 0, "Amount should be greater than zero"
        );
        uint256 _reservedEth = address(this).balance;
        uint256 _totalSupply = totalSupply();

        uint256 _ethAmount = (_reservedEth * _amount) / totalSupply();
        uint256 _tokenAmount = (getTokensInContract() * _amount) / _totalSupply;
        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(_ethAmount);
        ERC20(token).transfer(msg.sender ,_tokenAmount);
        return (_ethAmount, _tokenAmount);
    }

    // Returns the amount Eth/ tokens that would be returned to the user in the swap

    function getAmountOfTokens(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    )
    public pure returns (uint256) 
    {
        require(inputReserve > 0 && outputReserve > 0, "Invalid Reserves");
        // We are charging a fee of `1%`
        uint256 inputAmountWithFee = inputAmount * 99;
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = (inputReserve * 100) + inputAmountWithFee;
        unchecked {
            return numerator / denominator;
        }
    }

    // swaps Eth for tokens
    function swapEthTotoken(uint256 _minTokens) public payable  {
        uint256 _reservedTokens = getTokensInContract();
        uint256 _tokensBought = getAmountOfTokens(
            msg.value, 
            address(this).balance - msg.value, 
            _reservedTokens
            );
            require(_tokensBought >= _minTokens, "Insufficient Output Amount");
            ERC20(token).transfer(msg.sender, _tokensBought);
    }

    // Swaps tokens for eth
    function swapTokenToEth(uint256 _tokensSold, uint256 _minEth) public {
        uint256 _reservedTokens = getTokensInContract();
        uint256 ethBought = getAmountOfTokens(
        _tokensSold,
        _reservedTokens,
        address(this).balance
        );
        require(ethBought >= _minEth, "insufficient output amount");
        ERC20(token).transferFrom(
            msg.sender, 
            address(this), 
            _tokensSold
            );
        payable(msg.sender).transfer(ethBought);
    }
    
}