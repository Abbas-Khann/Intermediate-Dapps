import { ConnectButton } from '@rainbow-me/rainbowkit';
import Link from 'next/link';

const Navbar = () => {

  return (
    <div className="bg-gradient-to-r from-[#b7c3d3] to-[whitesmoke]">
        <nav className="flex items-center justify-evenly sm:justify-center px-8 bg-[#1C0238] shadow-2xl py-5">
        <Link href="/">
        <h1 className='text-xl sm:text-3xl text-[#FCF8E8] cursor-pointer'>Calend3</h1>
        </Link>
        <div className='flex flex-auto justify-center items-center px-4 text-white text-sm sm:text-lg'>
        <Link href="/viewRequests">
        <button className='hover:border-b-2 border-blue-300'>View Appointments</button>
        </Link>
        <Link href="/createRequest">
        <button className='ml-20 hover:border-b-2 border-blue-300'>Create Appointment</button>
        </Link>
        </div>
        <ConnectButton />
    </nav>
    </div>
  )
}

export default Navbar