package com.dat3m.dartagnan.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;

import java.io.IOException;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.OptionNames.C_TO_POWER_SCHEME;
import static com.dat3m.dartagnan.configuration.OptionNames.INITIALIZE_REGISTERS;
import static com.dat3m.dartagnan.program.processing.compilation.VisitorPower.PowerScheme.TRAILING_SYNC;

@RunWith(Parameterized.class)
public class C11ToPPCTest extends AbstractCompilationTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/C11/");
    }

    public C11ToPPCTest(String path) {
        super(path);
    }

	@Override
	protected Provider<Arch> getSourceProvider() {
		return () -> Arch.C11;
	}

    @Override
    protected Provider<Wmm> getSourceWmmProvider() {
        return Providers.createWmmFromName(() -> "c11");
    }

	@Override
	protected Provider<Arch> getTargetProvider() {
		return () -> Arch.POWER;
	}

	@Override
	protected List<String> getCompilationBreakers() {
		return Stream.of(
				"manual/IRIW-sc-sc-acq-sc-acq-sc",
				"manual/RWC-sc-acq-sc-sc-sc")
				.map(p -> ResourceHelper.LITMUS_RESOURCE_PATH + "litmus/C11/" + p + ".litmus")
				.map(p -> Path.of(p).toString())
				.collect(Collectors.toList());
	}

    protected Provider<Configuration> getConfigurationProvider() {
		return Provider.fromSupplier(() -> Configuration.builder().
				setOption(INITIALIZE_REGISTERS, String.valueOf(true)).
				setOption(C_TO_POWER_SCHEME, String.valueOf(TRAILING_SYNC)).
				build());
    }
}