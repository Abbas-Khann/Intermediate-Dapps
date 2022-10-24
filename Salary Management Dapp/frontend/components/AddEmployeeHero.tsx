import React, {useState} from 'react';
import { useGlobalContext } from '../Context/Context';
import Sidebar from './Sidebar';
import { useSigner, useProvider, useContract } from 'wagmi';
import { abi, CONTRACT_ADDRESS } from '../Constants/Index';

const AddEmployeeHero = () => {
    const {darkMode} = useGlobalContext();
    const [inputData, setInputData] = useState<Object>({
      name: "",
      address: "",
    });
    const options = [
      {value: 0, text: 'Intern'},
      {value: 1, text: 'Junior'},
      {value: 2, text: 'Senior'}
    ];
    const [position, setPosition] = useState(options[0].value);

    const provider = useProvider();
    const { data: signer } = useSigner();
    const contract = useContract({
      addressOrName: CONTRACT_ADDRESS,
      contractInterface: abi,
      signerOrProvider: signer || provider
    });

    const handleChange = (e: any): void => {
      setInputData((prevData) => {
        return {
          ...prevData,
           [e.target.name]: e.target.value
        };
      });
    }

    const handleOptionsChange = (e: any): void => {
      console.log(e.target.value);
      setPosition(+e.target.value);
    }
 
    const enterEmployeeDetails = async (value: any): Promise<void> => {
      try {
        if(value.name && value.address) {
          const tx: any = await contract.addEmployee(
            value.name,
            value.address,
            +position
            );
            await tx.wait();
          }
      } 
      catch (err: any) {
        console.error(err)
        console.log(err.reason)
      }
    }
    React.useEffect(() => {
      console.log(inputData) 
      console.log(position)
    })

    const renderButton = (): JSX.Element => {
        return(
        <div className='flex flex-col '>
      <p className='text-2xl sm:text-3xl py-4'>Enter Employee Details</p>
      <input
          className=' text-black text-2xl border-2 dark:text-white font-bold dark:bg-gradient-to-r dark:bg-clip-text dark:text-transparent 
          dark:from-red-400 dark:via-purple-500 dark:to-white
          dark:animate-text sm:full'
          placeholder='Enter Employee Name'
          name='name'
          onChange={handleChange}
          />
      <input
          className=' text-black text-2xl border-2 dark:text-white font-bold dark:bg-gradient-to-r dark:bg-clip-text dark:text-transparent 
          dark:from-red-400 dark:via-purple-500 dark:to-white
          dark:animate-text sm:full my-4'
          placeholder='Enter Address'
          name='address'
          onChange={handleChange}
          />
        <p className='text-2xl sm:text-3xl pb-4'>Employee Position</p>
        <select className='text-black'
        value={position}
        onChange={handleOptionsChange}
        >
          {options.map((option) => {
            return <option key={option.value} value={option.value}>{option.text}</option>
          })}
      </select>
      <button className='px-4 py-2 mt-8 border-2 transition duration-300 ease-out hover:ease-in hover:bg-gradient-to-r from-[#5463FF] to-[#89CFFD] text-3xl rounded hover:text-white mb-3 sm:w-72'
      onClick={() => enterEmployeeDetails(inputData)}
      >Submit</button>
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
        
        '>Pay your employees in Crypto with SMD</h3>
      </div>
      <div className='sm:flex sm:items-center sm:justify-center py-16 px-20'>
      <div className=''>
          {renderButton()}
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

export default AddEmployeeHero