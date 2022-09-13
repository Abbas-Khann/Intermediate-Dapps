import type { NextPage } from 'next';
import Head from 'next/head'
import Image from 'next/image'
import Footer from '../components/Footer';
import Hero from '../components/Hero';
import Navbar from '../components/Navbar';

const Home: NextPage = () => {
  return (
    <main>
        <Navbar />
        <Hero />
        <Footer />
    </main>
  )
}

export default Home
