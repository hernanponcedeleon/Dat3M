package com.dat3m.dartagnan.spirv.opencl;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.spirv.AbstractSpirvTest;
import com.dat3m.dartagnan.task.verification.VerificationStatus;

abstract class AbstractSpirvOpenclTest extends AbstractSpirvTest {

    protected AbstractSpirvOpenclTest(String programPath, int bound, VerificationStatus expected) {
        super(Arch.OPENCL, programPath, bound, expected);
    }
}
