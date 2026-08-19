package com.dat3m.dartagnan.asm.armv8.libvsync;

import com.dat3m.dartagnan.asm.AbstractAsmTest;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

@RunWith(Parameterized.class)
public class AsmLibvsyncArmv8Test extends AbstractAsmTest {

    public AsmLibvsyncArmv8Test (String file, int bound, ResultStatus expected) {
        super(Arch.ARM8, "asm/armv8/libvsync/" + file, bound, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
            //bounded_queue
            {"bounded_spsc", 1, PASS},
            {"bounded_mpmc_check_full", 3, PASS},
            {"bounded_mpmc_check_empty", 4, PASS},

            //spinlocks
            // {"caslock", 4, PASS}, // passes Refinement but takes ~10 minutes
            {"clhlock", 3, PASS},
            // {"cnalock", 5, PASS}, // takes 35 minutes
            {"hemlock", 3, PASS},
            {"mcslock", 3, PASS},
            {"rec_mcslock", 3, PASS},
            // {"rec_seqlock", 3, PASS}, // 25 min to pass
            {"rec_spinlock", 3, PASS},
            {"rwlock", 3, PASS},
            {"semaphore", 3, PASS},
            {"seqcount", 1, PASS},
            {"seqlock", 3, PASS},
            {"ttaslock", 3, PASS},
            {"twalock", 2, PASS},

            //threads
            {"mutex_musl", 3, PASS},
            {"mutex_slim", 2, PASS},
            {"mutex_waiters", 3, PASS},
            {"once", 2, PASS}
        });
    }
}
