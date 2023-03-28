import { Web3Button } from "@thirdweb-dev/react";
import Image from "next/image";

const Welcome: React.FC = () => {
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
          height={320}
          alt="Cat Attack"
        />
      </div>
      <div className="max-w-xs">
        <Web3Button
        contractAddress="0xbC044bc063F4F88e9d52D833c200aE05Ea65FAF9"
        action={(contract) => contract.erc721.claim(1)}
        >
          Claim NFT
        </Web3Button>
      </div>
    </div>
  );
};

export default Welcome;
