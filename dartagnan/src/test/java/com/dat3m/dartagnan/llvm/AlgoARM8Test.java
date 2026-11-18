package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.task.verification.VerificationStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.ARM8;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.*;

@RunWith(Parameterized.class)
public class AlgoARM8Test extends AbstractAlgoTest {

    public AlgoARM8Test(String name, int bound, VerificationStatus expected, boolean lazyEnabled) {
        super(name, ARM8, bound, expected, lazyEnabled);
    }

    @Parameterized.Parameters(name = "{index}: {0}, bound={1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(
                task("locks/ttas", 3, PASS),
                task("locks/ttas-acq2rx", 1, FAIL),
                task("locks/ttas-rel2rx", 1, FAIL),
                task("locks/ticketlock", 1, PASS),
                task("locks/ticketlock-acq2rx", 1, FAIL),
                task("locks/ticketlock-rel2rx", 1, FAIL),
                task("locks/mutex", 3, PASS),
                task("locks/mutex-acq2rx_futex", 1, FAIL),
                task("locks/mutex-acq2rx_lock", 1, FAIL),
                task("locks/mutex-rel2rx_futex", 1, FAIL),
                task("locks/mutex-rel2rx_unlock", 1, FAIL),
                task("locks/spinlock", 1, PASS),
                task("locks/spinlock-acq2rx", 1, FAIL),
                task("locks/spinlock-rel2rx", 1, FAIL),
                eagerOnly("locks/linuxrwlock", 4, PASS),
                task("locks/linuxrwlock-acq2rx", 1, FAIL),
                task("locks/linuxrwlock-rel2rx", 1, FAIL),
                eagerOnly("locks/linuxrwlock-vmm", 4, PASS),
                task("locks/mutex_musl", 6, PASS),
                task("locks/mutex_musl-acq2rx_futex", 2, FAIL),
                task("locks/mutex_musl-acq2rx_lock", 1, FAIL),
                task("locks/mutex_musl-rel2rx_futex", 2, FAIL),
                task("locks/mutex_musl-rel2rx_unlock", 1, FAIL),
                task("locks/seqlock", 1, PASS),
                task("locks/clh_mutex", 1, PASS),
                task("locks/clh_mutex-acq2rx", 1, FAIL),
                task("locks/ticket_awnsb_mutex", 1, PASS),
                task("locks/ticket_awnsb_mutex-acq2rx", 1, FAIL),
                task("locks/pthread_mutex", 1, PASS),
                task("locks/brgpk", 4, PASS),
                task("locks/brgpk-fail", 1, FAIL),
                task("lfds/dglm", 3, PASS),
                task("lfds/dglm-CAS-relaxed", 1, FAIL),
                task("lfds/ms", 3, PASS),
                task("lfds/ms-CAS-relaxed", 1, FAIL),
                task("lfds/treiber", 5, PASS),
                task("lfds/treiber-CAS-relaxed", 1, FAIL),
                task("lfds/chase-lev", 1, PASS),
                task("lfds/chase-lev-fail", 1, FAIL),
                eagerOnly("lfds/safe_stack", 2, FAIL),
                task("lfds/hash_table", 1, PASS),
                task("lfds/hash_table-fail", 1, FAIL)
        );
    }
}
