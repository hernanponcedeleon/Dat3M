package com.dat3m.dartagnan.configuration;

public interface OptionInterface {

    // Used for options in the console
    default String asStringOption() {
        return this.toString().toLowerCase();
    }

}