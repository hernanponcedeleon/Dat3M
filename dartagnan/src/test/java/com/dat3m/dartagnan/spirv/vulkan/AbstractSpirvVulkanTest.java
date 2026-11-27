package com.dat3m.dartagnan.spirv.vulkan;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.spirv.AbstractSpirvTest;
import com.dat3m.dartagnan.task.verification.VerificationStatus;

import java.util.ArrayList;
import java.util.List;

abstract class AbstractSpirvVulkanTest extends AbstractSpirvTest {

    private static final List<String> MODELS = List.of("vulkan", "vulkan-new");

    protected static Iterable<Object[]> withModels(Object[][] rows) {
        final List<Object[]> out = new ArrayList<>(MODELS.size() * rows.length);
        for (String model : MODELS) {
            for (Object[] row : rows) {
                final Object[] expanded = new Object[row.length + 1];
                expanded[0] = model;
                System.arraycopy(row, 0, expanded, 1, row.length);
                out.add(expanded);
            }
        }
        return out;
    }

    protected AbstractSpirvVulkanTest(String model, String programPath, int bound, VerificationStatus expected) {
        super(Arch.VULKAN, model, programPath, bound, expected);
    }

    // Disabled because takes too long
    protected boolean isLazyMethodEnabled() { return false; }
}
