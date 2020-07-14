package com.dat3m.dartagnan.wmm.utils.alias;

public enum Alias {
    CFIS, // Content flow insensitive (Andersen)
    NONE,
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
        throw new UnsupportedOperationException("Illegal alias value");
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
