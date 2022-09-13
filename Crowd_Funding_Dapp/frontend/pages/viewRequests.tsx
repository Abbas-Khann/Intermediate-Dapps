import React from 'react'
import Navbar from '../components/Navbar'
import RequestCard from '../components/RequestCard'

const viewRequests = () => {
  return (
    <div>
        <Navbar />
        <div className='py-10 flex justify-around'>
        <RequestCard />
        <RequestCard />
        <RequestCard />
        </div>
    </div>
  )
}

export default viewRequests