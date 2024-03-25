package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.program.event.Event;

import java.util.Set;

public class VisitorOpsBarrier extends SpirvBaseVisitor<Event> {

    private final ProgramBuilderSpv builder;

    public VisitorOpsBarrier(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    // TODO: Implementation

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpControlBarrier"
        );
    }
}
