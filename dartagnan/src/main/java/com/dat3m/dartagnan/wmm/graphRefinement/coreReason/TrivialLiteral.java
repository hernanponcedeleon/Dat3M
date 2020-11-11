package com.dat3m.dartagnan.wmm.graphRefinement.coreReason;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.Objects;

// Not used actually. Might get deleted
public class TrivialLiteral implements CoreLiteral {
    private boolean value;

    public TrivialLiteral(boolean value) {
        this.value = value;
    }

    @Override
    public BoolExpr getZ3BoolExpr(Context ctx) {
        return value ? ctx.mkTrue() : ctx.mkFalse();
    }

    @Override
    public CoreLiteral getOpposite() {
        return null;
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(value);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null || !(obj instanceof TrivialLiteral))
            return false;
        TrivialLiteral other = (TrivialLiteral)obj;
        return this.value == other.value;
    }

    @Override
    public String toString() {
        return value ? "TRUE" : "FALSE";
    }
}
