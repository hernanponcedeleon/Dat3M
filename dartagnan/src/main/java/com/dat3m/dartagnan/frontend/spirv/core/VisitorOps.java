package com.dat3m.dartagnan.frontend.spirv.core;

import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;

import java.util.Set;

public abstract class VisitorOps<T> extends SpirvBaseVisitor<T> {

    public abstract Set<String> getSupportedOps();
}
