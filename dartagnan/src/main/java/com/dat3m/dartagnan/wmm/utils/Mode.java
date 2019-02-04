package com.dat3m.dartagnan.wmm.utils;

public enum Mode {
    RELAX, IDL, LFP;

    public static Mode get(String mode){
        if(mode != null){
            mode = mode.trim();
            switch(mode){
                case "relaxed":
                    return RELAX;
                case "idl":
                    return IDL;
                case "kleene":
                    return LFP;
            }
        }
        return RELAX;
    }

    @Override
    public String toString() {
        switch(this){
            case RELAX:
                return "relaxed";
            case IDL:
                return "idl";
            case LFP:
                return "kleene";
        }
        return super.toString();
    }
}
