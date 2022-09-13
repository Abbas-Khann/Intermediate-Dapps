import heroImage from '../public/heroImage.png';
import Image from 'next/image';

const Hero = () => {
    return (
      <section className="px-10 py-24 bg-white text-[#0A043C]">
        <div className="md:flex items-center justify-around ">
          <div className=" md:w-3/5 px-4">
            <h2 className="font-philosopher text-4xl text-skin-base my-4 leading-tight lg:text-7xl tracking-tighter mb-6">
              Crowd Funding <br />
              Dapp
            </h2>
            <p className="text-base text-skin-muted dark:text-skin-darkMuted lg:text-2xl sm:mb-14 mb-10">
              Raise funds for a request, being the contributor vote on causes and also create new requests,
              Get a refund on your money if the project does not proceed after voting
            </p>
            <div>
              <button className="border-full py-2 px-5 rounded-lg border-2 border-[#0A043C] hover:bg-[#e7e6f6]">
                Create Request
              </button>
            </div>
          </div>
          <div className="w-10/12 md:w-1/3 mx-auto md:mx-0 my-8 order-2 ">
            <Image src={heroImage} alt="Hero Image" />
          </div>
        </div>
      </section>
    );
  };
  
  export default Hero;