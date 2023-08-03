package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.ArrayList;

import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class LLVMTest extends AbstractCTest {

    private static final String LFDS_CHASELEV = "chase-lev";
    private static final String LFDS_DGLM = "dglm";
    private static final String LFDS_HASHTABLE = "hash_table";
    private static final String LFDS_MICHAELSCOTT = "ms";
    private static final String LFDS_SAFESTACK = "safe_stack";
    private static final String LFDS_TREIBER = "treiber";
    private static final String LFDS_WSQ = "wsq";
    private static final String LOCK_CLH = "clh_mutex";
    private static final String LOCK_CNA = "cna";
    private static final String LOCK_LINUXRW = "linuxrwlock";
    private static final String LOCK_MUTEX = "mutex";
    private static final String LOCK_MUSL = "mutex_musl";
    private static final String LOCK_PTHREAD = "pthread_mutex";
    private static final String LOCK_SPIN = "spinlock";
    private static final String LOCK_SEQ = "seqlock";
    private static final String LOCK_TICKET = "ticket_lock";
    private static final String LOCK_AWNSB = "ticket_awnsb_mutex";
    private static final String LOCK_TTAS = "ttas";
    private static final String[] allNames = {
            LFDS_CHASELEV,
            LFDS_DGLM,
            //LFDS_HASHTABLE,
            LFDS_MICHAELSCOTT,
            LFDS_SAFESTACK,
            LFDS_TREIBER,
            LFDS_WSQ,
            LOCK_CLH,
            LOCK_CNA,
            LOCK_LINUXRW,
            LOCK_MUTEX,
            LOCK_MUSL,
            //LOCK_PTHREAD,
            LOCK_SPIN,
            //LOCK_SEQ,
            //LOCK_TICKET,
            LOCK_AWNSB,
            LOCK_TTAS};
    private static final Arch[] allArchs = {
            Arch.TSO,
            Arch.ARM8,
            Arch.POWER,
            Arch.RISCV};

    public LLVMTest(String name, Arch target) {
        super(name, target, getExpectedResult(name));
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> "../benchmarks/llvm/" + name + ".ll");
    }

    @Override
    protected long getTimeout() {
        return 120000;
    }

    protected Provider<Integer> getBoundProvider() {
        int bound = name == null ? 1 : switch (name) {
            case LFDS_CHASELEV, LFDS_DGLM, LFDS_HASHTABLE, LFDS_MICHAELSCOTT, LFDS_SAFESTACK, LFDS_TREIBER, LFDS_WSQ -> 2;
            default -> 1;
        };
        return Provider.fromSupplier(() -> bound);
    }

    //@Test
    @CSVLogger.FileName("csv/assume")
    public void testAssume() throws Exception {
        AssumeSolver s = AssumeSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }

    @Test
    @CSVLogger.FileName("csv/refinement")
    public void testRefinement() throws Exception {
        RefinementSolver s = RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }

    private static Result getExpectedResult(String name) {
        return switch (name) {
            case LFDS_DGLM, LFDS_MICHAELSCOTT, LFDS_TREIBER, LFDS_WSQ, LOCK_CLH, LOCK_CNA, LOCK_LINUXRW, LOCK_MUSL, LOCK_MUTEX,
                    LOCK_TTAS -> Result.UNKNOWN;
            case LFDS_SAFESTACK -> Result.FAIL;
            default -> Result.PASS;
        };
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        final var result = new ArrayList<Object[]>();
        for (final String name : allNames) {
            for (final Arch arch : allArchs) {
                result.add(new Object[]{name, arch});
            }
        }
        return result;
    }

}
