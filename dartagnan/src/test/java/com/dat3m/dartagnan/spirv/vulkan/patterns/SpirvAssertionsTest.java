package com.dat3m.dartagnan.spirv.vulkan.patterns;

import com.dat3m.dartagnan.spirv.vulkan.AbstractSpirvVulkanTest;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.Task;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.OptionNames.IGNORE_FILTER_SPECIFICATION;
import static com.dat3m.dartagnan.verification.ResultStatus.FAIL;
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

@RunWith(Parameterized.class)
public class SpirvAssertionsTest extends AbstractSpirvVulkanTest {

    public SpirvAssertionsTest(String file, ResultStatus expected) {
        super("spirv/vulkan/patterns/" + file, 1, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"corr.spvasm", PASS},
                {"iriw.spvasm", PASS},
                {"mp.spvasm", PASS},
                {"mp-acq2rx.spvasm", FAIL},
                {"mp-rel2rx.spvasm", FAIL},
                {"sb.spvasm", PASS},
        });
    }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return super.getTaskBuilder().withOption(IGNORE_FILTER_SPECIFICATION, "true");
    }
}
