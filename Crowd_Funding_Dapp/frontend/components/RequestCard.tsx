import React from 'react'
import Image from 'next/image'
import CardImage from '../public/cardImg.png';
import { useProvider, useSigner, useContract } from 'wagmi';
import { abi, CONTRACT_ADDRESS } from '../constants';
import { ethers } from 'ethers';

const RequestCard = (props: any) => {

    const {request, idx} = props

    const provider = useProvider();
    const { data: signer } = useSigner();
    const contract = useContract({
        addressOrName: CONTRACT_ADDRESS,
        contractInterface: abi,
        signerOrProvider: signer || provider
    });

    const voteOnRequest = async (index: number): Promise <void> => {
        try {
            const txn = await contract.voteRequests(index);
            await txn.wait();    
        } 
        catch (err: any) {
            console.error(err);
            alert(err.reason);
        }
    }

    const refund = async (): Promise<void> => {
        try {
            const txn = await contract.refund();
            await txn.wait();
        } 
        catch (err: any) {
            console.error(err);
            alert(err.reason);
        }
    }

    const sendEtherToRequest = async (): Promise<void> => {
        try {
           const _amount = ethers.utils.parseEther("0.1");
           const txn = await contract.sendEth({ value: _amount });
           await txn.wait();    
        } 
        catch (err: any) {
            console.error(err);
            alert(err.reason);
        }
    }

    const payRequest = async (reqNumber: number): Promise <void> => {
        try {
            const txn = await contract.makePayment(reqNumber);
            await txn.wait();
        } 
        catch (err: any) {
            console.error(err);
            alert(err.reason);    
        }
    }


  return (
    <div className='bg-gradient-to-r from-[#212B3C] to-[#112B3C] rounded-2xl max-w-xs max-h-2xl px-7 text-white pb-7'>
        <div className='flex items-center justify-between py-5'>
            <p className='text-lg'>{request.description}</p>
            <button className='bg-[#212B3C] border-2 border-white rounded-2xl text-lg px-3 py-0.5'
            onClick={() => voteOnRequest(idx)}
            >Vote</button>
        </div>
        <div className='inline'>
        <p>Recipient Address</p>
        <p className='text-xs inline-block'>{request.recipient}</p>
        </div>
        <div className='flex items-center'>
            <Image src={CardImage} height={270} width={290} alt="Card-Image" />
        </div>
        <div className='flex items-center justify-around py-4'>
            <button className='bg-[#212B3C] border-2 border-white rounded-2xl text-lg px-3 py-0.5'
            onClick={() => sendEtherToRequest()}
            >Send Eth</button>
            <button className='bg-[#212B3C] border-2 border-white rounded-2xl text-lg px-3 py-0.5'
            onClick={() => refund()}
            >Refund</button>
        </div>
        <div className='flex justify-center pt-2'>
            <button className='bg-[#212B3C] border-2 border-white rounded-2xl text-lg px-10 py-0.5'
            onClick={() => payRequest(idx)}
            >Make Payment</button>
        </div>
    </div>
  )
}

export default RequestCard