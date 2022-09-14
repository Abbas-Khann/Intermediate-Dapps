import React from 'react'
import Footer from '../components/Footer'
import Navbar from '../components/Navbar'
import RequestCard from '../components/RequestCard'

const viewRequests = () => {
  return (
    <div className=''>
        <Navbar />
        <div className='py-10 flex justify-around flex-wrap gap-y-20 gap-x-14'>
        <RequestCard />
        <RequestCard />
        <RequestCard />
        <RequestCard />
        </div>
        <Footer />
    </div>
  )
}

export default viewRequests