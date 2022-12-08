// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

contract Lottery is VRFConsumerBaseV2, ConfirmedOwner {

    // lottery should start only when a certain amount of players are completed
    // lottery should randomly Choose a winner from an array
    // lottery should have an entry fee decided by owner of the lottery
    // it should have a join game function users can join
    // and a getRandomWinner function

    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);
    event GameStarted(uint256 gameId, uint8 maxPlayers, uint256 entryFee);
    event PlayerJoined(uint256 gameId, address player);
    event GameEnded(uint256 gameId, address winner);

    struct RequestStatus {
        bool fulfilled;
        bool exists;
        uint256[] randomWords;
    }

    bool public started;
    address[] public players;
    
    uint256 public gameId;
    uint8 maxPlayers;
    uint256 entryFee;

    mapping (uint256 => RequestStatus) public s_requests;
    VRFCoordinatorV2Interface COORDINATOR;
    
    uint64 s_subscriptionId;

    uint256[] public requestIds;
    uint256 public lastRequestId;

    bytes32 keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
    uint32 callbackGasLimit = 100000;
    uint16 requestConfirmations = 3;

    uint32 numWords = 1;

    constructor(
        uint64 subscriptionId
    )
    VRFConsumerBaseV2(0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D) 
    ConfirmedOwner(msg.sender)
    {
        COORDINATOR = VRFCoordinatorV2Interface(0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D);
        s_subscriptionId = subscriptionId;
    }

    function requestRandomWords()
    public  
    onlyOwner
    returns (uint256 requestId)
    {
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        s_requests[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
    }

    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory randomWords
    )
    internal
    override 
    {
        require(
            s_requests[_requestId].exists, "request not found"
        );
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = randomWords;
        uint256 winnerIndex = randomWords[0] % players.length;
        address winner = players[winnerIndex];
        uint _amount = address(this).balance / 100 * 90;
        (bool sent, ) = winner.call{ value: _amount }("");
        require(sent, "FAILED_TO_REWARD_WINNER");
        emit RequestFulfilled(_requestId, randomWords);
    }

    function getRequestStatus(
        uint256 _requestId
    )
    external 
    view 
    returns (bool fulfilled, uint256[] memory randomWords)
    {
        require(
            s_requests[_requestId].exists, "Request Not Found"
        );
        RequestStatus memory request = s_requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }

    function startGame(
     uint8 _maxPlayers,
     uint256 _entryFee
     ) 
     external 
     onlyOwner 
     {
        require(
            !started, "GAME_ALREADY_STARTED"
        );
        // Empty the array before starting the new game 
        // since we want this contract to be reusable
        delete players;
        // the owner of the game can set up the maximum amount of
        // players that can play in one single game
        maxPlayers = _maxPlayers;
        // setting up the entry fee of the game
        entryFee = _entryFee;
        // incrementing the gameId
        gameId++;
        started = true;
        emit GameStarted(gameId, maxPlayers, entryFee);
    }

    function joinGame() public payable {
        require(
            started, "GAME_NOT_STARTED_YET"
        );
        require(
            msg.value >= entryFee,
            "NOT_ENOUGH_ETH"
        );
        require(
            players.length < maxPlayers,
            "GAME_IS_FULL"
        );
        players.push(msg.sender);
        emit PlayerJoined(gameId, msg.sender);

        if (players.length == maxPlayers) {
            requestRandomWords();
        }
    }
}