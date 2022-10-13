// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
/*
Contract functionalities and requirements
=> Contract should have a struct Employee with employee's address, position and salary.
=> Contract should have an enum Position that specifies all the positions.
=> Contract should have a mapping to check if the user is an Employee or not.
=> Contract should have another mapping to the struct.
=> The owner of the contract should be able to add a new employee to the system.
=> The owner should be able to get all the employees from an array.
=> The owner should be able to pay the interns, juniors and seniors seperately.
=> The owner should also be able to pay all of the employees with one single function.
=> The contract should have an addFunds function to add funds to the smart contract.
=> The contract should also have a withdraw function for the owner to be able to withdraw funds from the contract.
=> The contract should have seperate arrays of positions so we can render them seperately.
=> The owner should also be able to remove a particular employee from the array.
*/

contract SalaryManagement {

    address private owner;

    struct Employee {
        string name;
        string image;
        address employeeAddress;
        Position employeePosition;
    }

    address[] public interns;
    address[] public juniors;
    address[] public seniors;
    // creating an Enum 
    enum Position { Intern, Junior, Senior }
    mapping (address => bool) public isEmployee;
    mapping (uint256 => Employee) public employee;
    mapping (address => uint256) public employeeIds;
    uint256 public employeeId;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    /* <=============== ADD EMPLOYEE ===============> */
    function addEmployee(
        string memory _name,
        string memory _image,
        address _employeeAddress,
        Position _employeePosition
    ) public onlyOwner {
        isEmployee[_employeeAddress] = true;
        if (_employeePosition == Position.Intern) {
            interns.push(_employeeAddress);
        }
        else if (_employeePosition == Position.Junior) {
            juniors.push(_employeeAddress);
        }
        else if (_employeePosition == Position.Senior) {
            seniors.push(_employeeAddress);
        }
        employee[employeeId] = Employee(
            _name,
            _image,
            _employeeAddress,
            _employeePosition
        );
        employeeIds[msg.sender] = employeeId;
        employeeId++;
    }

    /* <=============== GET ALL EMPLOYEES ===============> */

    function getAllEmployes() public view returns (address[] memory,
     address[] memory,
     address[] memory) 
    {
        return (interns, juniors, seniors);
    }

    /* <=============== GET INTERN ARRAY LENGTH ===============> */

    function getInternsArrayLength() public view returns(uint256) {
        return interns.length;
    }

    /* <=============== PAY A PARTICULAR INTERN ===============> */
    function payAParticularIntern(uint _index) public payable onlyOwner {
        uint internMonthlyWage = 0.03 ether;
        internMonthlyWage = msg.value;
        require(_index < getInternsArrayLength(), "This index doesn't exist");
        interns[_index] = interns[getInternsArrayLength() - 1];
        (bool sent,) = interns[_index].call{value: internMonthlyWage}("");
        require(sent, "Failed to pay this intern");
    }

    /* <=============== PAY ALL INTERNS ===============> */
    function payAllInterns() public payable onlyOwner {
        uint internMonthlyWage = 0.03 ether;
        require(interns.length > 0, "There is no intern to pay");
        for (uint i = 0; i < interns.length; i++) {
            (bool sent,) = interns[i].call{value: internMonthlyWage}("");
            require(sent, "Failed to send salary to interns");
        }

    }
    
    /* <=============== DELETE A PARTICULAR INTERN ===============> */
    function deleteIntern(uint _index) public onlyOwner {
        require(_index < interns.length, "This index does not exist");
        interns[_index] = interns[getInternsArrayLength() - 1];
        interns.pop();
    }

    /* <=============== GET JUNIOR ARRAY LENGTH ===============> */
    function getJuniorsArrayLength() public view returns (uint256) {
        return juniors.length;
    }

    /* <=============== PAY ALL JUNIORS ===============> */
    function payAllJuniors() public payable onlyOwner {
        uint juniorsMonthlyWage = 0.02 ether;
        require(juniors.length > 0, "There is no junior to pay");
        for (uint256 i = 0; i < juniors.length; i++) {
            (bool sent, ) = juniors[i].call{value: juniorsMonthlyWage }("");
            require(sent, "Failed to pay Juniors");
        }
    }
    
    /* <=============== PAY A PARTICULAR JUNIOR ===============> */
    function payAParticularJunior(uint _index) public payable onlyOwner {
        require(_index < juniors.length, "This index doesn't exist");
        uint juniorsMonthlyWage = 0.02 ether;
        juniors[_index] = juniors[getJuniorsArrayLength() - 1];
        (bool sent,) = juniors[_index].call{value: juniorsMonthlyWage}("");
        require(sent, "Failed to pay this employee!");
    }    

    /* <=============== DELETE A PARTICULAR JUNIOR ===============> */
    function deleteJunior(uint _index) public onlyOwner {
        require(_index < getJuniorsArrayLength(), "This index does not exist");
        juniors[_index] = juniors[getJuniorsArrayLength() - 1];
        juniors.pop();
    }
    /* <=============== GET SENIOR ARRAY LENGTH ===============> */

    function getSeniorsArrayLength() public view returns (uint256) {
        return seniors.length;
    }

    /* <=============== PAY ALL SENIORS ===============> */

    function payAllSeniors() public payable onlyOwner {
        uint seniorsMonthlyWage = 0.01 ether;
        require(seniors.length > 0, "There is no senior to pay");
        for (uint i = 0; i < seniors.length; i++) {
            (bool sent, ) = seniors[i].call{value: seniorsMonthlyWage}("");
            require(sent, "Failed to pay seniors!");
        }
    }

    /* <=============== PAY A PARTICULAR SENIOR ===============> */
    function payAParticularSenior(uint _index) public payable onlyOwner {
        require(_index < seniors.length, "This index doesn't exist");
        uint seniorsMonthlyWage = 0.01 ether;
        seniors[_index] = seniors[getSeniorsArrayLength() - 1];
        (bool sent,) = seniors[_index].call{value: seniorsMonthlyWage}("");
        require(sent, "Failed to pay this senior Employee");
    }

    /* <=============== DELETE A SENIOR ===============> */
    function deleteSenior(uint _index) public {
        require(_index < getSeniorsArrayLength(), "This index does not exist");
        seniors[_index] = seniors[getSeniorsArrayLength() - 1];
        seniors.pop();
    }

    /* <=============== ADD MONEY TO THE SMART CONTRACT ===============> */
    function addFunds(uint _amount) public payable {
        require(
            _amount >= 0.01 ether, 
            "You need to sent more than 0.01 ether to the contract"
        );
    }

    /* <=============== GET CONTRACT BALANCE ===============> */
    function getContractBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    /* <=============== WITHDRAW MONEY FROM CONTRACT ===============> */
    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "There is no money to withdraw");
        uint256 contractBalance = address(this).balance;
        (bool sent, ) = msg.sender.call{value: contractBalance}("");
        require(sent, "COULD NOT WITHDRAW!!!");
    }

}