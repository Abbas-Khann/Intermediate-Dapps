import React, { useState } from 'react'
import Head from 'next/head';
import { BsLightbulbFill } from 'react-icons/bs';
import { ConnectButton } from '@rainbow-me/rainbowkit';

const Navbar = () => {

  return (
    <div className="bg-gradient-to-r from-[#b7c3d3] to-[whitesmoke]">
        <nav className="flex items-center justify-evenly sm:justify-center px-8 bg-gradient-to-r from-[#212b3c] to-[#112B3C] shadow-2xl py-5">
        <h1 className='text-xl sm:text-3xl text-[#FCF8E8]'>Crowd Funding</h1>
        <div className='flex flex-auto justify-center items-center px-4 text-white text-sm sm:text-lg'>
        <button className='hover:border-b-2 border-blue-300'>View Requests</button>
        <button className='ml-20 hover:border-b-2 border-blue-300'>Create Request</button>
        </div>
        <ConnectButton />
    </nav>
    </div>
  )
}

export default Navbar