package com.dat3m.dartagnan;

import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;

@RunWith(Parameterized.class)
public class SvCompControlFlowTest extends AbstractSvCompTest {

    public SvCompControlFlowTest(String name, int bound) {
        super(name, bound);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> TEST_RESOURCE_PATH + "boogie/cf/" + name + "-O3.bpl");
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "sc");
    }

    @Parameterized.Parameters(name = "{index}: {0}, bound={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][] {
                {"test_locks_5", 1},
                {"test_locks_6", 1},
                {"test_locks_7", 1},
                {"test_locks_8", 1},
                {"test_locks_9", 1},
                {"test_locks_10", 1},
                {"test_locks_11", 1},
                {"test_locks_12", 1},
                {"test_locks_13", 1},
                {"test_locks_14-1", 1},
                {"test_locks_14-2", 1},
                {"test_locks_15-1", 1},
                {"test_locks_15-2", 1}
        });

    }

}