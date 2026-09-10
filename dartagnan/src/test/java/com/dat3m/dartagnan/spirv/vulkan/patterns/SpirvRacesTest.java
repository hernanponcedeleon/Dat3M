package com.dat3m.dartagnan.spirv.vulkan.patterns;

import com.dat3m.dartagnan.configuration.Property;
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
public class SpirvRacesTest extends AbstractSpirvVulkanTest {

    private final boolean filter;

    public SpirvRacesTest(String file, boolean filter, ResultStatus expected) {
        super("spirv/vulkan/patterns/" + file, 1, expected);
        this.filter = filter;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"corr.spvasm", false, PASS},
                {"iriw.spvasm", false, PASS},
                {"sb.spvasm", false, PASS},

                {"mp.spvasm", false, FAIL},
                {"mp.spvasm", true, PASS},
                {"mp-acq2rx.spvasm", false, FAIL},
                {"mp-acq2rx.spvasm", true, FAIL},
                {"mp-rel2rx.spvasm", false, FAIL},
                {"mp-rel2rx.spvasm", true, FAIL},
        });
    }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return super.getTaskBuilder().withOption(IGNORE_FILTER_SPECIFICATION, Boolean.toString(!filter));
    }

    @Override
    protected Property getTestedProperty() { return Property.CAT_SPEC; }
}