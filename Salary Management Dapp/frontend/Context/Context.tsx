import React, {useState, useContext, createContext, useRef} from  'react';

export const IndexContext = createContext(darkMode);

const IndexProvider = ( { children }:any ) => {
    const [darkMode, setDarkMode] = useState<boolean>(true);
    const toggleDarkMode = () => {
      setDarkMode(!darkMode);
    };
    return(
        <IndexContext.Provider 
        value={{ toggleDarkMode, darkMode }}
        >
            {children}
        </IndexContext.Provider>
    )
};

export const useGlobalContext = () => {
    return useContext(IndexContext);
}

export { IndexProvider };