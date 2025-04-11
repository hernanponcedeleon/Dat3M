package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.C11;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class VMMInterruptsLivenessTest extends AbstractCTest {

    public VMMInterruptsLivenessTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> getTestResourcePath("interrupts/nonterm/" + name + ".ll"));
    }

    @Override
    protected long getTimeout() {
        return 60000;
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Provider.fromSupplier(() -> new ParserCat().parse(new File(getRootPath("cat/vmm-interrupts-alt.cat"))));
    }

    @Override
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return () -> EnumSet.of(Property.TERMINATION);
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"nonterm_nested_ih", C11, FAIL},
                {"nonterm_reorder_barrier", C11, PASS},
                {"nonterm_reorder_simple", C11, FAIL},
                {"nonterm_reorder", C11, FAIL},
                {"nonterm_simple", C11, FAIL},
                {"nonterm_simple_two-threads", C11, FAIL},
                {"nonterm_simple_disable", C11, PASS},
                {"nonterm-multiple-threads", C11, FAIL},
        });
    }

    @Test
    public void testAssume() throws Exception {
        AssumeSolver s = AssumeSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }

    @Test
    public void testRefinement() throws Exception {
        RefinementSolver s = RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }
}