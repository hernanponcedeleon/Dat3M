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

    public MemSafetyTest(String name, Arch target, VerificationStatus expected, int bound) {
        super(name, target, expected);
        this.bound = bound;
    }

    @Override
    protected String getProgramPathString() { return "mem-safety/%s.ll"; }

    @Override
    protected int getBound() { return bound; }

    @Override
    protected long getTimeoutSeconds() { return 60; }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return super.getTaskBuilder().withOption(OptionNames.MEMORY_BOUNDS_CHECKS, "true");
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"memory-bounds", IMM, PASS, 5},
                {"memory-bounds_f", IMM, FAIL, 6},
                {"memory-bounds-single-heap", IMM, PASS, 1},
                {"memory-bounds-single-heap_f", IMM, FAIL, 1},
                {"memory-bounds-single-global", IMM, PASS, 1},
                {"memory-bounds-single-global_f", IMM, FAIL, 1},
                {"memory-bounds-phi", IMM, PASS, 1},
                {"memory-bounds-phi_f", IMM, FAIL, 1},
                {"memory-bounds-select", IMM, PASS, 1},
                {"memory-bounds-select_f", IMM, FAIL, 1},
                {"memory-bounds-unknown-size", IMM, PASS, 1},
                {"memory-bounds-unknown-size_f", IMM, FAIL, 1},
                {"memory-bounds-wraparound", IMM, PASS, 1},
                {"memory-bounds-wraparound_f", IMM, FAIL, 1},
                {"ilp32-malloc-wraparound", IMM, PASS, 1},
                {"ilp32-malloc-wraparound_f", IMM, FAIL, 1},
                {"ilp32-malloc-too-large", IMM, PASS, 1},
                {"ilp32-malloc-too-large_f", IMM, FAIL, 1},
                {"ilp32-malloc-not-executed", IMM, PASS, 1},
                {"ilp32-malloc-not-executed_f", IMM, FAIL, 1},
                // TODO: The following accesses are not instrumented yet, so their violations are missed.
                // Accesses with an empty set of addressable objects are skipped.
                // {"memory-bounds-uninit-pointer", IMM, FAIL, 1},
                // {"memory-bounds-const-address", IMM, FAIL, 1},
        });
    }
}
