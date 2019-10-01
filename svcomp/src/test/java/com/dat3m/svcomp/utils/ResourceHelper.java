package com.dat3m.svcomp.utils;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Set;
import java.util.stream.Collectors;

import com.dat3m.dartagnan.utils.Result;
import com.google.common.collect.ImmutableMap;

public class ResourceHelper {
    public static final String CAT_RESOURCE_PATH = "../";
    public static final String BENCHMARK_RESOURCE_PATH = "../";
    public static final String TEST_RESOURCE_PATH = "src/test/resources/";

    private static ImmutableMap<String, Result> expectedResults;

    public static ImmutableMap<String, Result> getSVCOMPResults(String path) throws IOException {
		if(expectedResults == null){
			Set<String> ymlFiles = Files.walk(Paths.get(path))
	                .filter(Files::isRegularFile)
	                .map(Path::toString)
	                .filter(f -> f.endsWith("yml"))
					.collect(Collectors.toSet());
			HashMap<String, Result> data = new HashMap<>();
			for(String s : ymlFiles) {
				data.put(s.substring(0, s.lastIndexOf('.')) + ".i", Files.readAllLines(Paths.get(s)).stream().collect(Collectors.joining()).contains("expected_verdict: true") ? PASS : FAIL);
			}
			expectedResults = ImmutableMap.copyOf(data);
		}
        return expectedResults;
	}
}
