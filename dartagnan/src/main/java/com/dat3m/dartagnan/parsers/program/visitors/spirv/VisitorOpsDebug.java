package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

import java.util.Set;

public class VisitorOpsDebug extends SpirvBaseVisitor<Void> {

    public VisitorOpsDebug(ProgramBuilder builder) {
        // TODO: Implement mapping to original variable names
        //  and lines of code (readability for human users)
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
