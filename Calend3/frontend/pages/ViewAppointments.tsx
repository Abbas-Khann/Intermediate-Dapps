import React, { useEffect, useState } from 'react'
import AppointmentCard from '../components/AppointmentCard'
import Footer from '../components/Footer'
import Navbar from '../components/Navbar'
import { useContract, useProvider, useSigner } from 'wagmi'
import { CONTRACT_ABI, CONTRACT_ADDRESS } from '../constants'

const ViewAppointments = (): JSX.Element => {

  const [appointmentsArray, setAppointmentsArray] = useState<any[]>([]);


  const provider = useProvider();
  const {data: signer} = useSigner();
  const contract = useContract({
    addressOrName: CONTRACT_ADDRESS,
    contractInterface: CONTRACT_ABI,
    signerOrProvider: signer || provider
  });

  const fetchMapping = async (mapNum: number): Promise<number | undefined> => {
    try { 
      const _appointmentId: number = await contract.appointments(mapNum);
      // console.log(_appointmentId)
      return _appointmentId;
    } 
    catch (err: any) {
      console.log(err);
      alert(err.reason);
    }
  }

  const fetchAllAppointments = async (): Promise<void> => {
    try {
      const _amountOfAppointments: number = await contract.appointmentId();
      const mappingsArray: any[] = [];
      for(let i: number = 0; i < _amountOfAppointments; i++) {
        const mappings = await fetchMapping(i);
        mappingsArray.push(mappings);
      }
      const appointments: any[] = await Promise.all(mappingsArray);
      console.log(appointments)
      setAppointmentsArray(appointments);
    } 
    catch (err: any) {
      console.error(err);
      alert(err.reason);
    }
  }

  const getAppointmentCard = appointmentsArray.map((app, idx) => {
    return (
      <AppointmentCard key={idx} {...app} idx={idx} />
    )
  })

  useEffect(() => {
    fetchAllAppointments()
  }, [])

  return (
    <div className='min-h-screen bg-[#1C0238]'>
        <Navbar />
        <div className='flex justify-around flex-wrap gap-y-10 gap-x-10'>
        {getAppointmentCard}
        </div>
        {/* <Footer /> */}
    </div>
  )
}

export default ViewAppointments