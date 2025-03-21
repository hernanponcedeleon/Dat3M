package com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions;

import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;

import java.util.Set;

public abstract class VisitorExtension<T> extends SpirvBaseVisitor<T> {

    public abstract Set<String> getSupportedInstructions();
}
