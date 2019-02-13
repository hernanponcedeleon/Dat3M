package com.dat3m.dartagnan.program.utils;

public enum Alias {
    NONE,
    CFIS, // Content flow insensitive (Andersen)
    CFS;  // Content flow sensitive

    public static Alias get(String alias){
        if(alias != null){
            alias = alias.trim();
            switch(alias){
                case "none":
                    return NONE;
                case "andersen":
                    return CFIS;
                case "cfs":
                    return CFS;
            }
        }
        return CFIS;
    }

    @Override
    public String toString() {
        switch(this){
            case NONE:
                return "none";
            case CFIS:
                return "andersen";
            case CFS:
                return "cfs";
        }
        return super.toString();
    }
}
