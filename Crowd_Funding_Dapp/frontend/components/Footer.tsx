import Link from 'next/link';
import React from 'react';
import { BsTwitter } from 'react-icons/bs';
import { BsLinkedin } from 'react-icons/bs';
import { BsGithub } from 'react-icons/bs';

const Footer = () => {
  return (
    <footer className='bg-gradient-to-r from-[#212b3c] to-[#112B3C] text-[#FCF8E8] px-10 py-6'>
        <div className='flex justify-between items-center'>
            <div>
                <span>Created by </span>
                <Link href="https://github.com/Abbas-Khann">
                <a target="_blank">Abbas Khan</a> 
                </Link>
                <span>| All Rights Reserved</span>
            </div>
            <div className='flex items-center justify-between w-52'>
                <div className='border-2 border-[#FCF8E8] rounded-full p-2'>
                <Link href="https://www.linkedin.com/in/abbas-khan-033802222">
                <a target="_blank">
                <BsLinkedin className='text-2xl hover:animate-pulse active:animate-ping' />
                </a>
                </Link>
                </div>
                <div className='border-2 border-[#FCF8E8] rounded-full p-2'>
                <Link href="https://github.com/Abbas-Khann">
                <a target="_blank">
                <BsGithub className='text-2xl hover:animate-pulse active:animate-ping' />
                </a>
                </Link>
                </div>
                <div className='border-2 border-[#FCF8E8] rounded-full p-2'>
                <Link href="https://twitter.com/KhanAbbas201">
                <a target="_blank">
                <BsTwitter className='text-2xl hover:animate-pulse active:animate-ping' />
                </a>
                </Link>
                </div>
            </div>
        </div>
    </footer>
  )
}

export default Footer