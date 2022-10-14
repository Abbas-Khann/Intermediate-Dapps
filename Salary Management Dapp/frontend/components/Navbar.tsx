import React from 'react';
import Head from 'next/head';
import { BsLightbulbFill } from 'react-icons/bs';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import { useGlobalContext } from '../Context/Context';
import Link from 'next/link';

const Navbar = (): JSX.Element => {
   const {toggleDarkMode, darkMode} = useGlobalContext(); 

  return (
    <div className={`${darkMode && 'dark'} bg-gradient-to-r from-[#b7c3d3] to-[whitesmoke]`}>
      <Head>
             <style>
                {/* eslint-disable-next-line react/no-unescaped-entities */}
               @import url('https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@600&display=swap');
             </style>
        </Head>
        <nav className="flex items-center justify-center px-6 py-4 dark:bg-gradient-to-r from-[#212b3c] to-[#112B3C] dark:text-white shadow-2xl dark:shadow-lg dark:shadow-blue-500/50">
        <Link href="/">
        <h1 className='text-xl sm:text-3xl cursor-pointer'>Salary Management</h1>
        </Link>
        <div className='flex flex-auto justify-end items-center px-4'>
        {darkMode ? 
        <BsLightbulbFill
        onClick={toggleDarkMode} 
        className='text-3xl cursor-pointer mr-4 text-yellow-400'
        />
        :
        <BsLightbulbFill
        onClick={toggleDarkMode}
        className='text-3xl cursor-pointer mr-4'/>
    }
        <ConnectButton />
        </div>
    </nav>
    </div>
  )
}

export default Navbar