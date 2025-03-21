package com.dat3m.dartagnan.exception;

public class ParsingException extends RuntimeException {

    public ParsingException(String msg){
        super(msg);
    }

    public ParsingException(String format, Object... args){
        super(String.format(format, args));
    }

    public ParsingException(Throwable cause, String format, Object... args){
        super(String.format(format, args), cause);
    }
}
