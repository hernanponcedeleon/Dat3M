package com.dat3m.dartagnan.utils;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.function.Predicate;

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
        var data = ImmutableMap.<String, Result>builder();
        Files.readAllLines(Path.of(path)).stream().filter(ResourceHelper::isValidEntry).forEach(str -> {
            String[] line = str.split(",");
            if(line.length == 2){
                data.put(getRootPath(line[0]), Integer.parseInt(line[1]) == 1 ? PASS : FAIL);
            }
        });
        return data.build();
    }

    public static ImmutableSet<String> getSkipSet() throws IOException {
        String path = getTestResourcePath("dartagnan-skip.csv");
        return Files.readAllLines(Path.of(path)).stream().filter(ResourceHelper::isValidEntry).collect(ImmutableSet.toImmutableSet());
    }

    private static boolean isValidEntry(String line) {
        return !line.isBlank() && !line.startsWith("//");
    }

}