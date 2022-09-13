import React from 'react'

const RequestData = () => {
  return (
    <div className='bg-gradient-to-b from-[#212B3C] to-[#112B3CE5] w-80 text-white flex flex-col mx-auto rounded-3xl pt-8 pb-10 px-10 '>
        <p>Recipient Address</p>
        <input 
        className='bg-gradient-to-b from-[#212B3C] to-[#112B3CE5] border-2 border-white rounded-xl px-3 my-3 py-1'
        />
        <p>Value</p>
        <input 
        className='bg-gradient-to-b from-[#212B3C] to-[#112B3CE5] border-2 border-white rounded-xl px-3 mb-2 mt-1 py-1'
        type="number"
        />
        <p>Description</p>
        <textarea 
        className='bg-gradient-to-b from-[#212B3C] to-[#112B3CE5] border-2 border-white rounded-xl h-32 px-3 mt-1'
        />
    </div>
  )
}

export default RequestData