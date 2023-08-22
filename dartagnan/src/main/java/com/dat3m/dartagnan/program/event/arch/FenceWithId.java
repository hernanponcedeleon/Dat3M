package com.dat3m.dartagnan.program.event.arch;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.HashSet;
import java.util.Set;

public class FenceWithId extends GenericVisibleEvent implements RegReader {
    private Expression fenceID;

    public FenceWithId(String name, Expression fenceID) {
        super(name, Tag.FENCE);
        this.fenceID = fenceID;
    }

    private FenceWithId(FenceWithId other) {
        super(other);
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

    @Override
    public String defaultString() {
        return String.format("%s := fence_id[%s]", name, fenceID);
    }

    @Override
    public FenceWithId getCopy() {
        return new FenceWithId(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitFenceWithId(this);
    }
}
