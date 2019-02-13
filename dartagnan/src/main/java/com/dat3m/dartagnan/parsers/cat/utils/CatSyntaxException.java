package com.dat3m.dartagnan.parsers.cat.utils;

public class CatSyntaxException extends RuntimeException {

    public CatSyntaxException(String ctx){
        super("Invalid syntax at " + ctx);
    }
}
