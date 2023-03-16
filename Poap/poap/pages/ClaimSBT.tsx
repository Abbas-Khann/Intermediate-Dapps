import React from "react";
import Header from "../components/Header";
import {
  ThirdwebNftMedia,
  useContract,
  useNFTs,
  Web3Button,
} from "@thirdweb-dev/react";
import { contractAddress } from "../constants/constants";

const ClaimSBT = () => {
  const { contract, isLoading } = useContract(contractAddress);
  const { data: nfts } = useNFTs(contract);
  console.log(nfts);

  if (isLoading) {
    return <div>Loading...</div>;
  }

  return (
    <div>
      <Header />
      {nfts && nfts.length > 0 ? (
        <div>
          {nfts.map((nft) => {
            return (
              <div>
                <ThirdwebNftMedia metadata={nft.metadata} />
                <Web3Button
                  contractAddress={contractAddress}
                  action={(contract) =>
                    contract.erc1155.claim(nft.metadata.id, 1)
                  }
                >
                  Claim
                </Web3Button>
              </div>
            );
          })}
        </div>
      ) : (
        <div>No NFTs</div>
      )}
    </div>
  );
};

export default ClaimSBT;
