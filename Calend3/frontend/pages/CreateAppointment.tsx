import React from 'react'
import Navbar from '../components/Navbar'

const CreateAppointment = () => {
  return (
    <div className='min-h-screen bg-[#1C0238]'>
        <Navbar />
        <div className='flex flex-col items-center'>
        <h1 className='text-2xl sm:text-3xl md:text-4xl mt-24 text-white border-b-4 border-indigo-500 pb-2'>Create Appointment</h1>
        <input 
        className='sm:px-16 border-4 border-[#A460ED] rounded-lg py-2 my-10 text-2xl bg-transparent text-white'
        placeholder='Enter Appointment title'
        />
        <input 
        className=''
        />
    </div>
    </div>
  )
}

export default CreateAppointment