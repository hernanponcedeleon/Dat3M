package com.dat3m.dartagnan.utils;

import com.google.common.collect.ImmutableMap;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Set;
import java.util.stream.Collectors;

public class ResourceHelper {

    public static final String CAT_RESOURCE_PATH = "../";
    public static final String BENCHMARK_RESOURCE_PATH = "../";
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
