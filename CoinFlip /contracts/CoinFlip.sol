// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";

contract CoinFlip is VRFV2WrapperConsumerBase{

    address public owner;
    event CoinFlipRequest(uint256 requestId);
    event CoinFlipResult(uint256 requestId, bool didWin);

    enum CoinFlipSelection {
        HEADS,
        TAILS
    }

    struct CoinFlipStatus {
        uint256 fees;
        uint256 randomWord;
        address player;
        bool didWin;
        bool fulfilled;
        CoinFlipSelection choice;
    }

    address constant linkToken = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    address constant VRFWrapper = 0x708701a1DfF4f478de54383E49a627eD4852C816;

    uint128 constant entryFees = 0.001 ether;
    uint32 constant callbackGasLimit = 1_000_000;
    uint32 constant numWords = 1;
    uint16 constant requestConfirmations = 3;

    mapping (uint256 => CoinFlipStatus) public statuses;

    constructor() VRFV2WrapperConsumerBase(linkToken, VRFWrapper) {
        owner = msg.sender;
    }

    modifier notEnough {
        require(msg.value >= entryFees, "YOU_NEED_TO_PAY_ENTRY_FEES");
        _;
    }

    function flip(CoinFlipSelection coinChoice)
        external
        payable
        notEnough
        returns(uint256) 
        {
            uint256 requestId = requestRandomness(
                callbackGasLimit,
                requestConfirmations, 
                numWords
                );
            statuses[requestId] = CoinFlipStatus({
                fees: VRF_V2_WRAPPER.calculateRequestPrice(callbackGasLimit),
                randomWord: 0,
                player: msg.sender,
                didWin: false,
                fulfilled: false,
                choice: coinChoice
            });

         emit CoinFlipRequest(requestId);
         return requestId;
        }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords)
        internal
        override
    {
        require(
            statuses[requestId].fees > 0, "Request not found!"
        );
        statuses[requestId].fulfilled = true;
        statuses[requestId].randomWord = randomWords[0];

        CoinFlipSelection result = CoinFlipSelection.HEADS;
        if (randomWords[0] % 2 == 0) {
            result = CoinFlipSelection.TAILS;
        }
        
        if(statuses[requestId].choice == result) {
            statuses[requestId].didWin = true;
            payable(statuses[requestId].player).transfer(entryFees * 2);
        }
        emit CoinFlipResult(requestId, statuses[requestId].didWin);
    }

    function getStatus(uint256 requestId) public view returns(CoinFlipStatus memory) {
        return statuses[requestId];
    }

}
