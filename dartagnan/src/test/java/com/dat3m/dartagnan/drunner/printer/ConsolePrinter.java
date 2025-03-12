package com.dat3m.dartagnan.drunner.printer;

import java.util.Map;

public class ConsolePrinter extends AbstractPrinter {

    public ConsolePrinter(Map<String, Map<String, String>> data) {
        super(data);
    }

    @Override
    public String print() {
        int testLength = tests.stream().map(String::length).max(Integer::compare).orElseThrow();
        int typeLength = types.stream().map(String::length).max(Integer::compare).orElseThrow();
        String testPattern = "%-" + testLength + "s";
        String typePattern = "%-" + typeLength + "s";

        StringBuilder sb = new StringBuilder();
        sb.append("| ").append(String.format(testPattern, "test")).append(" | ");
        for (String type : types) {
            sb.append(String.format(typePattern, type)).append(" | ");
        }
        sb.append("\n");
        for (String test : tests) {
            sb.append("| ").append(String.format(testPattern, test)).append(" | ");
            for (String type : types) {
                String result = data.get(type).getOrDefault(test, "");
                sb.append(String.format(typePattern, result)).append(" | ");
            }
            sb.append('\n');
        }
        return sb.toString();
    }
}
