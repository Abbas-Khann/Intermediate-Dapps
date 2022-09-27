import React from 'react';
import Link from 'next/link';

const Hero = () => {
  return (
    <div className={`w-screen h-screen no-repeat bg-cover flex items-center flex-col bg-[url('/home.png')] bg-gray-600`}>
        <h1 className='text-2xl sm:text-3xl md:text-4xl lg:text-5xl mt-44 text-white'>Calend3</h1>
        <h3 className='text-2xl sm:text-2xl md:text-3xl text-center py-10 text-white'>Start creating your appointment <br /> now</h3>
        <Link href="/createAppointment">
        <button className='bg-transparent px-5 py-1.5 border-4 border-purple-500 rounded-lg text-xl text-white hover:bg-[#31087B] hover:transition-all hover:duration-500'>Create appointment</button>
        </Link>
    </div>
  )
}

export default Hero