package com.dat3m.dartagnan.spirv.vulkan;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.spirv.AbstractSpirvTest;
import com.dat3m.dartagnan.verification.ResultStatus;

abstract class AbstractSpirvVulkanTest extends AbstractSpirvTest {

    protected AbstractSpirvVulkanTest(String programPath, int bound, ResultStatus expected) {
        super(Arch.VULKAN, programPath, bound, expected);
    }
}
