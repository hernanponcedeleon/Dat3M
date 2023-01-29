package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;

@RunWith(Parameterized.class)
public class SvCompTestLarge extends AbstractSvCompTest {

    public SvCompTestLarge(String name, int bound) {
        super(name, bound);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> TEST_RESOURCE_PATH + "large/" + name + "-O0.bpl");
    }

    @Parameterized.Parameters(name = "{index}: {0} bound={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"mix000_power.opt", 1},
                {"mix000_pso.opt", 1},
                {"mix000_rmo.opt", 1},
                {"mix000_tso.opt", 1},

                {"mix003_power.opt", 1},
                {"mix003_pso.opt", 1},
                {"mix003_rmo.opt", 1},
                {"mix003_tso.opt", 1},

                {"podwr000_power.opt", 1},
                {"podwr000_pso.opt", 1},
                {"podwr000_rmo.opt", 1},
                {"podwr000_tso.opt", 1},

                {"podwr001_power.opt", 1},
                {"podwr001_pso.opt", 1},
                {"podwr001_rmo.opt", 1},
                {"podwr001_tso.opt", 1},

                {"safe000_power.opt", 1},
                {"safe000_pso.opt", 1},
                {"safe000_rmo.opt", 1},
                {"safe000_tso.opt", 1},

                {"safe030_power.opt", 1},
                {"safe030_pso.opt", 1},
                {"safe030_rmo.opt", 1},
                {"safe030_tso.opt", 1},

                {"rfi000_power.opt", 1},
                {"rfi000_pso.opt", 1},
                {"rfi000_rmo.opt", 1},
                {"rfi000_tso.opt", 1},

                {"rfi009_power.opt", 1},
                {"rfi009_pso.opt", 1},
                {"rfi009_rmo.opt", 1},
                {"rfi009_tso.opt", 1},

                {"thin000_power.opt", 1},
                {"thin000_pso.opt", 1},
                {"thin000_rmo.opt", 1},
                {"thin000_tso.opt", 1}
        });
    }

}