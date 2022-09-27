import Link from "next/link";
import { useState } from "react";
import { Transition } from "@headlessui/react";
import { BiMenu } from "react-icons/bi";
import { MdClose } from "react-icons/md";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import Image from "next/image";
import logo from "../public/Calend3.png";
const Navbar = () => {

  // --------- States here -------------
  const [expand, setExpand] = useState<boolean>(false);

  return (
    <nav className="max-w-full bg-[#1C0238] px-4 py-8 grid grid-cols-2 grid-rows-1 gap-y-7 justify-items-end h-full content-center lg:flex lg:justify-around lg:px-0 font-plus relative lg:items-center ">
      <div className="flex justify-between w-full lg:w-96">
        {!expand ? (
          <a
            href="#"
            className="self-center ml-2 lg:hidden"
            onClick={() => {
              setExpand(!expand);
            }}
          >
            <BiMenu className="text-3xl text-white" />
          </a>
        ) : (
          <a
            href="#"
            className="self-center text-center lg:hidden fixed top-10 left-2/4 z-50 rounded-full ml-3 bg-gray-600 dark:bg-slate-50 px-2 py-2"
            onClick={() => {
              setExpand(!expand);
            }}
          >
            <MdClose className="text-2xl text-white dark:text-black" />
          </a>
        )}
        <Image src={logo} width={150} height={35} alt="" />
        {/* <h1 className="text-2xl font-semibold dark:text-skin-darkSecondary">
          NFTicket
        </h1> */}
      </div>
      <ul className="hidden lg:flex justify-between items-center basis-2/5 text-lg text-white">
        <Link href="/">
          <button className="cursor-pointer hover:border-b-2 hover:border-[#E7E0C9] transition-all text-skin-muted dark:text-skin-darkMuted">
            Home
          </button>
        </Link>
        <Link
          href="/CreateAppointment"
          className="cursor-pointer hover:border-b-2 hover:border-[#E7E0C9] transition-all text-skin-muted"
        >
          <button className="cursor-pointer hover:border-b-2 hover:border-[#E7E0C9] transition-all text-skin-muted dark:text-skin-darkMuted">
            Create Appointment
          </button>
        </Link>
        <Link href="/ViewAppointment">
          <button className="cursor-pointer hover:border-b-2 hover:border-[#E7E0C9] transition-all text-skin-muted dark:text-skin-darkMuted">
            View Appointment
          </button>
        </Link>
      </ul>
      {/* ------------ Input component rendered here -------------- */}
      <ConnectButton />
      {/* --------------- Mobile and Tablets --------------- */}

      {/* ------------- Transition for Mobile Menu -------------- */}

      <Transition
        show={expand}
        enter="transition ease-out duration-300 transform"
        enterFrom="opacity-0 scale-95"
        enterTo="opacity-100 scale-100"
        leave="transition ease-in duration-500 transfrom"
        leaveFrom="opacity-100 scale-100"
        leaveTo="opacity-0 scale-95"
        className="lg:hidden w-screen h-screen fixed overflow-y left-0 top-0 z-10"
      >
        <div
          className="lg:hidden flex flex-col items-start h-full px-4 w-2/4 bg-[#1C0238] py-10 md:px-8 text-white"
          id="mobile-menu"
        >
          <div className="flex space-x-2 items-center w-auto mb-24">
            <Image src={logo} width={120} height={28} alt="" />
          </div>
          <ul className=" flex flex-col justify-between basis-2/6 items-start mb-20">
            <Link href="/">
              <button className="cursor-pointer hover:border-b-2 hover:border-black transition-all text-skin-muted">
                Home
              </button>
            </Link>
            <Link href="/CreateAppointment">
              <button className="cursor-pointer hover:border-b-2 hover:border-black transition-all text-skin-muted">
                Create Appointments
              </button>
            </Link>
            <Link href="/profile">
              <button className="cursor-pointer hover:border-b-2 hover:border-black transition-all text-skin-muted">
                View Appointments
              </button>
            </Link>
          </ul>
        </div>
      </Transition>
    </nav>
  );
};

export default Navbar;