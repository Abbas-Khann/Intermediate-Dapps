import { ConnectWallet } from "@thirdweb-dev/react";
import Image from "next/image";
import { Aurora } from "./Aurora";

const Header: React.FC = () => {
  return (
    <header className="w-full p-4 mb-12 bg-transparent">
      <Aurora
        size={{ width: "1800px", height: "700px" }}
        pos={{ top: "0%", left: "50%" }}
      />
      <div className="max-w-5xl mx-auto flex justify-between items-center ">
        <div>
          <Image
            className="md:hidden"
            width={48}
            height={48}
            src="/thirdweb.svg"
            alt="thirdweb"
          />
          <Image
            className="hidden md:block"
            width={194}
            height={28}
            src="/logo.png"
            alt="thirdweb"
          />
        </div>

        <div className="max-w-xs">
          <ConnectWallet />
        </div>
      </div>
    </header>
  );
};

export default Header;