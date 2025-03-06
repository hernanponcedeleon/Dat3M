package com.dat3m.dartagnan.drunner.printer;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public abstract class AbstractPrinter {

    protected final Map<String, Map<String, String>> data;
    protected final List<String> types;
    protected final List<String> tests;

    protected AbstractPrinter(Map<String, Map<String, String>> data) {
        this.data = data;
        this.types = data.keySet().stream()
                .sorted()
                .toList();
        this.tests = data.values().stream()
                .flatMap(d -> d.keySet().stream())
                .collect(Collectors.toSet())
                .stream()
                .sorted()
                .toList();
    }

    public abstract String print();
}
