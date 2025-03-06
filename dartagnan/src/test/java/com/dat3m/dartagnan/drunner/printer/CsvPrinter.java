package com.dat3m.dartagnan.drunner.printer;

import java.util.List;
import java.util.Map;

public class CsvPrinter extends AbstractPrinter {

    public CsvPrinter(Map<String, Map<String, String>> data) {
        super(data);
    }

    @Override
    public String print() {
        StringBuilder sb = new StringBuilder();
        sb.append("test").append(",").append(String.join(",", types)).append("\n");
        for (String test : tests) {
            List<String> values = types.stream().map(t -> data.get(t).getOrDefault(test, "")).toList();
            sb.append(test).append(",").append(String.join(",", values)).append("\n");
        }
        return sb.toString();
    }
}
