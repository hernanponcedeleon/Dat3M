package com.dat3m.dartagnan.witness.graphml;

public enum GraphAttributes {

    // General attributes
    ARCHITECTURE, CREATIONTIME, PRODUCER, PROGRAMFILE, PROGRAMHASH, SOURCECODELANG, SPECIFICATION, WITNESSTYPE;

    @Override
    public String toString() {
        return switch (this) {
            case ARCHITECTURE -> "architecture";
            case CREATIONTIME -> "creationtime";
            case PRODUCER -> "producer";
            case PROGRAMFILE -> "programfile";
            case PROGRAMHASH -> "programhash";
            case SOURCECODELANG -> "sourcecodelang";
            case SPECIFICATION -> "specification";
            case WITNESSTYPE -> "witness-type";
        };
    }
}
