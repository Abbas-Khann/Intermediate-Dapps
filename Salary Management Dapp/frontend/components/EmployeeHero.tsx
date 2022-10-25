import React from 'react';
import Sidebar from './Sidebar';
import { useGlobalContext } from '../Context/Context';
import EmployeeCard from './EmployeeCard';
import { useProvider, useSigner, useContract } from 'wagmi';

const Hero = () => {
    const {darkMode} = useGlobalContext();
    

  return (
    <main className={`${darkMode && "dark"} bg-gradient-to-r from-[#6FB2D2] to-[#D8D2CB]`}> 
        <Sidebar />
    <section className='dark:bg-gradient-to-r from-[#121212] to-[#002B5B] dark:text-white min-h-screen'>
      <div className='flex justify-center'>
        <h3 className='text-2xl pt-12 inline-block text-black border-b-4 border-[#7084a0] sm:text-5xl font-bold 
            dark:bg-gradient-to-r dark:bg-clip-text dark:text-transparent 
            dark:from-red-400 dark:via-purple-500 dark:to-green-400
            dark:animate-text
        
        '>Employees List</h3>
      </div>
      <div className='flex justify-around flex-wrap gap-x-5 gap-y-14 w-8/12 mr-52 ml-auto pt-10'>

      </div>
    </section>
    </main>
  )
}

export default Hero