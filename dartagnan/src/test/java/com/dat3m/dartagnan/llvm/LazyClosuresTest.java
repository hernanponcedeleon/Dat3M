package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.task.Task;
import com.dat3m.dartagnan.task.verification.VerificationStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.*;
import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.*;

@RunWith(Parameterized.class)
public class LazyClosuresTest extends AbstractCTest {

    private final String wmmName;
    private final EnumSet<Property> properties;
    private final int bound;

    public LazyClosuresTest(String name, Arch target, String wmmName, EnumSet<Property> properties, int bound,
                            VerificationStatus expected) {
        super(name, target, expected);
        this.wmmName = wmmName;
        this.properties = properties;
        this.bound = bound;
    }

    @Override
    protected String getWmmName() { return wmmName; }

    @Override
    protected EnumSet<Property> getTestedProperties() { return properties; }

    @Override
    protected int getBound() { return bound; }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return super.getTaskBuilder().withOption(OptionNames.LAZY_CLOSURES, "true");
    }

    // Lazy closures only change the eager encoding
    @Override
    protected boolean isLazyMethodEnabled() { return false; }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}, wmm={2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                // Closures used by consistency axioms (power: hb*, com*, propbase*; rc11: hb, eco; imm: hb)
                {"lfds/dglm", POWER, null, EnumSet.of(PROGRAM_SPEC), 2, UNKNOWN},
                {"lfds/dglm-CAS-relaxed", POWER, null, EnumSet.of(PROGRAM_SPEC), 2, FAIL},
                {"lfds/chase-lev", C11, "rc11", EnumSet.of(PROGRAM_SPEC), 2, PASS},
                {"lfds/ms-CAS-relaxed", C11, "rc11", EnumSet.of(PROGRAM_SPEC), 2, FAIL},
                {"lfds/hash_table", IMM, null, EnumSet.of(PROGRAM_SPEC), 2, PASS},
                {"lfds/treiber-CAS-relaxed", IMM, null, EnumSet.of(PROGRAM_SPEC), 2, FAIL},
                // Closure used by the data race flags of vmm (hb+)
                {"miscellaneous/dataRaceWrites", C11, "vmm", EnumSet.of(CAT_SPEC), 1, FAIL},
                {"miscellaneous/dataRaceFreeChain", C11, "vmm", EnumSet.of(CAT_SPEC), 1, PASS},
                {"lfds/ms", C11, "vmm", EnumSet.of(CAT_SPEC), 2, UNKNOWN},
        });
    }
}
