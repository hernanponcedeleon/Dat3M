package com.dat3m.dartagnan.wmm.utils;

public enum Arch {
    NONE, ALPHA, ARM, ARM8, POWER, PSO, RMO, TSO;

    public static Arch get(String arch){
        if(arch != null){
            arch = arch.trim();
            switch(arch){
                case "none":
                    return NONE;
                case "alpha":
                    throw new UnsupportedOperationException("Unsupported architecture alpha");
                case "arm":
                    return ARM;
                case "arm8":
                    return ARM8;
                case "power":
                    return POWER;
                case "pso":
                    throw new UnsupportedOperationException("Unsupported architecture pso");
                case "rmo":
                    throw new UnsupportedOperationException("Unsupported architecture rmo");
                case "tso":
                    return TSO;
            }
        }
        return NONE;
    }

    public boolean getIncludePoToCtrl(){
        switch(this) {
            case ALPHA:
            case ARM:
            case ARM8:
            case POWER:
            case RMO:
                return true;
                default:
                    return false;
        }
    }

    @Override
    public String toString() {
        switch(this){
            case NONE:
                return "none";
            case ALPHA:
                return "alpha";
            case ARM:
                return "arm";
            case ARM8:
                return "arm8";
            case POWER:
                return "power";
            case PSO:
                return "pso";
            case RMO:
                return "rmo";
            case TSO:
                return "tso";
        }
        return super.toString();
    }
}
