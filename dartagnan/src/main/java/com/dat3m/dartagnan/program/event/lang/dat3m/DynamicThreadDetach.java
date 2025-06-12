package com.dat3m.dartagnan.program.event.lang.dat3m;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;

import java.util.HashSet;
import java.util.Set;

public final class DynamicThreadDetach extends AbstractEvent implements RegWriter, RegReader {

    private Register status;
    private Expression tid;

    public DynamicThreadDetach(Register statusRegister, Expression tidExpression) {
        this.status = statusRegister;
        this.tid = tidExpression;
    }

    private DynamicThreadDetach(DynamicThreadDetach copy) {
        super(copy);
        this.status = copy.status;
        this.tid = copy.tid;
    }

    public Expression getTid() {
        return tid;
    }

    @Override
    protected String defaultString() {
        return String.format("DynamicThreadDetach(%s)", tid);
    }

    @Override
    public Event getCopy() {
        return new DynamicThreadDetach(this);
    }

    @Override
    public Register getResultRegister() {
        return status;
    }

    @Override
    public void setResultRegister(Register reg) {
        status = reg;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(tid, Register.UsageType.OTHER, new HashSet<>());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        tid = tid.accept(exprTransformer);
    }
}
