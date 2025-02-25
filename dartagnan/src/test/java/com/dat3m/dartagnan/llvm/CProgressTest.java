package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.ProgressModel;
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
import static com.dat3m.dartagnan.configuration.ProgressModel.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class CProgressTest extends AbstractCTest {

    protected ProgressModel progressModel;

    public CProgressTest(String name, ProgressModel progressModel, Result expected) {
        super(name, C11, expected);
        this.progressModel = progressModel;
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return () -> getTestResourcePath("progress/" + name + ".ll");
    }

    @Override
    protected Provider<ProgressModel> getProgressModelProvider() {
        return () -> progressModel;
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "imm");
    }

    @Override
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return () -> EnumSet.of(Property.LIVENESS);
    }

    @Override
    protected long getTimeout() {
        return 10000;
    }

    @Parameterized.Parameters(name = "{index}: {0}, progress={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"progressFair", FAIR, PASS},
                {"progressFair", HSA, FAIL},
                {"progressFair", OBE, FAIL},
                {"progressFair", UNFAIR, FAIL},
                // ---------------------------
                {"progressHSA", FAIR, PASS},
                {"progressHSA", HSA, PASS},
                {"progressHSA", OBE, FAIL},
                {"progressHSA", UNFAIR, FAIL},
                // ---------------------------
                {"progressOBE", FAIR, PASS},
                {"progressOBE", HSA, FAIL},
                {"progressOBE", OBE, PASS},
                {"progressOBE", UNFAIR, FAIL},
                // ---------------------------
                {"progressOBE-HSA", FAIR, PASS},
                {"progressOBE-HSA", HSA, PASS},
                {"progressOBE-HSA", OBE, PASS},
                {"progressOBE-HSA", UNFAIR, FAIL},
                // ---------------------------
                {"progressUnfair", FAIR, PASS},
                {"progressUnfair", HSA, PASS},
                {"progressUnfair", OBE, PASS},
                {"progressUnfair", UNFAIR, PASS},
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