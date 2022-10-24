export const CONTRACT_ADDRESS: string = "0x818B56D53dD213a8B226811916EE5036b2adE148";
export const abi = [
  {
    "type": "constructor",
    "name": "",
    "inputs": [],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "addEmployee",
    "inputs": [
      {
        "type": "string",
        "name": "_name",
        "internalType": "string"
      },
      {
        "type": "address",
        "name": "_employeeAddress",
        "internalType": "address"
      },
      {
        "type": "uint8",
        "name": "_employeePosition",
        "internalType": "enum SalaryManagement.Position"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "addFunds",
    "inputs": [
      {
        "type": "uint256",
        "name": "_amount",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "payable"
  },
  {
    "type": "function",
    "name": "deleteIntern",
    "inputs": [
      {
        "type": "uint256",
        "name": "_index",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "deleteJunior",
    "inputs": [
      {
        "type": "uint256",
        "name": "_index",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "deleteSenior",
    "inputs": [
      {
        "type": "uint256",
        "name": "_index",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "employee",
    "inputs": [
      {
        "type": "uint256",
        "name": "",
        "internalType": "uint256"
      }
    ],
    "outputs": [
      {
        "type": "string",
        "name": "name",
        "internalType": "string"
      },
      {
        "type": "address",
        "name": "employeeAddress",
        "internalType": "address"
      },
      {
        "type": "uint8",
        "name": "employeePosition",
        "internalType": "enum SalaryManagement.Position"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "employeeId",
    "inputs": [],
    "outputs": [
      {
        "type": "uint256",
        "name": "",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "employeeIds",
    "inputs": [
      {
        "type": "address",
        "name": "",
        "internalType": "address"
      }
    ],
    "outputs": [
      {
        "type": "uint256",
        "name": "",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getAllEmployes",
    "inputs": [],
    "outputs": [
      {
        "type": "address[]",
        "name": "",
        "internalType": "address[]"
      },
      {
        "type": "address[]",
        "name": "",
        "internalType": "address[]"
      },
      {
        "type": "address[]",
        "name": "",
        "internalType": "address[]"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getContractBalance",
    "inputs": [],
    "outputs": [
      {
        "type": "uint256",
        "name": "",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getEmployeeId",
    "inputs": [
      {
        "type": "address",
        "name": "user",
        "internalType": "address"
      }
    ],
    "outputs": [
      {
        "type": "uint256",
        "name": "",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getInternsArrayLength",
    "inputs": [],
    "outputs": [
      {
        "type": "uint256",
        "name": "",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getJuniorsArrayLength",
    "inputs": [],
    "outputs": [
      {
        "type": "uint256",
        "name": "",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getSeniorsArrayLength",
    "inputs": [],
    "outputs": [
      {
        "type": "uint256",
        "name": "",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "interns",
    "inputs": [
      {
        "type": "uint256",
        "name": "",
        "internalType": "uint256"
      }
    ],
    "outputs": [
      {
        "type": "address",
        "name": "",
        "internalType": "address"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "isEmployee",
    "inputs": [
      {
        "type": "address",
        "name": "",
        "internalType": "address"
      }
    ],
    "outputs": [
      {
        "type": "bool",
        "name": "",
        "internalType": "bool"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "juniors",
    "inputs": [
      {
        "type": "uint256",
        "name": "",
        "internalType": "uint256"
      }
    ],
    "outputs": [
      {
        "type": "address",
        "name": "",
        "internalType": "address"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "payAParticularIntern",
    "inputs": [
      {
        "type": "uint256",
        "name": "_index",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "payable"
  },
  {
    "type": "function",
    "name": "payAParticularJunior",
    "inputs": [
      {
        "type": "uint256",
        "name": "_index",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "payable"
  },
  {
    "type": "function",
    "name": "payAParticularSenior",
    "inputs": [
      {
        "type": "uint256",
        "name": "_index",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "payable"
  },
  {
    "type": "function",
    "name": "payAllInterns",
    "inputs": [],
    "outputs": [],
    "stateMutability": "payable"
  },
  {
    "type": "function",
    "name": "payAllJuniors",
    "inputs": [],
    "outputs": [],
    "stateMutability": "payable"
  },
  {
    "type": "function",
    "name": "payAllSeniors",
    "inputs": [],
    "outputs": [],
    "stateMutability": "payable"
  },
  {
    "type": "function",
    "name": "seniors",
    "inputs": [
      {
        "type": "uint256",
        "name": "",
        "internalType": "uint256"
      }
    ],
    "outputs": [
      {
        "type": "address",
        "name": "",
        "internalType": "address"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "withdraw",
    "inputs": [],
    "outputs": [],
    "stateMutability": "nonpayable"
  }
]