package com.dat3m.dartagnan.program.event.lang.std;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.collect.ImmutableSet;

import java.util.HashSet;
import java.util.Set;

import org.sosy_lab.java_smt.api.BooleanFormula;

public class MemCpy extends Event implements RegReaderData {

    protected final IExpr dst;
    protected final IExpr src;
    protected IExpr lenght;
    protected final int step;

    public MemCpy(IExpr dst, IExpr src, IExpr lenght, int step) {
        this.dst = dst;
        this.src = src;
        this.lenght = lenght;
        this.step = step;
        addFilters(Tag.ANY, Tag.REG_READER);
    }

    protected MemCpy(MemCpy other) {
        super(other);
        this.dst = other.dst;
        this.src = other.src;
        this.lenght = other.lenght;
        this.step = other.step;
    }

    public IExpr getDst() { return dst; }
    public IExpr getSrc() { return src; }
    public IExpr getLenght() { return lenght; }
    public void setLenght(IExpr lenght) { this.lenght = lenght; }
    public int getStep() { return step; }

    @Override
    public ImmutableSet<Register> getDataRegs() {
        Set<Register> res = new HashSet<Register>();
        res.addAll(dst.getRegs());
        res.addAll(src.getRegs());
        return ImmutableSet.copyOf(res);
    }

    @Override
    public String toString() {
        return String.format("memcpy(%s, %s, %s)", dst, src, lenght);
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext context) {
        throw new UnsupportedOperationException("Cannot encode MemCpy events.");
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public MemCpy getCopy() {
        return new MemCpy(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitMemCpy(this);
    }
}