package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.google.common.collect.ImmutableSet;

import java.util.Set;

import static com.google.common.base.Preconditions.checkNotNull;

public class Register extends IExpr {

    public static final int NO_FUNCTION = -1;

    private final String name;
    private String cVar;
    private final int funcId;

    public Register(String name, int funcId, IntegerType type) {
        super(type);
        this.name = checkNotNull(name);
        this.funcId = funcId;
    }

    public String getName() {
        return name;
    }

    public String getCVar() {
        return cVar;
    }

    public void setCVar(String name) {
        this.cVar = name;
    }

    public int getFunctionId() {
        return funcId;
    }

    @Override
    public String toString() {
        return name;
    }

    @Override
    public int hashCode() {
        return name.hashCode() + funcId;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        Register rObj = (Register) obj;
        return name.equals(rObj.name) && funcId == rObj.funcId;
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return ImmutableSet.of(this);
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public IExpr getBase() {
        return this;
    }

    // ============================== Static utility =============================

    public static Set<Read> collectRegisterReads(Expression expr, Register.UsageType usageType, Set<Read> collector) {
        expr.getRegs().stream().map(r -> new Register.Read(r, usageType)).forEach(collector::add);
        return collector;
    }

    // ==========================================================================
    // ==========================================================================
    // ============================== Inner classes =============================
    // ==========================================================================
    // ==========================================================================

    public enum UsageType {
        CTRL, DATA, ADDR, // The register value is used to determine control, data, or address.
        OTHER;            // The register value is used for a different purpose.
    }

    /*
        Describes for what purpose a register was read.
    */
    public record Read(Register register, UsageType usageType) {
        @Override
        public String toString() {
            return String.format("RegRead[%s, %s]", register, usageType);
        }
    }
}
