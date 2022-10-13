import type { NextPage } from 'next'
import Navbar from '../components/Navbar'
import { useState } from 'react';
import Hero from '../components/Hero';

const Home: NextPage = () => {

  const [darkMode, setDarkMode] = useState<boolean>(false);
  const toggleDarkMode = (): void => {
    setDarkMode(!darkMode);
  }
  return (
    <div>
      <Navbar darkMode={darkMode} toggleDarkMode={toggleDarkMode} />
      <Hero darkMode={darkMode} toggleDarkMode={toggleDarkMode} />
    </div>
  )
}

export default Home
