package com.dat3m.ui.options.utils;

public enum Method {
	TWOSOLVERS,
    INCREMENTAL;

    @Override
    public String toString() {
        switch(this){
        	case TWOSOLVERS:
        		return "Two-solvers";
        	case INCREMENTAL:
        		return "Incremental";
        }
        return super.toString();
    }
}
