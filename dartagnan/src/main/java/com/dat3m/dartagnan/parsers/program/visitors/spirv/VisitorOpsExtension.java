package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;

import java.util.Set;

public class VisitorOpsExtension extends SpirvBaseVisitor<Void> {

    public VisitorOpsExtension(ProgramBuilderSpv builder) {
        // Nothing to do for debug operations
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpExtension",
                "OpExtInst"
        );
    }
}
