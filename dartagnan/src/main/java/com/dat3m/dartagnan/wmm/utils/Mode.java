package com.dat3m.dartagnan.wmm.utils;

public enum Mode {
    KNASTER, IDL, KLEENE;

    public static Mode get(String mode){
        if(mode != null){
            mode = mode.trim();
            switch(mode){
                case "knastertarski":
                    return KNASTER;
                case "idl":
                    return IDL;
                case "kleene":
                    return KLEENE;
            }
        }
        return KNASTER;
    }

    @Override
    public String toString() {
        switch(this){
            case KNASTER:
                return "knastertarski";
            case IDL:
                return "idl";
            case KLEENE:
                return "kleene";
        }
        return super.toString();
    }
}
