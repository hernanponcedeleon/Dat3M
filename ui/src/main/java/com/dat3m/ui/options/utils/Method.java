package com.dat3m.ui.options.utils;

public enum Method {
	TWOSOLVERS,
    INCREMENTAL,
    GRAPH;

    @Override
    public String toString() {
        switch(this){
        	case TWOSOLVERS:
        		return "Two-solvers";
        	case INCREMENTAL:
        		return "Incremental";
            case GRAPH:
                return "Graph-based";
        }
        return super.toString();
    }
}
