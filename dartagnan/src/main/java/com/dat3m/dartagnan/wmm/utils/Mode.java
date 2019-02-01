package com.dat3m.dartagnan.wmm.utils;

public enum Mode {
    RELAX, IDL, LFP;

    public static Mode get(String mode){
        if(mode != null){
            mode = mode.trim();
            switch(mode){
                case "relax":
                    return RELAX;
                case "idl":
                    return IDL;
                case "lfp":
                    return LFP;
            }
        }
        return RELAX;
    }

    @Override
    public String toString() {
        switch(this){
            case RELAX:
                return "relax";
            case IDL:
                return "idl";
            case LFP:
                return "flp";
        }
        return super.toString();
    }
}
