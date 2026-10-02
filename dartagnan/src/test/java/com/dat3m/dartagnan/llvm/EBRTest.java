package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.VerificationStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.*;
import static com.dat3m.dartagnan.verification.VerificationStatus.FAIL;
import static com.dat3m.dartagnan.verification.VerificationStatus.PASS;

@RunWith(Parameterized.class)
public class EBRTest extends AbstractCTest {

    public EBRTest(String name, Arch target, VerificationStatus expected) {
        super(name, target, expected);
    }

    @Override
    protected String getProgramPathString() {
        return "smr/%s.ll";
    }

    @Override
    protected long getTimeoutSeconds() { return target == POWER ? 300 : 180; }

    @Override
    protected Solvers getSolver() { return Solvers.YICES2; }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
            {"ck_ebr", IMM, FAIL},
            {"ck_ebr", ARM8, PASS},
            {"ck_ebr", POWER, PASS},
            {"ck_ebr", RISCV, PASS},
        });
    }
}