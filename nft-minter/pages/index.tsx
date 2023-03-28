import {
  useConnectionStatus,
} from "@thirdweb-dev/react";
import type { NextPage } from "next";
import Header from "../components/header";
import Welcome from "../components/welcome";
import { Spinner } from "../components/Spinner/Spinner";

const Home: NextPage = () => {
  // contract data
  const connectionStatus = useConnectionStatus();
  return (
    <div>
        <Header />
        <div className="max-w-3xl flex flex-col items-center mx-auto py-8 px-4">
          {connectionStatus === "disconnected" && <Welcome />}

          {(connectionStatus === "connecting" ||
            connectionStatus === "unknown") && <Loading />}

          {connectionStatus === "connected" && (
            <>
              {<Welcome />}
            </>
          )}
        </div>
        </div>
  );
};

export default Home;

const Loading = () => {
  return (
    <div
      className="flex justify-center items-center"
      style={{
        height: "700px",
      }}
    >
      <Spinner size="50px" />
    </div>
  );
};
