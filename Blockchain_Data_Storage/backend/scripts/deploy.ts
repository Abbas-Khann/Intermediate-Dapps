import { ethers } from "hardhat";

async function main() {
  const storageFactory = await ethers.getContractFactory("imageStorage");

  const deployedStorageContract = await storageFactory.deploy();

  await deployedStorageContract.deployed();

  const contractAddress: string = deployedStorageContract.address;

  console.log("Contract Address here", contractAddress)

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
