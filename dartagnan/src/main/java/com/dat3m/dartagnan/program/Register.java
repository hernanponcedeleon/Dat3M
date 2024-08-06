package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;
import com.google.common.collect.ImmutableSet;

import java.util.Objects;
import java.util.Set;

import static com.google.common.base.Preconditions.checkNotNull;

public class Register extends LeafExpressionBase<Type> {

    private final String name;
    private String cVar;
    private final Function function;

    Register(String name, Function function, Type type) {
        super(type);
        this.name = checkNotNull(name);
        this.function = function;
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

    public Thread getThread() {
        return function instanceof Thread thread ? thread : null;
    }

    public Function getFunction() {
        return function;
    }

    @Override
    public ExpressionKind getKind() { return ExpressionKind.Other.REGISTER; }

    @Override
    public String toString() {
        return type + " " + name;
    }

    @Override
    public int hashCode() {
        return name.hashCode() + Objects.hashCode(function);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        Register rObj = (Register) obj;
        return name.equals(rObj.name) && function == rObj.function;
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return ImmutableSet.of(this);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitRegister(this);
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
