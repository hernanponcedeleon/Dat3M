package com.dat3m.dartagnan.benchmarking;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import static com.dat3m.dartagnan.utils.Result.*;

@RunWith(Parameterized.class)
public class GenmcLKMM extends AbstractExternalTool {

    public GenmcLKMM(String name, Result expected) {
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
		return Provider.fromSupplier(() -> Arrays.asList("-lkmm", "-unroll=2"));
	}

	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
		return Arrays.asList(new Object[][]{
            {"lkmm/lkmm-ttas-5", UNKNOWN},
            {"lkmm/lkmm-ticketlock-6", PASS},
            {"lkmm/lkmm-mutex-4", UNKNOWN},
            {"lkmm/lkmm-spinlock-5", UNKNOWN},
            {"lkmm/lkmm-linuxrwlock-3", UNKNOWN},
            {"lkmm/lkmm-mutex_musl-4", UNKNOWN},
//            {"lfds/safestack-3", FAIL},
//            {"lfds/dglm-3", UNKNOWN},
//            {"lfds/ms-3", UNKNOWN},
//            {"lfds/treiber-3", UNKNOWN}
		});
    }

	@Override
	protected Result getResult(String output) {
		return output.contains("No errors were detected") ? PASS : FAIL;
	}
}