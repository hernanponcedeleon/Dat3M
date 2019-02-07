package com.dat3m.dartagnan.parsers.utils.branch;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.If;

public class CondJump extends Event {

    private final COpBin op;
    private Label label;
    private Cmp cmp;

    public CondJump(COpBin op, Label label){
        this.op = op;
        this.label = label;
    }

    public void setCmp(Cmp cmp){
        this.cmp = cmp;
    }

    public Label getLabel(){
        return label;
    }

    public If toIf(Thread t1, Thread t2){
        return new If(new Atom(cmp.getLeft(), op, cmp.getRight()), t1, t2);
    }

    @Override
    public String toString(){
        return op + " " + label;
    }

    @Override
    public CondJump clone(){
        // In principle, we can clone it if needed, just take care that instances of Label are not duplicated
        // during cloning (multiple CondJump can refer to the same Label). Similar to conditional RMW cloning
        throw new UnsupportedOperationException("Method clone is not implemented for " + getClass().getName());
    }
}
