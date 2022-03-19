package com.dat3m.dartagnan;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import static com.dat3m.dartagnan.utils.Result.*;

@RunWith(Parameterized.class)
public class GraphsGenmc extends AbstractExternalTool {

    public GraphsGenmc(String name, Result expected) {
        super(name, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> System.getenv("DAT3M_HOME") + "/benchmarks/" + name + ".c");
    }

    @Override
    protected long getTimeout() {
        return 900000;
    }

	@Override
	protected Provider<String> getToolCmdProvider() {
		return Provider.fromSupplier(() -> "genmc");
	}

	@Override
	protected Provider<List<String>> getToolOptionsProvider() {
		return Provider.fromSupplier(() -> Arrays.asList("-imm", "-unroll=2"));
	}

	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
		return Arrays.asList(new Object[][]{
            {"locks/ttas-5", UNKNOWN},
            {"locks/ticketlock-6", PASS},
            {"locks/mutex-4", UNKNOWN},
            {"locks/spinlock-5", UNKNOWN},
            {"locks/linuxrwlock-3", UNKNOWN},
            {"locks/mutex_musl-4", UNKNOWN},
            {"lfds/safestack-3", FAIL},
            {"lfds/dglm-3", UNKNOWN},
            {"lfds/ms-3", UNKNOWN},
            {"lfds/treiber-3", UNKNOWN}
		});
    }

	@Test
	@CSVLogger.FileName("csv/genmc")
	public void test() throws Exception {
		// We need this to keep all csv files with a different name
		runTool();
	}
}