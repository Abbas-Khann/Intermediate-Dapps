import type { NextPage } from 'next'
import Head from 'next/head'
import Image from 'next/image'
import Link from 'next/link'

const Home: NextPage = () => {
  return (
    <main>
          <Link href="/Storage3">
            <button>
              Storage Dapp
            </button>
          </Link>
    </main>
  )
}

export default Home
