package com.dat3m.ui.options.utils;

public enum Method {
    INCREMENTAL,
    GRAPH;

    @Override
    public String toString() {
        switch(this){
            case INCREMENTAL:
                return "Incremental";
            case GRAPH:
                return "Graph-based";
        }
        return super.toString();
    }
}
