import type { NextPage } from 'next'
import React, { useState } from 'react'
import Head from 'next/head'
import { StoreContent } from '../components/StoreContent';
import styles from '../styles/Storage3.module.css';
import Link from 'next/link'

const Home: NextPage = () => {

    const [files, setFiles] = useState([]);
    const [ipfsUrl, setIpfsUrl] = useState<string>('');

    const uploadFiles = async ():Promise <void> => {
        try {
            const cid: string = await StoreContent(files);
            const URL: string = `https://ipfs.io/ipfs/${cid}`;
            console.table(URL);
            console.log("file uploaded to ipfs");
            setIpfsUrl(URL);
        }
        catch (err) {
            console.error("Upload Failed", err)
        }
    }

    return (
        <div className={styles.container}>
          <Head>
            <title>Store Files on IPFS</title>
            <style>
                @import url(`https://fonts.googleapis.com/css2?family=Poppins:wght@500&display=swap`);
            </style>
            <meta
              name="description"
              content="Now stores all your files over decentralized data storage"
            />
          </Head>
    
          <main className={styles.main}>
            <h1 className={styles.title}>
              Welcome to <a>Storage3</a>
            </h1>
    
            <p className={styles.description}>
              Get started by uploading the document you want to store
            </p>
    
            <div className={styles.form}>
              <div className={styles.firstRow}>
                <label className={styles.inputLabel}>
                  <input
                    className={styles.inputBox}
                    type="file"
                    onChange={(e) => setFiles(e.target.files[0])}
                  ></input>
                </label>
              </div>
              <div className={styles.buttonRow}>
                <button onClick={uploadFiles} className={styles.button}>
                  Lets Go 🚀
                </button>
              </div>
              <div className={styles.secondrow}>
                {ipfsUrl ? (
                  <a className={styles.returnText} href={ipfsUrl}>
                    Ipfs Link{" "}
                  </a>
                ) : (
                  <a className={styles.returnText}>File is yet to upload</a>
                )}
              </div>
            </div>
          </main>
    
          <footer className={styles.footer}>
            <a
              href="https://twitter.com/KhanAbbas201"
              target="_blank"
              rel="noopener noreferrer"
            >
              Built by @Abbas Khan
            </a>
            <a href="https://github.com/Abbas-Khann">Github</a>
          </footer>
        </div>
      );

}

export default Home
