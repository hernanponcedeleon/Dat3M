package com.dat3m.dartagnan.benchmarking.litmus;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

@RunWith(Parameterized.class)
public class HerdLinux extends AbstractHerd {

	@Parameterized.Parameters(name = "{index}: {0} {1}")
    public static Iterable<Object[]> data() throws IOException {
		return buildParameters("litmus/LKMM/", "LKMM-NDR");
    }
    
    public HerdLinux(String name, Result expected) {
        super(name, expected);
    }
    
	@Override
	protected Provider<List<String>> getToolOptionsProvider() {
		return Provider.fromSupplier(() -> {
			String dat3m = System.getenv("DAT3M_HOME");
			return Arrays.asList("-model", dat3m + "/cat/lkmm-no-data-race.cat",
								"-I", dat3m + "/cat/",
								"-macros", dat3m + "/cat/linux-kernel.def", 
								"-bell", dat3m + "/cat/linux-kernel.bell");
		});
	}
}