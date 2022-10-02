export const CONTRACT_ADDRESS: string = "0xf7334D62221C7B806D8b0d22E9b7308440D382c7";
export const CONTRACT_ABI = [
  {
    "type": "constructor",
    "name": "",
    "inputs": [],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "appointmentCompleted",
    "inputs": [
      {
        "type": "uint256",
        "name": "_appointmentId",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "appointmentId",
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
    "name": "appointmentIds",
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
    "name": "appointments",
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
        "name": "title",
        "internalType": "string"
      },
      {
        "type": "address",
        "name": "attendee",
        "internalType": "address"
      },
      {
        "type": "uint256",
        "name": "startingTime",
        "internalType": "uint256"
      },
      {
        "type": "uint256",
        "name": "endingTime",
        "internalType": "uint256"
      },
      {
        "type": "uint256",
        "name": "amountPaid",
        "internalType": "uint256"
      },
      {
        "type": "bool",
        "name": "meetingTookPlace",
        "internalType": "bool"
      },
      {
        "type": "bool",
        "name": "cancelled",
        "internalType": "bool"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "cancelAppointment",
    "inputs": [
      {
        "type": "uint256",
        "name": "_appointmentId",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "payable"
  },
  {
    "type": "function",
    "name": "createAppointment",
    "inputs": [
      {
        "type": "string",
        "name": "_title",
        "internalType": "string"
      },
      {
        "type": "uint256",
        "name": "_startingTime",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "payable"
  },
  {
    "type": "function",
    "name": "getAmountPerCall",
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
    "name": "owner",
    "inputs": [],
    "outputs": [
      {
        "type": "address",
        "name": "",
        "internalType": "address payable"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "withdraw",
    "inputs": [
      {
        "type": "uint256",
        "name": "_appointmentId",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  }
]