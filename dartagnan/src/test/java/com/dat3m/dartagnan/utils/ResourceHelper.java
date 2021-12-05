package com.dat3m.dartagnan.utils;

import com.google.common.collect.ImmutableMap;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;

public class ResourceHelper {

    public static final String CAT_RESOURCE_PATH = "../";
    public static final String LITMUS_RESOURCE_PATH = "../";
    public static final String TEST_RESOURCE_PATH = "src/test/resources/";

    private static ImmutableMap<String, Result> expectedResults;

    public static ImmutableMap<String, Result> getExpectedResults() throws IOException {
        if(expectedResults == null){
            try (BufferedReader reader = new BufferedReader(new FileReader(TEST_RESOURCE_PATH + "dartagnan-expected.csv"))) {
                HashMap<String, Result> data = new HashMap<>();
                String str;
                while((str = reader.readLine()) != null){
                    String[] line = str.split(",");
                    if(line.length == 2){
                        data.put(line[0], Integer.parseInt(line[1]) == 1 ? FAIL : PASS);
                    }
                }
                expectedResults = ImmutableMap.copyOf(data);
            }
        }
        return expectedResults;
    }

    public static void initialiseCSVFile(Class<?> testingClass, String name) throws IOException {
        Files.deleteIfExists(Paths.get(getCSVFileName(testingClass, name)));
    	try (BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(testingClass, name), true))) {
            writer.append("benchmark, time");
            writer.newLine();    		
    	}
    }

    public static String getCSVFileName(Class<?> testingClass, String name) {
        int dirIndex = name.lastIndexOf("/");
        String dirPrefix = dirIndex == -1 ? "" : name.substring(0, dirIndex + 1);
        String fileName = dirIndex == -1 ? name : name.substring(dirIndex + 1);
        return String.format("%s/output/%s%s-%s.csv", System.getenv("DAT3M_HOME"), dirPrefix, testingClass.getSimpleName(), fileName);
    }
}
