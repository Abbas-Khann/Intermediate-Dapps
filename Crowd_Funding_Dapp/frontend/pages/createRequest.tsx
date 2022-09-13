import React from 'react'
import Footer from '../components/Footer'
import Navbar from '../components/Navbar'
import RequestData from '../components/RequestData'

const createRequest = () => {
  return (
    <div className=''>
        <Navbar />
        <div className='py-44 sm:py-40 md:py-44 lg:py-36'>
        <RequestData />
        </div>
        <Footer />
    </div>
  )
}

export default createRequest