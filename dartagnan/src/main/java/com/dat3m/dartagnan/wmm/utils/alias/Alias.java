package com.dat3m.dartagnan.wmm.utils.alias;

public enum Alias {
    CFIS, // Content flow insensitive (Andersen)
    CFS,  // Content flow sensitive
    NONE;

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

	// Used for options in the console
    public String toShortString() {
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

	// Used to display in UI
    @Override
    public String toString() {
        switch(this){
            case NONE:
                return "None";
            case CFIS:
                return "Andersen";
            case CFS:
                return "CFS";
        }
        return super.toString();
    }
}
