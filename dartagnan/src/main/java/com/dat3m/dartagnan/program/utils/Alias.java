package com.dat3m.dartagnan.program.utils;

public enum Alias {
    NONE, BASIC, CFS;

    public static Alias get(String alias){
        if(alias != null){
            alias = alias.trim();
            switch(alias){
                case "none":
                    return NONE;
                case "cfi":
                    return BASIC;
                case "cfs":
                    return CFS;
            }
        }
        return BASIC;
    }

    @Override
    public String toString() {
        switch(this){
            case NONE:
                return "none";
            case BASIC:
                return "cfi";
            case CFS:
                return "cfs";
        }
        return super.toString();
    }
}
