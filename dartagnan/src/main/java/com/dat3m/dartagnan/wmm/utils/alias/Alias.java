package com.dat3m.dartagnan.wmm.utils.alias;

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
        //TODO(HP) can we use capital letters? This would like nicer in the ui
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
