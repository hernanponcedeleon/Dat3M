package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import org.sosy_lab.java_smt.api.BooleanFormula;

public class RMWStoreExclusive extends Store {

    private final boolean isStrong;
    private final boolean requiresMatchingAddresses;

    public RMWStoreExclusive(Expression address, Expression value,
                             boolean isStrong, boolean requiresMatchingAddresses) {
        super(address, value);
        addTags(Tag.EXCL, Tag.RMW);
        this.isStrong = isStrong;
        this.requiresMatchingAddresses = requiresMatchingAddresses;
        if (isStrong) {
            addTags(Tag.STRONG);
        }
    }

    protected RMWStoreExclusive(RMWStoreExclusive other) {
        super(other);
        this.isStrong = other.isStrong;
        this.requiresMatchingAddresses = other.requiresMatchingAddresses;
    }

    public boolean isStrong() { return this.isStrong; }
    public boolean doesRequireMatchingAddresses() { return this. requiresMatchingAddresses; }

    @Override
    public boolean cfImpliesExec() {
        return isStrong; // Strong RMWs always succeed
    }

    @Override
    public String defaultString() {
        String tag = isStrong ? " strong" : "";
        tag += requiresMatchingAddresses ? " addrmatch" : "";
        return String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", "excl " + super.defaultString()) + "# opt" + tag;
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        return ctx.getBooleanFormulaManager().implication(ctx.execution(this), ctx.controlFlow(this));
    }

    @Override
    public RMWStoreExclusive getCopy(){
        return new RMWStoreExclusive(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitRMWStoreExclusive(this);
    }
}