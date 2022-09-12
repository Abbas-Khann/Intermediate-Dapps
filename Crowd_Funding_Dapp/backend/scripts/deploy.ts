import { ethers } from "hardhat";
import { Contract } from "hardhat/internal/hardhat-network/stack-traces/model";


const main = async (): Promise <void> => {

  const deployContractFactory = await ethers.getContractFactory("CrowdFunding");

  const deployedContract = await deployContractFactory.deploy(5, 10800);

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
