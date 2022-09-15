import React, { useEffect, useState } from 'react'
import Footer from '../components/Footer'
import Navbar from '../components/Navbar'
import RequestCard from '../components/RequestCard'
import { useProvider, useSigner, useContract } from 'wagmi';
import { abi, CONTRACT_ADDRESS } from '../constants';

const viewRequests = () => {

  const [requestsArray, setRequestsArray] = useState<[]>([])
  
  const provider = useProvider();
    const { data: signer } = useSigner();
    const contract = useContract({
        addressOrName: CONTRACT_ADDRESS,
        contractInterface: abi,
        signerOrProvider: signer || provider
    });

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
        console.log(amountOfRequests.toString())
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
      fetchRequests()
    }, [])

  return (
    <div className=''>
        <Navbar />
        <div className='text-[#112B3C] text-center text-2xl pt-10 pb-4'>
          <p>Target: 3 Eth</p>
          <p className='border-b-2 '>Deadline: 3 Hours</p>
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