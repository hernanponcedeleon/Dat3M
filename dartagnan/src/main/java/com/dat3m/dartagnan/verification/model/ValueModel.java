package com.dat3m.dartagnan.verification.model;


// This class currently only serves as a representation of values in ExecutionModelNext,
// in order to avoid the type conversion at value extraction.
// TODO: Replace by TypedValue
public record ValueModel(Object value) {

    @Override
    public String toString() {
        return String.valueOf(value);
    }
}