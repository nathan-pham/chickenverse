import { useState, useEffect } from "react";

// use wallet hook
const useWallet = () => {
    const [wallet, setWallet] = useState(null);
    const [error, setError] = useState(null);

    const [force, setForce] = useState(0);
    const forceFetchWallet = () => {
        setForce(force + 1);
    };

    // check if Metmask installed/already authorized
    useEffect(async () => {
        if (!window.ethereum) {
            setError("Metmask is not installed");
            return;
        }

        const account = ((await ethereum.request({
            method: "eth_accounts",
        })) || [])[0];

        if (account && ethereum.networkVersion === "4") {
            setWallet(account);
        } else {
            setError(
                "Metmask is not authorized or wrong network (please use Rinkeby)"
            );
        }
    }, [force]);

    // onClick for connecting a wallet
    const connectWallet = async () => {
        if (!window.ethereum) {
            setError("Metmask is not installed");
            return;
        }

        const account = ((await ethereum.request({
            method: "eth_requestAccounts",
        })) || [])[0];

        if (account && ethereum.networkVersion === "4") {
            setWallet(account);
        } else {
            setError(
                "Metmask is not authorized or wrong network (please use Rinkeby)"
            );
        }
    };

    return { wallet, connectWallet, forceFetchWallet, error };
};

export default useWallet;
