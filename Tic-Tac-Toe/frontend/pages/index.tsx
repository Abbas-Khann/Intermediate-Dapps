import Head from 'next/head';
import Image from 'next/image';
import { Inter } from '@next/font/google';
import logo from "../public/logo.png";

const inter = Inter({ subsets: ['latin'] })

export default function Home(): JSX.Element {
  return (
      <div className='bg-[#213745]'>
        {/* Logo and header here */}
        <div className='flex justify-center py-10'>
          <Image src={ logo } alt={ '' } width={370} />
        </div>
        <div>
          <h1 className=''>Bet Amount</h1>
        </div>
  
      </div>
  )
}
