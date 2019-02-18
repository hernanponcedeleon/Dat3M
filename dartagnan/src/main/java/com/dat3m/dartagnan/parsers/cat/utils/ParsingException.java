package com.dat3m.dartagnan.parsers.cat.utils;

public class ParsingException extends RuntimeException {

    public ParsingException(String ctx){
        super("Invalid syntax at " + ctx);
    }
}
