import React from 'react';
import CardImage from '../public/cardimg.png';
import Image from 'next/image';

const EmployeeCard = (props: any) => {
  const {employee, idx} = props
  
  return (
    <div className='bg-gradient-to-r from-[#212B3C] to-[#112B3C] rounded-2xl max-w-xs max-h-2xl px-7 text-white pb-7'>
        <div className='flex items-center justify-start py-5'>
            <p className='text-lg'>{employee.name}</p>
        </div>
        <div className='inline'>
        <p>Recipient Address</p>
        <p className='text-xs inline-block'>{employee.employeeAddress}</p>
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