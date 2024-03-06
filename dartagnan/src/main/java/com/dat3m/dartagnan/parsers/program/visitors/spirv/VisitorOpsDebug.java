package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;

import java.util.Set;

public class VisitorOpsDebug extends SpirvBaseVisitor<Void> {

    public VisitorOpsDebug(ProgramBuilderSpv builder) {
        // Nothing to do for debug operations
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpSource",
                "OpSourceContinued",
                "OpSourceExtension",
                "OpName",
                "OpMemberName",
                "OpString",
                "OpLine",
                "OpNoLine",
                "OpModuleProcessed"
        );
    }
}
