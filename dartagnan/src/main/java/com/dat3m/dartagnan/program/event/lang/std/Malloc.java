package com.dat3m.dartagnan.program.event.lang.std;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.BooleanFormula;

/*
    NOTE: Although this event is no core event, it does not get compiled in the compilation pass.
    Instead, it will get replaced by a dedicated memory allocation pass.
    FIXME: Possibly make this event "core" due to the absence of compilation?
           A better alternative would be to reuse 'Local' but with a malloc expression as its right-hand side.
 */
public class Malloc extends Event implements RegWriter, RegReaderData {

    protected final Register register;
    protected IExpr sizeExpr;

    public Malloc(Register register, IExpr sizeExpr) {
        this.register = register;
        this.sizeExpr = sizeExpr;
        addFilters(Tag.LOCAL, Tag.REG_WRITER, Tag.REG_READER, Tag.Std.MALLOC);
    }

    protected Malloc(Malloc other) {
        super(other);
        this.register = other.register;
        this.sizeExpr = other.sizeExpr;
    }

    public IExpr getSizeExpr() { return sizeExpr; }
    public void setSizeExpr(IExpr sizeExpr) { this.sizeExpr = sizeExpr; }

    @Override
    public Register getResultRegister() { return register; }

    @Override
    public ImmutableSet<Register> getDataRegs() { return sizeExpr.getRegs(); }

    @Override
    public String toString() {
        return String.format("%s <- malloc(%s)", register, sizeExpr);
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext context) {
        throw new UnsupportedOperationException("Cannot encode Malloc events.");
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Malloc getCopy() {
        return new Malloc(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitMalloc(this);
    }
}