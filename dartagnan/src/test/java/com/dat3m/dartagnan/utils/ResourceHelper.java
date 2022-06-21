package com.dat3m.dartagnan.utils;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;

import java.io.*;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;

public class ResourceHelper {

    public static final String CAT_RESOURCE_PATH = "../";
    public static final String LITMUS_RESOURCE_PATH = "../";
    public static final String TEST_RESOURCE_PATH = "src/test/resources/";

    private static ImmutableMap<String, Result> expectedResults;
    private static ImmutableSet<String> skipSet;

    public static ImmutableMap<String, Result> getExpectedResults(String arch) throws IOException {
        if(expectedResults == null){
            try (BufferedReader reader = new BufferedReader(new FileReader(TEST_RESOURCE_PATH + arch + "-expected.csv"))) {
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

    public static ImmutableSet<String> getSkipSet() throws IOException {
        if(skipSet == null){
            try (BufferedReader reader = new BufferedReader(new FileReader(TEST_RESOURCE_PATH + "dartagnan-skip.csv"))) {
                Set<String> data = new HashSet<>();
                String str;
                while((str = reader.readLine()) != null){
                	if(str.contains("//") || str.isBlank()) {
                		continue;
                	}
                	data.add(LITMUS_RESOURCE_PATH + str);
                }
                skipSet = ImmutableSet.copyOf(data);
            }
        }
        return skipSet;
    }

    public static Result readExpected(String filepath, String property) {
        try (BufferedReader br = new BufferedReader(new FileReader(filepath))) {
            while (!(br.readLine()).contains(property)) {
                continue;
            }
            return br.readLine().contains("false") ? FAIL : PASS;

        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.exit(0);
        }
        return null;
    }

    public static void initialiseCSVFile(Class<?> testingClass, String name) throws IOException {
        File file = new File(getCSVFileName(testingClass, name));
        file.delete();
        if (file.getParentFile() != null) {
            file.getParentFile().mkdirs();
        }
    	try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, false))) {
            writer.append("benchmark, result, time");
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