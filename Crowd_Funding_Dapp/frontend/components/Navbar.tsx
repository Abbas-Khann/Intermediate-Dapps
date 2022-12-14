import { ConnectButton } from '@rainbow-me/rainbowkit';
import Link from 'next/link';

const Navbar = () => {

  return (
    <div className="bg-gradient-to-r from-[#b7c3d3] to-[whitesmoke]">
        <nav className="flex items-center justify-evenly sm:justify-center px-8 bg-gradient-to-r from-[#212b3c] to-[#112B3C] shadow-2xl py-5">
        <Link href="/">
        <h1 className='text-xl sm:text-3xl text-[#FCF8E8] cursor-pointer'>Crowd Funding</h1>
        </Link>
        <div className='flex flex-auto justify-center items-center px-4 text-white text-sm sm:text-lg'>
        <Link href="/viewRequests">
        <button className='hover:border-b-2 border-blue-300'>View Requests</button>
        </Link>
        <Link href="/createRequest">
        <button className='ml-20 hover:border-b-2 border-blue-300'>Create Request</button>
        </Link>
        </div>
        <ConnectButton />
    </nav>
    </div>
  )
}

export default Navbar