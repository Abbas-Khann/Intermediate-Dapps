// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TimeLockWallet {
    
    address payable public owner;

    struct Lock {
        uint256 amount;
        uint256 time;
        bool status;
    }

    mapping (uint256 => Lock) public lock;
    uint256 lockId;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "NOT_OWNER");
        _;
    }

    // transfer function to transfer eth to another wallet or contract
    function transfer(address _to)
     external 
     onlyOwner
     payable 
    {
        require(walletBalance() > 0, "NOTHING_TO_TRANSFER");
        (bool sent ,) = _to.call{ value: msg.value }("");
        require(sent, "FAILED_TO_TRANSFER");
    }

    function lockFunds(uint256 _time)
    public
    onlyOwner
    payable
    {
        require(msg.value > 0, "UNEQUAL_AMOUNT_SENT");
        lock[lockId].amount = msg.value;
        lock[lockId].time = _time;
        lock[lockId].status = true;
        lockId++;
    }

    function withdrawLockedFunds(uint256 _id)
    external
    onlyOwner
    {
        Lock storage thisLock = lock[_id];
        require(thisLock.amount > 0, "LOCK_DOES_NOT_EXIST");
        require(thisLock.time < block.timestamp, "TIME_NOT_EXCEEDED!!!");
        thisLock.status = false;
        payable(owner).transfer(thisLock.amount);
        thisLock.amount = 0;
        thisLock.time = 0;
    }

    function getAllLockedFunds() public view returns (uint256) {
        uint256 _amount;
        for (uint256 i = 0; i < lockId; i++) {
            _amount += lock[i].amount;
        }
        return _amount;
    }

    function getLockedFundsAtId(uint256 _id) public view returns (uint256) {
        return lock[_id].amount;
    }

    function walletBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getLockId() public view returns (uint256) {
        return lockId;
    }

    receive() external payable {}

    fallback() external payable {}
}