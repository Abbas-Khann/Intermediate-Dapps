import React from 'react';
import Sidebar from './Sidebar';
import { useGlobalContext } from '../Context/Context';
import { useSigner, useProvider, useContract } from 'wagmi';
import { abi, CONTRACT_ADDRESS } from '../Constants/Index';
import { BigNumber, ContractFactory, ethers } from 'ethers';
const Hero = () => {
    const {darkMode} = useGlobalContext();
    const provider = useProvider();
    const {data: signer} = useSigner();
    const contract = useContract({
      addressOrName: CONTRACT_ADDRESS,
      contractInterface: abi,
      signerOrProvider: signer || provider
    });

    const payInterns = async (): Promise<void> => {
      try {
        const _amount: BigNumber = ethers.utils.parseEther("0.03");
        const txn: any = await contract.payAllInterns({
        value: _amount
        }
        );
        await txn.wait();
      } 
      catch (err: any) {
        console.error(err);  
      }
    }

    const payJuniors = async (): Promise<void> => {
      try {
        const txn: any = await contract.payAllJuniors({
          value: ethers.utils.parseEther("0.02")
      });
        await txn.wait();
        } 
      catch (err: any) {
        console.error(err.reason);  
      }
    }

    const paySeniors = async (): Promise<void> => {
      try {
        const txn: any = await contract.payAllSeniors({
          value: ethers.utils.parseEther("0.03")
      })
      await txn.wait();
      } 
      catch (err: any) {
        console.error(err.reason);  
      }
    }


    const renderInternsButton = (): JSX.Element => {
        return(
        <div className='flex flex-col items-center py-2'>
      <button className='px-4 py-2 my-1 border-2 transition duration-300 motion-safe:animate-bounce ease-out hover:ease-in hover:bg-gradient-to-r from-[#5463FF] to-[#89CFFD] text-3xl rounded hover:text-white mb-3 sm:w-72'
      onClick={payInterns}
      >Pay Interns</button>
      </div>
        )
    }
    const renderJuniorsButton = (): JSX.Element => {
        return(
        <div className='flex flex-col items-center py-2'>
      <button className='px-4 py-2 my-1 border-2 transition duration-300 motion-safe:animate-bounce ease-out hover:ease-in hover:bg-gradient-to-r from-[#5463FF] to-[#89CFFD] text-3xl rounded hover:text-white mb-3 sm:w-72'
      onClick={payJuniors}
      >Pay Juniors</button>
      </div>
        )
    }
    const renderSeniorsButton = (): JSX.Element => {
        return(
        <div className='flex flex-col items-center py-2'>
      <button className='px-4 py-2 my-1 border-2 transition duration-300 motion-safe:animate-bounce ease-out hover:ease-in hover:bg-gradient-to-r from-[#5463FF] to-[#89CFFD] text-3xl rounded hover:text-white mb-3 sm:w-72'
      onClick={paySeniors}
      >Pay Seniors</button>
      </div>
        )
    }

  return (
    <main className={`${darkMode && "dark"} bg-gradient-to-r from-[#6FB2D2] to-[#D8D2CB]`}> 
        <Sidebar />
    <section className='dark:bg-gradient-to-r from-[#121212] to-[#002B5B] dark:text-white h-[92vh]'>
      <div className='flex justify-center'>
        <h3 className='text-2xl pt-12 inline-block text-black border-b-4 border-[#7084a0] sm:text-5xl font-bold 
            dark:bg-gradient-to-r dark:bg-clip-text dark:text-transparent 
            dark:from-red-400 dark:via-purple-500 dark:to-green-400
            dark:animate-text
        
        '>Pay all your employees in one click</h3>
      </div>
      <div className='sm:flex sm:items-center sm:justify-center py-16 px-20'>
      <div className=''>
          {renderInternsButton()}
          {renderJuniorsButton()}
          {renderSeniorsButton()}
      </div>
      <div className='mt-5 sm:ml-28'>
      {darkMode ? <img src="https://img.icons8.com/external-flaticons-lineal-color-flat-icons/184/000000/external-salary-job-search-flaticons-lineal-color-flat-icons.png"/> : 
      <img src="https://img.icons8.com/external-becris-lineal-becris/184/000000/external-salary-customer-loyalty-program-becris-lineal-becris.png"/>
      }
      </div>
      </div>
    </section>
    </main>
  )
}

export default Hero