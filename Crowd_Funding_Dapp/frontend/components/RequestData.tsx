import React, { useState, useRef } from 'react'
import { useSigner, useProvider, useContract } from 'wagmi';
import { abi, CONTRACT_ADDRESS } from '../constants';

const RequestData = () => {

  const provider = useProvider();
  const {data: signer} = useSigner();
  const contract = useContract({
    addressOrName: CONTRACT_ADDRESS,
    contractInterface: abi,
    signerOrProvider: signer || provider
  });

  const inputRef = useRef();

  const [formData, setFormData] = useState<object>({
    description: "",
    value: 0,
    address: ""
  });

  function handleChange(e: any): void {
      setFormData((prevData) => {
        return {
          ...prevData,
          [e.target.name] : e.target.value
        };
      });
  };

  const createRequest = async (value: any): Promise <void> => {
    try{
      if(value.description && value.value && value.address) {
        const txn = await contract.createRequest(
          value.description, 
          +value.value, 
          value.address);
          await txn.wait();
          inputRef.current.value = "";
      }
      else {
        alert("Make sure all the input boxes are filled")
      }
    } 
    catch(err: any){
      console.error(err);
      alert(err.reason);
    }
  }

  console.log(formData)




  return (
    <div className='bg-gradient-to-b from-[#212B3C] to-[#112B3CE5] w-80 text-white flex flex-col mx-auto rounded-3xl pt-8 pb-10 px-10 '>
        <p>Recipient Address</p>
        <input 
        className='bg-gradient-to-b from-[#212B3C] to-[#112B3CE5] border-2 border-white rounded-xl px-3 my-3 py-1'
        onChange={handleChange}
        name="address"
        ref={inputRef}
        />
        <p>Value</p>
        <input 
        className='bg-gradient-to-b from-[#212B3C] to-[#112B3CE5] border-2 border-white rounded-xl px-3 mb-2 mt-1 py-1'
        type="number"
        onChange={handleChange}
        name="value"
        ref={inputRef}
        />
        <p>Description</p>
        <textarea 
        className='bg-gradient-to-b from-[#212B3C] to-[#112B3CE5] border-2 border-white rounded-xl h-32 px-3 mt-1'
        onChange={handleChange}
        name="description"
        ref={inputRef}
        />
        <button className="border-full py-2 px-5 rounded-lg border-2 border-[#b4b0d4] hover:bg-[#112B3CE5] mt-5"
        onClick={() => createRequest(formData)}
        >
        Create Request
        </button>
    </div>
  )
}

export default RequestData