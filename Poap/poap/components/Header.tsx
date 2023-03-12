import { ConnectWallet } from "@thirdweb-dev/react";
import Image from "next/image";
import { Aurora } from "./Aurora";

const Header: React.FC = () => {
    return(
        <header>
            <Aurora 
            size={{ width: "1800px", height: "1500px" }}
            pos={{ top: "0%", left: "50%" }}
            color="hsl(277deg 59% 39% / 20%)"
            />
        </header>
    )
}

export default Header