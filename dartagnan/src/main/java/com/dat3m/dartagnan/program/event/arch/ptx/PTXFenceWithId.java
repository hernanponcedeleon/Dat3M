package com.dat3m.dartagnan.program.event.arch.ptx;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;

import java.util.HashSet;
import java.util.Set;

public class PTXFenceWithId extends Fence implements RegReader {
    private Expression fenceID;

    public PTXFenceWithId(String name, Expression fenceID) {
        super(name);
        this.fenceID = fenceID;
    }

    public Expression getFenceID() {
        return fenceID;
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.fenceID = fenceID.visit(exprTransformer);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(fenceID, Register.UsageType.OTHER, new HashSet<>());
    }
}
