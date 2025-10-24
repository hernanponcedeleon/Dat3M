package com.dat3m.dartagnan.program.event.core.tangles;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.tangles.TangleType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.ScopeHierarchy;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import com.google.common.base.Preconditions;

import java.util.HashSet;
import java.util.Set;

public class NonUniformOpBase extends GenericVisibleEvent implements RegReader, RegWriter {

    protected final TangleType type;
    protected final String execScope;
    protected Expression expr;
    protected Register register;
    protected String instanceId;

    public NonUniformOpBase(String instanceId, String execScope, TangleType type, Register register, Expression expr) {
        super(instanceId);
        this.type = type;
        this.register = register;
        this.execScope = execScope;
        this.expr = expr;
        this.instanceId = instanceId;
    }

    protected NonUniformOpBase(NonUniformOpBase other) {
        super(other);
        this.type = other.type;
        this.register = other.register;
        this.execScope = other.execScope;
        this.expr = other.expr;
        this.instanceId = other.instanceId;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(expr, Register.UsageType.DATA, new HashSet<>());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.expr = expr.accept(exprTransformer);
    }

    public void setInstanceId(String instanceId) {
        this.instanceId = instanceId;
    }

    public String getInstanceId() {
        return instanceId;
    }

    public String getExecScope() {
        return execScope;
    }

    @Override
    public String defaultString() {
        return String.format("%s <- group.%s(%s, %s)", register, type, instanceId, expr);
    }

    @Override
    public NonUniformOpBase getCopy() {
        return new NonUniformOpBase(this);
    }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.register = reg;
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitNonUniformOpBase(this);
    }

    public TangleType getTangleType() {
        return type;
    }

    public Expression getExpression() {
        return expr;
    }
}
