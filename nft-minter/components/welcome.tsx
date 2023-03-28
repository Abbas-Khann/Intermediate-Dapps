import { Web3Button, useAddress, useContract } from "@thirdweb-dev/react";
import { ethers } from "ethers";
import Image from "next/image";
import { CONTRACT_ADDR } from "../utils/constants";

const Welcome: React.FC = () => {
  const address = useAddress();
  const { contract } = useContract(CONTRACT_ADDR);

  const mintNFT = async () => {
    const isFreeMintAllowed = await contract?.call("allowedFreeMintAddresses", address);
    const getMintPrice = await contract?.call("mintPrice");
    const convertToEther = ethers.utils.formatEther(getMintPrice.toString());
    if(isFreeMintAllowed) {
      await contract?.call("mintNFT", address);
    }
      await contract?.call("mintNFT", address, {
        value: ethers.utils.parseUnits(convertToEther)
      });
  }

  return (
    <div className="flex flex-col items-center w-full space-y-8">
      <h1 className="font-bold sm:text-6xl text-4xl leading-none text-center tracking-tight">
        Welcome to&nbsp;
        <span
          className="!bg-clip-text text-transparent"
          style={{
            background:
              "linear-gradient(73.59deg, #C339AC 42.64%, #CD4CB5 54%, #E173C7 77.46%)",
          }}
        >
        NFT Minter
        </span>
      </h1>
      <div className="mx-auto">
        <Image
          src="/NFT.png"
          width={400}
          height={200}
          alt="Cat Attack"
        />
      </div>
      <div className="max-w-xs">
        <Web3Button
        contractAddress={CONTRACT_ADDR}
        action={mintNFT}
        >
          Claim NFT
        </Web3Button>
      </div>
    </div>
  );
};

export default Welcome;
