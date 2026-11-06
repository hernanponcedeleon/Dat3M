package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.Task;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.IMM;
import static com.dat3m.dartagnan.verification.ResultStatus.*;

// Termination with program.processing.removeWriteOnlyMemory=true. LivenessTest holds the same programs without it.
@RunWith(Parameterized.class)
public class WriteOnlyMemoryLivenessTest extends AbstractCTest {

    public WriteOnlyMemoryLivenessTest(String name, Arch target, ResultStatus expected) {
        super(name, target, expected);
    }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return super.getTaskBuilder().withOption(OptionNames.REMOVE_WRITE_ONLY_MEMORY, "true");
    }

    @Override
    protected long getTimeoutSeconds() { return 60; }

    @Override
    protected int getBound() { return 2; }

    @Override
    protected EnumSet<Property> getTestedProperties() { return EnumSet.of(Property.TERMINATION); }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"nontermination/write_only_counter_starvation", IMM, FAIL},
                {"nontermination/write_only_counter_terminates", IMM, PASS},
                // The counter is read, so it is kept, and the loop is never fully unrolled.
                {"nontermination/read_counter_controls_loop", IMM, UNKNOWN},
        });
    }
}
