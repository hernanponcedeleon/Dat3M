package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.expression.Type;

public class InvalidRegisterTypeException extends RuntimeException {
    public InvalidRegisterTypeException(Type type) {
        super("Intervals not supported for type " + type);
    }
}
