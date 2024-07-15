package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.utils.ProgramBuilder;

import java.util.Set;

public class VisitorOpsDebug extends SpirvBaseVisitor<Void> {

    public VisitorOpsDebug(ProgramBuilder builder) {
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
