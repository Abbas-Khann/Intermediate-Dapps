import React from 'react';
import Link from "next/link";
import Sidebar from './Sidebar';
import { useGlobalContext } from '../Context/Context';
const Hero = () => {
    const {darkMode} = useGlobalContext();

    const renderButton = (): JSX.Element => {
        return(
        <div className='flex flex-col items-center'>
      <p className='text-2xl sm:text-3xl py-4 text-center'>Manage your company with SMD</p>
      <Link href='/'>
      <button className='px-4 py-2 my-1 border-2 transition duration-300 motion-safe:animate-bounce ease-out hover:ease-in hover:bg-gradient-to-r from-[#5463FF] to-[#89CFFD] text-3xl rounded hover:text-white mb-3 sm:w-72'
      >Add Employee</button>
      </Link>
      </div>
        )
    }

  return (
    <main className={`${darkMode && "dark"} bg-gradient-to-r from-[#6FB2D2] to-[#D8D2CB]`}> 
        <Sidebar />
    <section className='dark:bg-gradient-to-r from-[#121212] to-[#002B5B] dark:text-white h-[92vh]'>
      <div className='flex justify-center'>
        <h3 className='text-2xl pt-12 inline-block text-black border-b-4 border-[#7084a0] sm:text-5xl font-bold 
            dark:bg-gradient-to-r dark:bg-clip-text dark:text-transparent 
            dark:from-red-400 dark:via-purple-500 dark:to-green-400
            dark:animate-text
        
        '>Pay your employees in Crypto with SMD</h3>
      </div>
      <div className='sm:flex sm:items-center sm:justify-center py-16 px-20'>
      <div className=''>
          {renderButton()}
      </div>
      <div className='mt-5 sm:ml-28'>
      {darkMode ? <img src="https://img.icons8.com/external-flaticons-lineal-color-flat-icons/184/000000/external-salary-job-search-flaticons-lineal-color-flat-icons.png"/> : 
      <img src="https://img.icons8.com/external-becris-lineal-becris/184/000000/external-salary-customer-loyalty-program-becris-lineal-becris.png"/>
      }
      </div>
      </div>
    </section>
    </main>
  )
}

export default Hero