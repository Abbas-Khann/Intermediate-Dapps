import React from "react";

const AppointmentCard = (props: any) => {

  const { title, attendee, startingTime, endingTime, amountPaid } = props

  return (
    <div className="text-black w-10/12 sm:w-8/12 md:w-7/12 lg:w-5/12 px-10 py-4 bg-gradient-to-b from-violet-400 to-fuchsia-400 rounded-md mt-20">
      <div className="flex justify-between items-center pt-1 pb-4">
        <h3 className="border-l-4 border-black mb-2 p-1 md:text-xl text-white">
          {title}
        </h3>
        <button className="px-3 py-1 border-2 rounded-md hover:bg-indigo-500 hover:transition-all hover:duration-500 hover:text-white">
          Withdraw
        </button>
      </div>
      <div className="flex flex-col sm:px-12 px-2 py-5 bg-[#1C0238] text-white rounded-md ">
        <div className="flex justify-center mb-3">
          <h4 className="border-l-2 border-pink-400 mb-2 p-1">Address:</h4>
          <h4 className="mt-1 break-all sm:pl-8">
            {attendee}
          </h4>
        </div>
        <div className="flex">
          <h4 className="border-l-2 border-pink-400 mb-2 p-1">
            Starting Time:
          </h4>
          <h4 className="pl-2 mt-1"> pm</h4>
        </div>
        <div className="flex">
          <h4 className="border-l-2 border-pink-400 mb-2 p-1">Ending Time:</h4>
          <h4 className="pl-4 mt-1">11:00 pm</h4>
        </div>
        <div className="flex">
          <h4 className="border-l-2 border-pink-400 mb-2 p-1">Cost:</h4>
          <h4 className="pl-16 mt-1">&nbsp; &nbsp; 0.1 Ether</h4>
        </div>
      </div>
      <div className="flex justify-between pt-4">
        <button className="px-3 py-1 border-2 rounded-md hover:bg-indigo-500 hover:transition-all hover:duration-500 hover:text-white">
          Cancel
        </button>
        <button className="px-3 py-1 border-2 rounded-md hover:bg-indigo-500 hover:transition-all hover:duration-500 hover:text-white">
          Appointment Completed
        </button>
        <button className="px-3 py-1 border-2 rounded-md hover:bg-indigo-500 hover:transition-all hover:duration-500 hover:text-white">
          Refund
        </button>
      </div>
    </div>
  );
};

export default AppointmentCard;