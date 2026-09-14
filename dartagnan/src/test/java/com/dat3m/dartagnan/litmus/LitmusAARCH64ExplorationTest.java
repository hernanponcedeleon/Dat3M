package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.ConfigurationBuilder;

import java.io.IOException;
import java.nio.file.Path;

import static com.dat3m.dartagnan.configuration.OptionNames.MIXED_SIZE;

@RunWith(Parameterized.class)
public class LitmusAARCH64ExplorationTest extends AbstractLitmusExplorationTest {

    @Parameterized.Parameters(name = "{index}: {0}, states={1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusExplorationTests("litmus/AARCH64/", "ARM8");
    }

    public LitmusAARCH64ExplorationTest(Path path, int expectedStateCount) {
        super(path, expectedStateCount);
    }

    @Override
    protected Provider<Arch> getTargetProvider() {
        return () -> Arch.ARM8;
    }

    @Override
    protected ConfigurationBuilder additionalConfig(ConfigurationBuilder builder) {
        final boolean isMixedSize = Utils.containsSubpath(
                filePathProvider.get(),
                Path.of("litmus", "AARCH64", "mixed")
        );
        return builder.setOption(MIXED_SIZE, String.valueOf(isMixedSize));
    }
}
