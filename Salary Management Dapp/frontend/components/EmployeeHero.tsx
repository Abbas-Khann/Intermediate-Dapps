import React, {useEffect, useState} from 'react';
import Sidebar from './Sidebar';
import { useGlobalContext } from '../Context/Context';
import EmployeeCard from './EmployeeCard';
import { useProvider, useSigner, useContract } from 'wagmi';
import { abi, CONTRACT_ADDRESS } from '../Constants/Index';

const Hero = () => {
    const [cardData, setCardData] = useState<any[]>([]);
    const [id, setId] = useState<number>(0)
    const {darkMode} = useGlobalContext();
    const provider = useProvider();
    const {data: signer} = useSigner();
    const contract = useContract({
      addressOrName: CONTRACT_ADDRESS,
      contractInterface: abi,
      signerOrProvider: signer || provider
    });

    const fetchId = async (): Promise<void> => {
      try {
        const _id = await contract.employeeId;
        setId(_id.toNumber());
      } 
      catch (err: any) {
        console.error(err.reason);
      }
    }

    console.log(id)

    const fetchMapping = async (val: number): Promise<void> => {
      try {
        const data: any = await contract.employee();
        await data;
        return data;
      } 
      catch (err: any) {
        console.error(err.reason);  
      }
    }

    const fetchEmployees = async (): Promise<void> => {
      try {
        const _employeeId = await contract.employeeId();
        console.log("_employeeId", _employeeId.toNumber());
        const promises: any[] = [];
        for(let i: number = 0; i < _employeeId.toNumber(); i++) {
          const promisesEmployees = await fetchMapping(i);
          promises.push(promisesEmployees);
        }
        const proms = await Promise.all(promises);
        console.table("proms", proms);
        setCardData(proms);
      } 
      catch (err: any) {
        console.error(err.reason);  
      }
    }

    useEffect(() => {
      fetchId();
      fetchEmployees();
    }, [id, cardData])

    const renderEmployeeCard: JSX.Element[] = cardData.map((employee: any, idx) => {
      return <EmployeeCard key={idx} employee={employee} idx={idx}/>
    })

  return (
    <main className={`${darkMode && "dark"} bg-gradient-to-r from-[#6FB2D2] to-[#D8D2CB]`}> 
        <Sidebar />
    <section className='dark:bg-gradient-to-r from-[#121212] to-[#002B5B] dark:text-white min-h-screen'>
      <div className='flex justify-center'>
        <h3 className='text-2xl pt-12 inline-block text-black border-b-4 border-[#7084a0] sm:text-5xl font-bold 
            dark:bg-gradient-to-r dark:bg-clip-text dark:text-transparent 
            dark:from-red-400 dark:via-purple-500 dark:to-green-400
            dark:animate-text
        
        '>Employees List</h3>
      </div>
      <div className='flex justify-around flex-wrap gap-x-5 gap-y-14 w-8/12 mr-52 ml-auto pt-10'>
          {renderEmployeeCard}
      </div>
    </section>
    </main>
  )
}

export default Hero