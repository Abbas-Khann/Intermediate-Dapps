import React from 'react'

const AppointmentCard = () => {
  return (
    <div className='text-black w-10/12 sm:w-8/12 md:w-7/12 lg:w-5/12 px-10 py-4 bg-gradient-to-b from-violet-400 to-fuchsia-400 rounded-md mt-20'>
        <div className='flex justify-between items-center pt-1 pb-4'>
            <h3 className='md:text-xl text-white'>Crypto meeting</h3>
            <button className='px-3 py-1 border-2 rounded-md '>Withdraw</button>
        </div>
        <div className='flex flex-col px-8 py-5 bg-[#1C0238] text-white rounded-md max-w-lg'>
            <div className='flex '>
            <h4>Address:</h4>
            <h4 className=''>0x7B4A8d0862F049E35078E49F2561630Fac079eB9 <br/></h4>
            </div>
            <div className='flex'>
                <h4>Starting Time:</h4>
                <h4>10:30 pm</h4>
            </div>
            <div className='flex'>
                <h4>Ending Time:</h4>
                <h4>11:00 pm</h4>
            </div>
            <div className='flex'>
                <h4>Cost:</h4>
                <h4>0.1 Ether</h4>
            </div>
        </div>
        <div className='flex justify-between pt-4'>
            <button className='px-3 py-1 border-2 rounded-md '>Cancel</button>
            <button className='px-3 py-1 border-2 rounded-md '>Appointment Completed</button>
            <button className='px-3 py-1 border-2 rounded-md '>Refund</button>
        </div>
    </div>
  )
}

export default AppointmentCard