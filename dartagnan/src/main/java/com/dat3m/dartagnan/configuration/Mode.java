package com.dat3m.dartagnan.configuration;

import java.util.Arrays;

public enum Mode implements OptionInterface {
    VERIFICATION, ENUMERATION;

    // Used for options in the console
    @Override
    public String asStringOption() {
        return switch (this) {
            case VERIFICATION -> "verification";
            case ENUMERATION -> "enumeration";
        };
    }

    // Used to display in UI
    @Override
    public String toString() {
        return switch (this) {
            case VERIFICATION -> "Verification mode";
            case ENUMERATION -> "Enumeration mode";
        };
    }

    public static Mode getDefault() {
        return VERIFICATION;
    }

    // Used to decide the order shown by the selector in the UI
    public static Mode[] orderedValues() {
        Mode[] order = { VERIFICATION, ENUMERATION };
        // Be sure no element is missing
        assert (Arrays.asList(order).containsAll(Arrays.asList(values())));
        return order;
    }
}