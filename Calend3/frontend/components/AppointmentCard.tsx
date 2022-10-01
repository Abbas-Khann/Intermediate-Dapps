import { ethers, utils } from "ethers";
import React, { useEffect, useState } from "react";
import { useContract, useProvider, useSigner } from "wagmi";
import { CONTRACT_ABI, CONTRACT_ADDRESS } from "../constants";

const AppointmentCard = (props: any) => {
  const { title, attendee, startingTime, endingTime, amountPaid, idx } = props

  const [appointmentStartingTime, setAppointmentStartingTime] = useState<string | undefined>();
  const [appointmentEndingTime, setAppointmentEndingTime] = useState<string | undefined>();
  const [paidAmount, setPaidAmount] = useState<string | undefined>();

  const provider = useProvider();
  const {data: signer} = useSigner();
  const contract = useContract({
    addressOrName: CONTRACT_ADDRESS,
    contractInterface: CONTRACT_ABI,
    signerOrProvider: signer || provider
  });

  const getAccurateStartingTime = async (): Promise<void> => {
    try {
      const _startingTime: number = await startingTime.toNumber();
      // console.log("starting time: ", _startingTime);
      const _timestamp: number = _startingTime;
      const _time: Date = new Date(_timestamp);
      // console.log(_time.toLocaleString());
      const convertedTime: string = _time.toLocaleString();
      setAppointmentStartingTime(convertedTime)
    } catch (err: any) {
      console.error(err);
      alert(err.reason);
    }
  }

  const getAccurateEndingTime = async (): Promise<void> => {
    try {
      const _endingTime: number = await endingTime.toNumber();
      // console.log(_endingTime, "ET")
      const _timestamp: number = _endingTime;
      const _date: Date = new Date(_timestamp);
      const convertedEndingTime: string = _date.toLocaleString();
      setAppointmentEndingTime(convertedEndingTime);
    } 
    catch (err:any) {
      console.error(err);
      alert(err.reason);
    }
  }

  const fetchAccurateAmountPaid = async (): Promise<void> => {
    try {
      const _amountPaid: string = await amountPaid.toString();
      const _value: string = ethers.utils.formatEther(_amountPaid);
      setPaidAmount(_value);
    } 
    catch (err: any) {
      console.error(err);
      alert(err.reason);  
    }
  }

  const withdrawMoney = async (id: number): Promise<void> => {
    try {
      const txn: any = await contract.withdraw(id);
      await txn.wait();
    } 
    catch (err: any) {
      console.error(err);
      alert(err.reason);  
    }
  }

  const cancelAppointment = async (id: number): Promise<void> => {
    try {
      const txn: any = await contract.cancelAppointment(id);
      await txn.wait();
    } 
    catch (err: any) {
       console.error(err)
       alert(err.reason)  
    }
  }

  const appointmentCompleted = async (id: number): Promise<void> => {
    try {
      const txn: any = await contract.appointmentCompleted(id);
      await txn.wait();
    } 
    catch (err: any) {
      console.error(err);
      alert(err.reason);  
    }
  }

  useEffect(() => {
    getAccurateStartingTime();
    getAccurateEndingTime();
    fetchAccurateAmountPaid();
  }, [])

  return (
    <div className="text-black w-10/12 sm:w-8/12 md:w-7/12 lg:w-5/12 px-10 py-4 bg-gradient-to-b from-violet-400 to-fuchsia-400 rounded-md mt-20">
      <div className="flex justify-between items-center pt-1 pb-4">
        <h3 className="border-l-4 border-black mb-2 p-1 md:text-xl text-white">
          {title}
        </h3>
        <button className="px-3 py-1 border-2 rounded-md hover:bg-indigo-500 hover:transition-all hover:duration-500 hover:text-white"
        onClick={() => withdrawMoney(idx)}
        >
          Withdraw
        </button>
      </div>
      <div className="flex flex-col sm:px-12 px-2 py-5 bg-[#1C0238] text-white rounded-md ">
        <div className="flex justify-center mb-3">
          <h4 className="border-l-2 border-pink-400 mb-2 p-1">Address:</h4>
          <h4 className="mt-1 break-all sm:pl-8">
            {attendee}
          </h4>
        </div>
        <div className="flex">
          <h4 className="border-l-2 border-pink-400 mb-2 p-1">
            Starting Time:
          </h4>
          <h4 className="pl-2 mt-1">{appointmentStartingTime}</h4>
        </div>
        <div className="flex">
          <h4 className="border-l-2 border-pink-400 mb-2 p-1">Ending Time:</h4>
          <h4 className="pl-4 mt-1">{appointmentEndingTime}</h4>
        </div>
        <div className="flex">
          <h4 className="border-l-2 border-pink-400 mb-2 p-1">Cost:</h4>
          <h4 className="pl-16 mt-1">&nbsp; &nbsp; {paidAmount} Ether</h4>
        </div>
      </div>
      <div className="flex justify-between pt-4">
        <button className="px-3 py-1 border-2 rounded-md hover:bg-indigo-500 hover:transition-all hover:duration-500 hover:text-white"
        onClick={() => cancelAppointment(idx)}
        >
          Cancel
        </button>
        <button className="px-3 py-1 border-2 rounded-md hover:bg-indigo-500 hover:transition-all hover:duration-500 hover:text-white"
        onClick={() => appointmentCompleted(idx)}
        >
          Appointment Completed
        </button>
      </div>
    </div>
  );
};

export default AppointmentCard;