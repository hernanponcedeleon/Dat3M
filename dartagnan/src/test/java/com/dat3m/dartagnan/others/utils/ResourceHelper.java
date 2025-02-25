package com.dat3m.dartagnan.others.utils;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;

import java.io.*;
import java.nio.file.Path;
import java.util.*;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;

public class ResourceHelper {

    public static String toPlatformPath(String path) {
        String[] parts = path.split("/");
        if (parts.length == 1) {
            return path;
        }
        return Path.of(parts[0], Arrays.copyOfRange(parts, 1, parts.length)).toString();
    }

    public static String getRootPath(String path) {
        return toPlatformPath("../" + path);
    }

    public static String getTestResourcePath(String path) {
        return toPlatformPath("src/test/resources/" + path);
    }

    public static ImmutableMap<String, Result> getExpectedResults(String arch, String postfix) throws IOException {
        String path = getTestResourcePath(arch + postfix + "-expected.csv");
        try (BufferedReader reader = new BufferedReader(new FileReader(path))) {
            HashMap<String, Result> data = new HashMap<>();
            String str;
            while((str = reader.readLine()) != null){
                String[] line = str.split(",");
                if(line.length == 2){
                    data.put(getRootPath(line[0]), Integer.parseInt(line[1]) == 1 ? PASS : FAIL);
                }
            }
            return ImmutableMap.copyOf(data);
        }
    }

    public static ImmutableSet<String> getSkipSet() throws IOException {
        String path = getTestResourcePath("dartagnan-skip.csv");
        try (BufferedReader reader = new BufferedReader(new FileReader(path))) {
            Set<String> data = new HashSet<>();
            String str;
            while((str = reader.readLine()) != null){
            	if(str.startsWith("//") || str.isBlank()) {
            		continue;
                }
            	data.add(getRootPath(str));
            }
            return ImmutableSet.copyOf(data);
        }
    }

    public static Result readExpected(String filepath, String property) {
        try (BufferedReader br = new BufferedReader(new FileReader(filepath))) {
            String str;
            while((str = br.readLine()) != null){
                if (str.contains(property)) {
                    return br.readLine().contains("false") ? FAIL : PASS;
                }
            }
            throw new IllegalArgumentException("Missing expected result for property " + property);
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.exit(0);
        }
        return null;
    }
}