package com.dat3m.dartagnan.benchmarking.litmus;

import com.dat3m.dartagnan.benchmarking.AbstractExternalTool;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Map;
import java.util.stream.Stream;

import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

@RunWith(Parameterized.class)
public abstract class AbstractHerd extends AbstractExternalTool {

	static Iterable<Object[]> buildParameters(String litmusPath, String arch) throws IOException {
    	int n = ResourceHelper.LITMUS_RESOURCE_PATH.length();
        Map<String, Result> expectationMap = ResourceHelper.getExpectedResults(arch);

        try (Stream<Path> fileStream = Files.walk(Paths.get(ResourceHelper.LITMUS_RESOURCE_PATH + litmusPath))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .map(Path::toString)
                    .filter(f -> f.endsWith("litmus"))
                    .filter(f -> expectationMap.containsKey(f.substring(n)))
                    .collect(ArrayList::new,
                            (l, f) -> l.add(new Object[]{f, expectationMap.get(f.substring(n))}), ArrayList::addAll);
        }
    }
	
    public AbstractHerd(String name, Result expected) {
        super(name, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> name);
    }

	@Override
    protected long getTimeout() {
		return 10000;
	}

	@Override
	protected Provider<String> getToolCmdProvider() {
		return Provider.fromSupplier(() -> "herd7");
	}

	@Override
	protected Result getResult(String output) {
		return output.contains("Ok") ? FAIL : PASS;
	}
}