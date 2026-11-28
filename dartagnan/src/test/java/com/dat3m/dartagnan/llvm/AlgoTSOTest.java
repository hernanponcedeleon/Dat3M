package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.task.verification.VerificationStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.TSO;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.*;

@RunWith(Parameterized.class)
public class AlgoTSOTest extends AbstractAlgoTest {

    public AlgoTSOTest(String name, int bound, VerificationStatus expected, boolean lazyEnabled) {
        super(name, TSO, bound, expected, lazyEnabled);
    }

    @Parameterized.Parameters(name = "{index}: {0}, bound={1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(
                task("locks/ttas", 3, PASS),
                task("locks/ttas-acq2rx", 3, PASS),
                task("locks/ttas-rel2rx", 3, PASS),
                task("locks/ticketlock", 1, PASS),
                task("locks/ticketlock-acq2rx", 1, PASS),
                task("locks/ticketlock-rel2rx", 1, PASS),
                task("locks/mutex", 3, PASS),
                task("locks/mutex-acq2rx_futex", 3, PASS),
                task("locks/mutex-acq2rx_lock", 3, PASS),
                task("locks/mutex-rel2rx_futex", 3, PASS),
                task("locks/mutex-rel2rx_unlock", 3, PASS),
                task("locks/spinlock", 1, PASS),
                task("locks/spinlock-acq2rx", 1, PASS),
                task("locks/spinlock-rel2rx", 1, PASS),
                task("locks/linuxrwlock", 4, PASS),
                eagerOnly("locks/linuxrwlock-acq2rx", 4, PASS),
                task("locks/linuxrwlock-rel2rx", 4, PASS),
                eagerOnly("locks/linuxrwlock-vmm", 4, PASS),
                task("locks/mutex_musl", 6, PASS),
                task("locks/mutex_musl-acq2rx_futex", 6, PASS),
                task("locks/mutex_musl-acq2rx_lock", 6, PASS),
                task("locks/mutex_musl-rel2rx_futex", 6, PASS),
                task("locks/mutex_musl-rel2rx_unlock", 6, PASS),
                task("locks/seqlock", 1, PASS),
                task("locks/clh_mutex", 1, PASS),
                task("locks/clh_mutex-acq2rx", 1, PASS),
                task("locks/ticket_awnsb_mutex", 1, PASS),
                task("locks/ticket_awnsb_mutex-acq2rx", 1, PASS),
                task("locks/pthread_mutex", 1, PASS),
                task("locks/brgpk", 3, PASS),
                task("locks/brgpk-fail", 1, FAIL),
                task("lfds/dglm", 3, PASS),
                task("lfds/dglm-CAS-relaxed", 3, PASS),
                task("lfds/ms", 3, PASS),
                task("lfds/ms-CAS-relaxed", 3, PASS),
                task("lfds/treiber", 5, PASS),
                task("lfds/treiber-CAS-relaxed", 5, PASS),
                task("lfds/chase-lev", 1, PASS),
                task("lfds/chase-lev-fail", 1, FAIL),
                eagerOnly("lfds/safe_stack", 2, FAIL),
                task("lfds/hash_table", 1, PASS),
                task("lfds/hash_table-fail", 1, PASS),
                task("lfds/wsq", 5, PASS),
                task("lfds/wsq-fail", 1, FAIL)
        );
    }
}
