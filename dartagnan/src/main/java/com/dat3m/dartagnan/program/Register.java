package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.Type;
import com.google.common.collect.ImmutableSet;

import java.util.Objects;
import java.util.Set;

import static com.google.common.base.Preconditions.checkNotNull;

public class Register implements Expression {

    private final String name;
    private String cVar;
    private final Function function;
    private final Type type;

    Register(String name, Function function, Type type) {
        this.name = checkNotNull(name);
        this.function = function;
        this.type = checkNotNull(type);
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
    public Type getType() {
        return type;
    }

    @Override
    public String toString() {
        return name;
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
        return visitor.visit(this);
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
