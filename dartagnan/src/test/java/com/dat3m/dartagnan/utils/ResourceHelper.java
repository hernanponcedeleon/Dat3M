package com.dat3m.dartagnan.utils;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;

public class ResourceHelper {

    public static Path getRootPath(String path) {
        return Path.of("..").resolve(path);
    }

    public static Path getTestResourcePath(String path) {
        return Path.of("src", "test", "resources").resolve(path);
    }

    public static ImmutableMap<Path, Result> getExpectedResults(String arch, String postfix) throws IOException {
        Path path = getTestResourcePath(arch + postfix + "-expected.csv");
        var data = ImmutableMap.<Path, Result>builder();
        Files.readAllLines(path).stream().filter(ResourceHelper::isValidEntry).forEach(str -> {
            String[] line = str.split(",");
            if (line.length == 2) {
                data.put(getRootPath(line[0]), Integer.parseInt(line[1]) == 1 ? PASS : FAIL);
            }
        });
        return data.build();
    }

    public static ImmutableSet<Path> getSkipSet() throws IOException {
        return Files.readAllLines(getTestResourcePath("dartagnan-skip.csv")).stream()
                .filter(ResourceHelper::isValidEntry)
                .map(ResourceHelper::getRootPath)
                .collect(ImmutableSet.toImmutableSet());
    }

    private static boolean isValidEntry(String line) {
        return !line.isBlank() && !line.startsWith("//");
    }

}
