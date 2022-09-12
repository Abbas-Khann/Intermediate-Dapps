import { ethers } from "hardhat";
import { Contract } from "hardhat/internal/hardhat-network/stack-traces/model";


const main = async (): Promise <void> => {

  const deployContractFactory = await ethers.getContractFactory("deployer");

  const deployedContract = await deployContractFactory.deploy();

  await deployedContract.deployed();

  const deployerContractAddress: string = deployedContract.address;

  console.log("Deployer Contract Address", deployerContractAddress);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
