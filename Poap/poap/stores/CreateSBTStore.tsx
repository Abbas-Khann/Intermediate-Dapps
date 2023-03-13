import { create } from "zustand";
import { SBTFORM } from "../constants/constants";

interface CreateSBTState {
    name: string;
    description: string;
    amount: number;
    maxClaimable: number;
    startingDate: Date;
    image: string;
    imageFile: File | null;
    addresses: string[];
    form: SBTFORM;
    setName: (name: string) => void;
    setDescription: (description: string) => void;
    setAmount: (amount: number) => void;
    setMaxClaimable: (maxClaimable: number) => void;
    setStartingDate: (startingDate: Date) => void;
    setAddresses: (address: string) => void;
    setForm: (form: SBTFORM) => void;
}

export const useCreateSBTStore = create<CreateSBTState>()((set) => ({
    name: "",
    description: "",
    amount: 0,
    maxClaimable: 0,
    startingDate: new Date(),
    image: "",
    imageFile: null,
    addresses: [],
    form: SBTFORM.CREATE_SBT,
    setName(name) {
        set((state) => {
            return {
                ...state,
                name : name
            }
        })
    },
    setDescription(description) {
        set((state) => {
            return {
                ...state,
                description: description
            }
        })
    },
    setAmount(amount) {
        set((state) => {
            return {
                ...state,
                amount: amount
            }
        })
    },
    setMaxClaimable(maxClaimable) {
        set((state) => {
            return {
                ...state,
                maxClaimable: maxClaimable
            }
        })
    },
    setStartingDate(startingDate) {
        set((state) => {
            return {
                ...state,
                startingDate: startingDate
            }
        })
    },
    setAddresses(address) {
        set((state) => {
            return {
                ...state,
                address: address
            }
        })
    },
    setForm(form) {
        set((state) => {
            return {
                ...state,
                form: form
            }
        })
    }
}));