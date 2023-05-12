package com.dat3m.dartagnan.programNew.event.core.control;

import com.dat3m.dartagnan.expr.Expression;

/*
    A well-formed IfThenElse must terminate its true-branch with an unconditional jump to the
    merge point. The else-branch can naturally "fall-through" to the merge point.

 */
public abstract class IfThenElse extends Jump {

    protected Label mergePoint;

    protected IfThenElse(Expression guard, Label trueBranch, Label falseBranch, Label mergePoint) {
        super(guard, trueBranch, falseBranch);
        this.mergePoint = mergePoint;
        mergePoint.registerUser(this);
    }

    public Label getMergePoint() { return mergePoint; }
}
