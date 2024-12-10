package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.C11;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class AllocFreeTest extends AbstractCTest {

    public AllocFreeTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"test1_ok_1", C11, PASS},
                {"test1_ok_2", C11, PASS},
                {"test1_err_address", C11, FAIL},
                {"test1_err_race", C11, FAIL},
                {"test1_err_double_free_1", C11, FAIL},
                {"test1_err_double_free_2", C11, FAIL},
                {"test1_err_no_free", C11, FAIL},
                {"test1_err_no_alloc_1", C11, FAIL},
                {"test1_err_no_alloc_2", C11, FAIL},
                {"test1_err_use_before_alloc", C11, FAIL},
                {"test1_err_use_after_free", C11, FAIL},
        });
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return () -> getTestResourcePath("alloc/" + name + ".ll");
    }

    @Override
    protected long getTimeout() {
        return 60000;
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "rc11");
    }

    @Override
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return Provider.fromSupplier(() -> EnumSet.of(Property.CAT_SPEC));
    }

    @Test
    public void testAssume() throws Exception {
        AssumeSolver s = AssumeSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }

    // TODO: Implement missing definitions (domain)
    //@Test
    public void testRefinement() throws Exception {
        RefinementSolver s = RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }
}