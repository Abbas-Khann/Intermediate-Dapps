import * as dotenv from "dotenv";
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

dotenv.config()

const GOERLI_PRIVATE_KEY: string | undefined = process.env.GOERLI_PRIVATE_KEY;
const ALCHEMY_API_KEY_URL: string | undefined = process.env.ALCHEMY_API_KEY_URL;

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: ALCHEMY_API_KEY_URL,
      accounts: GOERLI_PRIVATE_KEY !== undefined ? [GOERLI_PRIVATE_KEY]: []
    }
  }
};

export default config;