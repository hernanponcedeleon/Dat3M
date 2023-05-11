package com.dat3m.dartagnan.program.event.core.rmw;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import org.sosy_lab.java_smt.api.BooleanFormula;

public class RMWStoreExclusive extends Store {

    private final boolean isStrong;
    private final boolean requiresMatchingAddresses;

    public RMWStoreExclusive(IExpr address, Expression value, String mo,
                             boolean isStrong, boolean requiresMatchingAddresses) {
        super(address, value, mo);
        addFilters(Tag.EXCL, Tag.RMW);
        this.isStrong = isStrong;
        this.requiresMatchingAddresses = requiresMatchingAddresses;
        if (isStrong) {
            addFilters(Tag.STRONG);
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
    public String toString() {
        String tag = isStrong ? " strong" : "";
        tag += requiresMatchingAddresses ? " addrmatch" : "";
        return String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", super.toString()) + "# opt" + tag;
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        return ctx.getBooleanFormulaManager().implication(ctx.execution(this), ctx.controlFlow(this));
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWStoreExclusive getCopy(){
        return new RMWStoreExclusive(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitRMWStoreExclusive(this);
    }
}