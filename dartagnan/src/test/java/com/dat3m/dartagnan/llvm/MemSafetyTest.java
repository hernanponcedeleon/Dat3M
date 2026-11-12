package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.task.Task;
import com.dat3m.dartagnan.task.verification.VerificationStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.IMM;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.FAIL;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.PASS;

@RunWith(Parameterized.class)
public class MemSafetyTest extends AbstractCTest {

    private final int bound;
    private final boolean safeAllocs;

    public MemSafetyTest(String name, Arch target, VerificationStatus expected, int bound, boolean safeAllocs) {
        super(name, target, expected);
        this.bound = bound;
        this.safeAllocs = safeAllocs;
    }

    @Override
    protected String getProgramPathString() { return "mem-safety/%s.ll"; }

    @Override
    protected int getBound() { return bound; }

    @Override
    protected long getTimeoutSeconds() { return 60; }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return super.getTaskBuilder()
                .withOption(OptionNames.MEMORY_BOUNDS_CHECKS, "true")
                .withOption(OptionNames.SAFE_ALLOCATIONS, String.valueOf(safeAllocs));
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}, safeAllocs={4}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"memory-bounds", IMM, PASS, 5, true},
                {"memory-bounds_f", IMM, FAIL, 6, true},
                {"memory-bounds-single-heap", IMM, PASS, 1, true},
                {"memory-bounds-single-heap_f", IMM, FAIL, 1, true},
                {"memory-bounds-single-global", IMM, PASS, 1, true},
                {"memory-bounds-single-global_f", IMM, FAIL, 1, true},
                {"memory-bounds-phi", IMM, PASS, 1, true},
                {"memory-bounds-phi_f", IMM, FAIL, 1, true},
                {"memory-bounds-select", IMM, PASS, 1, true},
                {"memory-bounds-select_f", IMM, FAIL, 1, true},
                {"memory-bounds-unknown-size", IMM, PASS, 1, true},
                {"memory-bounds-unknown-size_f", IMM, FAIL, 1, true},
                {"memory-bounds-wraparound", IMM, PASS, 1, true},
                {"memory-bounds-wraparound_f", IMM, FAIL, 1, true},
                {"ilp32-malloc-wraparound", IMM, PASS, 1, false},
                {"ilp32-malloc-wraparound_f", IMM, FAIL, 1, false},
                {"ilp32-malloc-wraparound", IMM, PASS, 1, true},
                {"ilp32-malloc-wraparound_f", IMM, PASS, 1, true},
                // TODO: The following accesses are not instrumented yet, so their violations are missed.
                // Accesses with an empty set of addressable objects are skipped.
                // {"memory-bounds-uninit-pointer", IMM, FAIL, 1, true},
                // {"memory-bounds-const-address", IMM, FAIL, 1, true},
        });
    }
}
