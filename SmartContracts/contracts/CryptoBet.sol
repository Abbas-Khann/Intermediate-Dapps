// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract CryptoBet {

    error NOT_ENOUGH_ETH_TO_PLAY_GAME();
    error NOT_OWNER();
    error GAME_PAUSED_OR_NOT_STARTED();
    error NOT_ENOUGH_ETH_TO_BET();

    event BetPlaced(address indexed better, Bet);


    address payable private immutable owner;
    uint256 private immutable entryAmount;
    uint256 private bettingAmount;
    uint256 private gameTime;
    uint256 private startingPrice;
    bool private started;
    bool private paused;

    address payable[] private highBetters;
    address payable[] private lowBetters;
    address payable[] private winners;
    mapping (address => bool) public hasBetted;
    mapping (address => uint256) public addressToAmountBetted;
    enum Bet {
        HIGH, // Betters who will bet on the price being higher
        LOW // Low means users whom bet on the price being lower
    }

    AggregatorV3Interface internal priceFeed;

    constructor(uint256 _entryAmount, uint256 _bettingAmount) payable {
        priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        owner = payable(msg.sender);
        bettingAmount = _bettingAmount;
        entryAmount = _entryAmount;
        if (msg.value < _entryAmount) {
            revert NOT_ENOUGH_ETH_TO_PLAY_GAME();
        }
    }
    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (uint256) {
        (,int price ,,,) = priceFeed.latestRoundData();
        return uint256(price) / 100000000;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NOT_OWNER();
        }
        _;
    }

    function startGame() external onlyOwner {
        uint256 initialPrice = getLatestPrice();
        initialPrice = startingPrice;
        require(!started, "ALREADY_STARTED");
        started = true;
        gameTime = block.timestamp + 24 hours;
    }

    function pauseGame() external onlyOwner {
        require(started, "NOT_STARTED");
        paused = true;
    }

    modifier gameRunning() {
        if (!paused && started) {
            revert GAME_PAUSED_OR_NOT_STARTED();
        }
        _;
    }

    modifier notEnough() {
        if (msg.value < bettingAmount) {
            revert NOT_ENOUGH_ETH_TO_BET();
        }
        _;
    }

    function placeBet(
        Bet _bet
        )
        external 
        payable 
        gameRunning
        notEnough
        {
        require(!hasBetted[msg.sender], "ALREADY_BETTED");
        if (_bet == Bet.HIGH) {
            address payable highBetter = payable(msg.sender);
            highBetters.push(highBetter);
        }
        else if (_bet == Bet.LOW) {
            address payable lowBetter = payable(msg.sender);
            lowBetters.push(lowBetter);
        }
        hasBetted[msg.sender] = true;
        addressToAmountBetted[msg.sender] += msg.value;
        emit BetPlaced(msg.sender, _bet);
    }

    // this function should execute automatically after the time is reached
    function checkPrice() external {
        uint256 latestPrice = getLatestPrice();
        require(gameTime < block.timestamp, "TIME_NOT_EXCEEDED_YET");
        if (startingPrice < latestPrice) { // 1200 ==> 1000 1200 < 1000 
            winners = lowBetters;
            // highBetters lose
            // lowBetters win
        }
        else {
            winners = highBetters;
            // highBetters win
            // lowBetters lose
        }
    }

     function rewardWinners() external onlyOwner {
        require(block.timestamp > gameTime, "TIME_NOT_EXCEEDED_YET");
        // evaluate the amount to send to each winner;
            uint256 _amount = (address(this).balance * 90)/100;
        for (uint i = 0; i < winners.length; i++) {
            (bool sent, ) = winners[i].call{ value: _amount/winners.length}("");
            require(sent, "FAILED_TO_REWARD_WINNERS");
        }
    }

    function withdraw() external onlyOwner {
        require(block.timestamp > gameTime, "TIME_NOT_EXCEEDED_YET");
        uint256 _amount = returnTenPercent();
        (bool sent,) = owner.call{ value: _amount }("");
        require(sent, "FAILED_TO_WITHDRAW");
    }

    function returnTenPercent() public view returns(uint256) {
        unchecked {
            uint256 _amount = address(this).balance / 100 * 10;
            return _amount;
        }
    }

    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function returnHighBetters() public view returns (address payable[] memory) {
        return highBetters;
    }

    function returnLowBetters() public view returns (address payable[] memory) {
        return lowBetters;
    }

    function returnWinners() public view returns (address payable[] memory) {
        return winners;
    }

    function returnEntryAmount() public view returns (uint256) {
        return entryAmount;
    }

    function returnGameTime() public view returns (uint256) {
        return gameTime;
    }

    function returnStartingPrice() public view returns (uint256) {
        return startingPrice;
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

}