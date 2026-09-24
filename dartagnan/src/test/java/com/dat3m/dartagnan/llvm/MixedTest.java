package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.Task;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.ARM8;
import static com.dat3m.dartagnan.configuration.OptionNames.MIXED_SIZE;
import static com.dat3m.dartagnan.verification.ResultStatus.FAIL;
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

@RunWith(Parameterized.class)
public class MixedTest extends AbstractCTest {

    public MixedTest(String name, Arch target, ResultStatus expected) {
        super(name, target, expected);
    }

    @Override
    protected String getProgramPathString() { return "mixed/%s.ll"; }

    @Override
    protected int getBound() { return 3; }

    @Override
    protected long getTimeoutSeconds() { return 180; }

    @Override
    protected EnumSet<Property> getTestedProperties() {
        return EnumSet.of(name.startsWith("memtrack") ? Property.TRACKABILITY : Property.PROGRAM_SPEC);
    }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return super.getTaskBuilder().withOption(MIXED_SIZE, "true");
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
            {"lockref1", ARM8, PASS},
            {"lockref2", ARM8, PASS},
            {"lockref-seq", ARM8, PASS},
            {"lockref-par1", ARM8, FAIL},
            {"lockref-par2", ARM8, PASS},
            {"lockref-par3", ARM8, FAIL},
            {"memtrack1-fail", ARM8, FAIL},
            {"memtrack2-pass", ARM8, PASS},
            {"memtrack3-pass", ARM8, PASS},
            {"mixed-local1", ARM8, PASS},
            {"mixed-local2", ARM8, FAIL},
            {"store-to-load-forwarding1", ARM8, PASS}, // FAIL on the older version of aarch64.cat
            {"floats_msa_1", ARM8, PASS},
            {"floats_msa_2", ARM8, PASS},
        });
    }
}