import React, { useState, useContext, createContext } from "react";

export const IndexContext = createContext<any>({});

const IndexProvider = ({ children }: any) => {
  // States here
  const [darkMode, setDarkMode] = useState(true);
  const [indexData, setIndexData] = useState("");
  const toggleDarkMode = () => {
    setDarkMode(!darkMode);
  };
  return (
    <IndexContext.Provider
      value={{ toggleDarkMode, darkMode, indexData, setIndexData }}
    >
      {children}
    </IndexContext.Provider>
  );
};

export const useGlobalContext = () => {
  return useContext(IndexContext);
};

export { IndexProvider };
