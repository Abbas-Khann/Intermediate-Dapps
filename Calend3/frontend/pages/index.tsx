import type { NextPage } from 'next'
import Hero from '../components/Hero'
import Navbar from '../components/Navbar'

const Home: NextPage = () => {
  return (
    <main>
      <Navbar />
      <Hero />
    </main>
  )
}

export default Home
