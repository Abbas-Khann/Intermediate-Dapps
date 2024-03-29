import { utils } from "ethers";
import React from "react";
import { useCreateSBTStore } from "../stores/CreateSBTStore";
import { useContract, useContractRead, useLazyMint, useSetClaimConditions, useStorageUpload } from "@thirdweb-dev/react";
import { contractAddress } from "../constants/constants";
import { NATIVE_TOKEN_ADDRESS } from "@thirdweb-dev/sdk";

const CreateSBTForm = (): JSX.Element => {
  const createForm = useCreateSBTStore();
  const { contract } = useContract(contractAddress);
  const { data: nextTokenToMint } = useContractRead(contract, "nextTokenIdToMint");
  const tokenId = nextTokenToMint?.toNumber();
  const { mutateAsync: lazyMint, isLoading, error } = useLazyMint(contract);
  const { mutateAsync: setClaimCondition } = useSetClaimConditions(contract, tokenId);
  const { mutateAsync: upload } = useStorageUpload();
  const handleLazyMint = async () => {
    await lazyMint({
      metadatas: [
        {
          name: createForm.name,
          description: createForm.description,
          image: createForm.image
        }
      ]
    });
    const snapshotData = [];
    for(let i = 1; i < createForm.addresses.length; i++) {
      snapshotData.push({
        address: createForm.addresses[i],
        maxClaimable: 1,
      })
    }
    await setClaimCondition({
      phases: [
        {
          metadata: {
            name: "Phase",
          },
          currencyAddress: NATIVE_TOKEN_ADDRESS,
          price: 0,
          maxClaimablePerWallet: createForm.amount,
          maxClaimableSupply: createForm.maxClaimable,
          startTime: createForm.startingDate,
          waitInSeconds: 60 * 60 * 24 * 7,
          snapshot: snapshotData
        }
      ]
    })
  }
  
  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    if (!e.target.files || !e.target.files[0]) {
      throw new Error("Upload Image first!!!");
    }

    const file = e.target.files![0];
    const fileSize = 2 * 1024 * 1024;

    if (file.size > fileSize) {
      throw new Error("File should be less than 2 MB's");
    }

    createForm.setImageFile(file);
    const uploadUrl = await upload({
      data: [file],
      options: { uploadWithGatewayUrl: true, uploadWithoutDirectory: true }
    })
    createForm.setImage(uploadUrl[0]);
  };

  // processCSV
  const processCSV = (str: string, delim = ",") => {
    createForm.removeAddresses();
    console.log(createForm.addresses)
    let rows = str.split("\n");
    console.log(rows)
    if(rows[0] != "address") {
        throw new Error("Add address to the top of the csv");
    }
    
    rows.map((row) => {
      row = row.replace("/r", "");
      if(!utils.isAddress(row) && row != "address") {
        createForm.removeAddresses();
        throw new Error("Incorrect Address: "+ row);
      }
      else {
        createForm.addAddress(row);
      }
    });
  }

  const handleCSVUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    if(!e.target.files || !e.target.files[0]) {
      throw new Error('No files uploaded');
    }

    const file = e.target.files![0];
    const fileSize = 2 * 1024 * 1024;
    console.log(fileSize)
    if(file.size > fileSize) {
      throw new Error("File size shouldn't exceed 2 MB's");
    }
    console.log("file.size", file.size)
    const csvFile = file;
    const reader = new FileReader();

    reader.onload = (e) => {
      const text = e.target?.result;
      processCSV(text as string);
    }
    reader.readAsText(csvFile);
    e.target.value = "";
  }

  return (
    <div>
      <div className="flex items-center justify-center flex-col">
        <h1>Create SBT</h1>
        <p>
          Fill in all the information below to create a claimable SBT for your
          community
        </p>
      </div>
      {/* Form starts here */}
      <div className="">
        <h2>Name</h2>
        <input
          onChange={(e) => createForm.setName(e.target.value)}
          type="text"
          placeholder=""
          className="input input-bordered input-sm text-lg rounded-lg w-full max-w-xs"
        />
        <h2>Description</h2>
        <textarea
          onChange={(e) => createForm.setDescription(e.target.value)}
          placeholder=""
          className="textarea textarea-bordered textarea-xs w-full text-lg rounded-2xl max-w-xs"
        />
        <h2>Amount</h2>
        <input
          onChange={(e) => createForm.setAmount(parseInt(e.target.value))}
          type="number"
          placeholder=""
          className="input input-bordered input-sm text-lg rounded-lg w-full max-w-xs"
        />
        <h2>Max Claimable Amount</h2>
        <input
          onChange={(e) => createForm.setMaxClaimable(parseInt(e.target.value))}
          type="text"
          placeholder=""
          className="input input-bordered input-sm text-lg rounded-lg w-full max-w-xs"
        />
        <h2>Starting Date</h2>
        <input
          onChange={(e) => {
            const dateValue = e.target.valueAsDate;
            if (dateValue !== null) {
              createForm.setStartingDate(dateValue);
            }
          }}
          type="date"
          className="file-input file-input-bordered w-full max-w-xs"
        />
        {/* Image file here */}
        <input
          onChange={handleImageUpload}
          type="file"
          className="file-input file-input-bordered w-full max-w-xs"
        />
        <div className="flex">
          <label
            htmlFor="csvUpload"
            className="flex h-20 w-96 cursor-pointer items-center justify-center rounded-lg bg-[#121212] text-center text-[#020B1A] hover:opacity-70"
          >
            <div className="text-center text-white">
              Upload CSV with Addresses
            </div>
          </label>
          {/* CSV Addresses here */}
          <input
            id="csvUpload"
            name="csvUpload"
            className="hidden"
            type="file"
            accept="text/csv"
            onChange={(e) => {
              e.preventDefault();
              handleCSVUpload(e)
            }}
          />
          <button
          onClick={handleLazyMint}
          >Submit</button>
        </div>
      </div>
    </div>
  );
};

export default CreateSBTForm;
