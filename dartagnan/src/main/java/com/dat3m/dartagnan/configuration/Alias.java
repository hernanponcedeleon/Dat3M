package com.dat3m.dartagnan.configuration;

import java.util.Arrays;

public enum Alias implements OptionInterface {
    // For comparison reasons, we might want to add a NONE method with may = true, must = false
    FIELD_INSENSITIVE, FINITE_FIELDS, LINEAR_FIELDS, LINEAR_MD_FIELDS;

    public static Alias getDefault() {
        return LINEAR_MD_FIELDS;
    }

    // Used to decide the order shown by the selector in the UI
    public static Alias[] orderedValues() {
        Alias[] order = { LINEAR_FIELDS, FIELD_INSENSITIVE, FINITE_FIELDS, LINEAR_MD_FIELDS };
        // Be sure no element is missing
        assert (Arrays.asList(order).containsAll(Arrays.asList(values())));
        return order;
    }
}