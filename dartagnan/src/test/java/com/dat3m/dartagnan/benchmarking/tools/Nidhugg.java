package com.dat3m.dartagnan.benchmarking.tools;

import com.dat3m.dartagnan.benchmarking.AbstractExternalTool;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import static com.dat3m.dartagnan.utils.Result.*;

@RunWith(Parameterized.class)
public class Nidhugg extends AbstractExternalTool {

    public Nidhugg(String name, Result expected) {
        super(name, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> System.getenv("DAT3M_HOME") + "/benchmarks/" + name + "-u.ll");
    }

	@Override
	protected Provider<String> getToolCmdProvider() {
		return Provider.fromSupplier(() -> "nidhugg");
	}

	@Override
	protected Provider<List<String>> getToolOptionsProvider() {
		return Provider.fromSupplier(() -> List.of("-tso"));
	}

	@Override
	protected void preExecutionCmds() throws Exception {
		String base = System.getenv("DAT3M_HOME") + "/benchmarks/" + name;
		String source = base + ".c";
		String target = base + ".ll";
		String unrolled = base + "-u.ll";
		// Compiler to LLVM
		List<String> cmd = Arrays.asList("clang", "-emit-llvm", "-S", "-o", target, source);
		ProcessBuilder pb = new ProcessBuilder(cmd);
		Process proc = pb.start();
		proc.waitFor();
		// Unroll
		cmd = Arrays.asList("nidhugg", "--unroll=2", "--transform=" + unrolled, target);
		pb = new ProcessBuilder(cmd);
		proc = pb.start();
		proc.waitFor();
	}
    
	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
		return Arrays.asList(new Object[][]{
            {"locks/ttas-5", PASS},
            {"locks/ticketlock-6", PASS},
            {"locks/mutex-4", PASS},
            {"locks/spinlock-5", PASS},
            {"locks/linuxrwlock-3", PASS},
            {"locks/mutex_musl-4", PASS},
            {"lfds/safestack-3", FAIL},
            {"lfds/chase-lev-5", PASS},
            {"lfds/dglm-3", PASS},
            {"lfds/harris-3", PASS},
            {"lfds/ms-3", PASS},
            {"lfds/treiber-3", PASS}
		});
    }

    @Override
	protected Result getResult(String output) {
		return output.contains("No errors were detected") ? PASS : FAIL;
	}
}