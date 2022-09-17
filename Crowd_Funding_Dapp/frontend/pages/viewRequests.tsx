import React, { useEffect, useState } from 'react'
import Footer from '../components/Footer'
import Navbar from '../components/Navbar'
import RequestCard from '../components/RequestCard'
import { useProvider, useSigner, useContract } from 'wagmi';
import { abi, CONTRACT_ADDRESS } from '../constants';
import { ethers } from 'ethers';

const viewRequests = () => {

  const [requestsArray, setRequestsArray] = useState<[]>([])
  const [target, setTarget] = useState<number>();
  const [deadline, setDeadline] = useState<number>();
  const [raisedAmount, setRaisedAmount] = useState<number>();
  
  const provider = useProvider();
    const { data: signer } = useSigner();
    const contract = useContract({
        addressOrName: CONTRACT_ADDRESS,
        contractInterface: abi,
        signerOrProvider: signer || provider
    });

    const fetchTarget = async (): Promise<void> => {
      try {
        const _target: number = await contract.target();
        // console.log("_target,", _target.toString());
        const targetAfterConversion: string = _target.toString();
        const ethValue: string = ethers.utils.formatEther(targetAfterConversion);
        // console.log("ethValue", ethValue)
        setTarget(ethValue.toString());
      } catch (err: any) {
        console.error(err)
        alert(err.reason)
      }
    }

    const fetchAmountRaised = async (): Promise<void> => {
      try {
        const _raisedAmount: number = await contract.raisedAmount();
        const _amountAfterConversion: string = _raisedAmount.toString();
        const ethValue: string = ethers.utils.formatEther(_amountAfterConversion);
        // console.log("ethValue inside raised Amount", ethValue);
        setRaisedAmount(ethValue.toString());
      } catch (err: any) {
        console.error(err);
        alert(err.reason);
      }
    }

    const fetchDeadline = async (): Promise<void> => {
      try {
        const _deadline: number = await contract.deadline();
        const _timeAfterConversion: number = _deadline.toNumber();
        const timestamp = await _timeAfterConversion *  1000;
        let _date: Date = new Date(timestamp);
        const data = {
          Date: _date.toLocaleString()
        }
        setDeadline(data.Date);
        console.log(data)
      } catch (err: any) {
        console.error(err);
        alert(err.reason);
      }
    }





    const fetchReqs = async (_val: number): Promise <void> => {
      try {
        const req = await contract.request(_val);
        await req;
        return req;
      } catch (err: any) {
        console.log(err);
        alert(err.reason);
      }
    }

    const fetchRequests = async (): Promise <void> => {
      try {
        const amountOfRequests: number = await contract.numOfRequests();
        // console.log(amountOfRequests.toString())
        const promises: [] = [];
        for(let i: number = 0; i < amountOfRequests; i++) {
          const promisedReq = await fetchReqs(i);
          promises.push(promisedReq);
        }
        const requests = await Promise.all(promises);
        console.log(requests);
        setRequestsArray(requests);
      } 
      catch (err: any) {
        console.error(err);
        alert(err.reason);  
      }
    }

    const renderRequests: JSX.Element[] = requestsArray.map((request, idx) => {
      return <RequestCard key={idx} request={request} idx={idx} />
    })
    
    useEffect(() => {
      fetchRequests();
      fetchTarget();
      fetchAmountRaised();
      fetchDeadline()
    }, [])

    useEffect(() => {
      fetchAmountRaised()
    }, [raisedAmount])

  return (
    <div>
        <Navbar />
        <div className='text-[#112B3C] text-center text-2xl pt-10 pb-4'>
          <p>Target: {target } Eth</p>
          <p>Raised Amount: {raisedAmount} Eth</p>
          <p className='border-b-2 '>Deadline: {deadline}</p>
        </div>
        <div className='py-10 flex justify-around flex-wrap gap-y-20 gap-x-14'>
        {renderRequests}
        </div>
        <Footer />
    </div>
  )
}

export default viewRequests
// flex justify-around flex-wrap gap-y-20 gap-x-14
// px-10 grid grid-cols-3 gap-x-14 gap-y-20