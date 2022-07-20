package com.dat3m.dartagnan.benchmarking.litmus;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

@RunWith(Parameterized.class)
public class HerdAARCH64 extends AbstractHerd {

	@Parameterized.Parameters(name = "{index}: {0} {1}")
    public static Iterable<Object[]> data() throws IOException {
		return buildParameters("litmus/AARCH64/", "ARM8");
    }
    
    public HerdAARCH64(String name, Result expected) {
        super(name, expected);
    }
    
	@Override
	protected Provider<List<String>> getToolOptionsProvider() {
		return Provider.fromSupplier(() -> Arrays.asList("-model", System.getenv("DAT3M_HOME") + "/cat/aarch64.cat"));
	}
}