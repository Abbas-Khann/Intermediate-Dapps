import React from 'react';
import CardImage from '../public/cardimg.png';
import Image from 'next/image';

const EmployeeCard = () => {
  return (
    <div className='bg-gradient-to-r from-[#212B3C] to-[#112B3C] rounded-2xl max-w-xs max-h-2xl px-7 text-white pb-7'>
        <div className='flex items-center justify-start py-5'>
            <p className='text-lg'>Abbas Khan</p>
        </div>
        <div className='inline'>
        <p>Recipient Address</p>
        <p className='text-xs inline-block'>0x7B4A8d0862F049E35078E49F2561630Fac079eB9</p>
        </div>
        <div className='flex items-center'>
            <Image src={CardImage} height={270} width={290} alt="Card-Image" />
        </div>
        <div className='flex justify-center pt-6'>
            <button className='bg-[#212B3C] border-2 border-white rounded-2xl text-lg px-10 py-0.5'
            >Make Payment</button>
        </div>
    </div>
  )
}

export default EmployeeCard