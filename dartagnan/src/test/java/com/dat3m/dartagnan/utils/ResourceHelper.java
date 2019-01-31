package com.dat3m.dartagnan.utils;

import com.google.common.collect.ImmutableMap;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

public class ResourceHelper {

    public static final String CAT_RESOURCE_PATH = "../";
    public static final String LITMUS_RESOURCE_PATH = "../";
    public static final String TEST_RESOURCE_PATH = "src/test/resources/";

    private static ImmutableMap<String, Boolean> expectedResults;

    public static ImmutableMap<String, Boolean> getExpectedResults() throws IOException {
        if(expectedResults == null){
            try (BufferedReader reader = new BufferedReader(new FileReader(TEST_RESOURCE_PATH + "dartagnan-expected.csv"))) {
                HashMap<String, Boolean> data = new HashMap<>();
                String str;
                while((str = reader.readLine()) != null){
                    String[] line = str.split(",");
                    if(line.length == 2){
                        data.put(line[0], Integer.parseInt(line[1]) == 1);
                    }
                }
                expectedResults = ImmutableMap.copyOf(data);
            }
        }
        return expectedResults;
    }
}
