package com.dat3m.dartagnan.witness.graphml;

public enum EdgeAttributes {

    CREATETHREAD, THREADID, ENTERFUNCTION, STARTLINE;

    @Override
    public String toString() {
        return switch (this) {
            case CREATETHREAD -> "createThread";
            case THREADID -> "threadId";
            case ENTERFUNCTION -> "enterFunction";
            case STARTLINE -> "startline";
        };
    }
}
