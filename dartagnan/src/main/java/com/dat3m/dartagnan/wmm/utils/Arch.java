package com.dat3m.dartagnan.wmm.utils;

public enum Arch {
    NONE, ARM, ARM8, POWER, TSO;

    public static Arch get(String arch){
        if(arch != null){
            arch = arch.trim();
            switch(arch){
                case "none":
                    return NONE;
                case "arm":
                    return ARM;
                case "arm8":
                    return ARM8;
                case "power":
                    return POWER;
                case "tso":
                    return TSO;
            }
        }
        throw new UnsupportedOperationException("Unrecognized architecture " + arch);
    }

    @Override
    public String toString() {
        switch(this){
            case NONE:
                return "none";
            case ARM:
                return "arm";
            case ARM8:
                return "arm8";
            case POWER:
                return "power";
            case TSO:
                return "tso";
        }
        return super.toString();
    }
}
