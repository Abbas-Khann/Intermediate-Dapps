import React, { useState } from 'react'
import Footer from '../components/Footer'
import Navbar from '../components/Navbar'

const CreateAppointment = (): JSX.Element => {
  const [inputData, setInputData] = useState<object>({
    title: "",
    startingTime: 0
  });

  console.log(inputData)

  const takeValues = (event: any): void => {
    setInputData((prevState) => {
      return {
        ...prevState,
        [event.target.name]: event.target.value
      }
    })
  }

  return (
    <div className=' bg-[#1C0238]'>
        <Navbar />
        <div className='h-[78vh] flex flex-col items-center'>
        <h1 className='text-2xl sm:text-3xl md:text-4xl mt-24 text-white border-b-4 border-indigo-500 pb-2'>Create Appointment</h1>
        <input 
        className='sm:px-12 border-4 border-[#A460ED] rounded-lg py-2 my-10 text-2xl bg-transparent text-white'
        placeholder='Enter Appointment title'
        onChange={takeValues}
        name="title"
        />
        <div className='flex flex-col'>
        <h3 className='text-white pb-4 text-2xl py-1'>Enter the Starting time</h3>
        <input 
        type="datetime-local"
        className='sm:px-9 px-2 rounded-lg bg-gradient-to-l from-purple-500 to-indigo-500 text-white text-xl sm:text-2xl'
        onChange={takeValues}
        name="startingTime"
        />
        <div className='flex justify-center'>
        <button
        className='border-2 border-[#A460ED] text-white mt-8 text-xl py-2.5 rounded-lg w-32 hover:bg-indigo-500 hover:transition-all hover:duration-500'
        >Create</button>
        </div>
        </div>
    </div>
    <Footer />
    </div>
  )
}

export default CreateAppointment