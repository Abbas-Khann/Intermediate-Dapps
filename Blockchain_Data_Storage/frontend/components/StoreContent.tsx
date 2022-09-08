import { Web3Storage } from "web3.storage";
import { WEB3STORAGE_TOKEN } from "../Constants/Index";

const web3StorageKey: string = WEB3STORAGE_TOKEN;

const getAccess = (): string => {
    return web3StorageKey;
}

const makeStorageClient = () => {
    return new Web3Storage({ token: getAccess() });
}

export const StoreContent = async (files: any): Promise<string> => {
    console.log("Uploading in to IPFS........");
    const client = makeStorageClient();
    const cid: string = await client.put([files]);
    return cid;
};

