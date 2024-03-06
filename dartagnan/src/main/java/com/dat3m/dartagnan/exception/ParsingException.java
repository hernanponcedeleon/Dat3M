package com.dat3m.dartagnan.exception;

public class ParsingException extends RuntimeException {

    public ParsingException(String msg){
        super(msg);
    }

    public ParsingException(String format, Object... args){
        this(String.format(format, args));
    }
}
