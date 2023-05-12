package com.dat3m.dartagnan.programNew.event.core.control;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.booleans.BoolLiteral;
import com.dat3m.dartagnan.programNew.Register;
import com.dat3m.dartagnan.programNew.event.AbstractEvent;
import com.dat3m.dartagnan.programNew.event.BranchingEvent;
import com.google.common.base.Preconditions;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class Jump extends AbstractEvent implements BranchingEvent, Register.Reader {

    protected Expression guard;
    protected Label trueBranch;
    protected Label falseBranch;

    protected Jump(Expression guard, Label trueBranch, Label falseBranch) {
        //TODO: Do we allow only boolean guards?

        // Invariant: (falseBranch == null) => (guard == true)
        Preconditions.checkArgument(falseBranch != null || BoolLiteral.TRUE.equals(guard));
        this.guard = guard;
        this.trueBranch = Preconditions.checkNotNull(trueBranch);
        this.falseBranch = falseBranch;

        trueBranch.registerUser(this);
        if (falseBranch != null) {
            falseBranch.registerUser(this);
        }

    }

    public Expression getGuard() { return guard; }
    public Label getTrueBranch() { return trueBranch; }
    public Label getFalseBranch() { return falseBranch; }

    public boolean isUnconditional() { return falseBranch == null; }

    @Override
    public List<Label> getBranchingTargets() {
        return isUnconditional() ? List.of(trueBranch) : List.of(trueBranch, falseBranch);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        if (isUnconditional()) {
            return Set.of();
        }
        final Set<Register.Read> regReads = new HashSet<>();
        Register.collectRegisterReads(guard, Register.UsageType.CTRL, regReads);
        return regReads;
    }
}
