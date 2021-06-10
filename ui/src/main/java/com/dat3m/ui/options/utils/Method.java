package com.dat3m.ui.options.utils;

public enum Method {
    INCREMENTAL,
    ASSUME,
	TWOSOLVERS;

    @Override
    public String toString() {
        switch(this){
        	case TWOSOLVERS:
        		return "Two-solvers";
        	case INCREMENTAL:
        		return "Incremental";
        	case ASSUME:
        		return "Assume";
        }
        return super.toString();
    }
}
