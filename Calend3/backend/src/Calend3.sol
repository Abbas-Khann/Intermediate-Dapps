// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// -> We should have a struct with all the necessary properties for the appointment
// -> We should be able to create an appointment
// -> We should be able to get the balance of the contract
// -> Owner should be able to withdraw money from the contract and call the withdraw function
// -> The owner should be able to set min amount for the appointment taker
// -> If the person doesn't show up to the meeting then refund their money back
// -> Compare the time and check if the meeting took place

contract Calend3 {
    
    uint256 minAmountPerCall;
    address payable public owner;

    struct Appointment {
        string title;
        address attendee;
        uint256 startingTime;
        uint256 endingTime;
        uint256 amountPaid;
        bool meetingTookPlace;
        bool cancelled;
    }

    mapping (uint256 => Appointment) public appointments;
    mapping (address => uint256) public appointmentIds;
    uint256 public appointmentId;


    constructor() {
        owner = payable(msg.sender);
        minAmountPerCall = 0.1 ether;
    }

    modifier onlyOwner() {
        require(
            owner == msg.sender, "You are not the owner!"
        );
        _;
    }

    function getContractBalance() public view onlyOwner returns(uint256) {
        return address(this).balance;
    }

    function getAmountPerCall() public view returns(uint256) {
        return minAmountPerCall;
    }

    modifier enoughPay() {
        require(
            msg.value >= minAmountPerCall,
            "You need to pay at least 0.1 Eth to create an Appointment"
        );
        _;
    }

    function createAppointment(
        string memory _title,
        uint256 _startingTime
    )
    public payable enoughPay {
        appointments[appointmentId] = Appointment(
            _title,
            msg.sender,
            _startingTime,
            _startingTime + 1 hours,
            msg.value,
            false,
            false
        );
        appointmentIds[msg.sender] = appointmentId;
        appointmentId++; 
    }

    function appointmentCompleted(uint256 _appointmentId) public {
        Appointment storage thisAppointment = appointments[_appointmentId];
        require(
            thisAppointment.endingTime <= block.timestamp,
            "The appointment time hasn't ended yet!"
        );
        require(
            thisAppointment.cancelled == false, 
            "This appointment has already been cancelled!"
        );
        thisAppointment.meetingTookPlace = true;
    }

    function cancelAppointment(uint256 _appointmentId) external payable onlyOwner {
        Appointment storage thisAppointment = appointments[_appointmentId];
        require(
            thisAppointment.meetingTookPlace == false,
            "Meeting already took place"
        );
        require(
            block.timestamp < thisAppointment.startingTime,
            "This appointment can't be cancelled now!"
        );
        thisAppointment.cancelled = true;
        address payable user = payable(thisAppointment.attendee);
        uint256 _amount = thisAppointment.amountPaid;
        (bool sent, ) = user.call{value: _amount}("");
        require(sent, "Failed to send Eth");
    }

    function withdraw(uint256 _appointmentId) public onlyOwner {
        Appointment storage thisAppointment = appointments[_appointmentId];
        require(
            thisAppointment.meetingTookPlace == true,
           "You can't withdraw money since the meeting didn't take place"
        );
        require(
            block.timestamp > thisAppointment.endingTime, 
            "The timing of the appointment has not reached yet!"
        );
        uint256 _amount = address(this).balance;
        (bool sent, ) = owner.call{value: _amount}("");
        require(sent, "Failed to send Eth");
    }
    

}
