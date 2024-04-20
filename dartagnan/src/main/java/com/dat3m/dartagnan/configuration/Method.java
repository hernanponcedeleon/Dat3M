package com.dat3m.dartagnan.configuration;

import java.util.Arrays;

public enum Method implements OptionInterface {
    EAGER, LAZY;

    // Used for options in the console
    @Override
    public String asStringOption() {
        switch (this) {
            case EAGER:
                return "eager";
            case LAZY:
                return "lazy";
        }
        throw new UnsupportedOperationException("Unrecognized analysis " + this);
    }

    // Used to display in UI
    @Override
    public String toString() {
        switch (this) {
            case EAGER:
                return "Eager analysis";
            case LAZY:
                return "Lazy analysis";
        }
        throw new UnsupportedOperationException("Unrecognized analysis " + this);
    }

    public static Method getDefault() {
        return LAZY;
    }

    // Used to decide the order shown by the selector in the UI
    public static Method[] orderedValues() {
        Method[] order = { LAZY, EAGER };
        // Be sure no element is missing
        assert (Arrays.asList(order).containsAll(Arrays.asList(values())));
        return order;
    }
}