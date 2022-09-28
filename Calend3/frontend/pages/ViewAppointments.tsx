import React from 'react'
import AppointmentCard from '../components/AppointmentCard'
import Navbar from '../components/Navbar'

const ViewAppointments = () => {
  return (
    <div className='min-h-screen bg-[#1C0238]'>
        <Navbar />
        <div className='flex justify-around flex-wrap gap-y-10 gap-x-10'>
        <AppointmentCard />
        <AppointmentCard />
        </div>
    </div>
  )
}

export default ViewAppointments