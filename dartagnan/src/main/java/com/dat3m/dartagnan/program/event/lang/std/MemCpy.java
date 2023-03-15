package com.dat3m.dartagnan.program.event.lang.std;

import com.dat3m.dartagnan.encoding.EncodingContext;
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
    protected IExpr bytes;

    public MemCpy(IExpr dst, IExpr src, IExpr bytes) {
        this.dst = dst;
        this.src = src;
        this.bytes = bytes;
        addFilters(Tag.ANY, Tag.REG_READER);
    }

    protected MemCpy(MemCpy other) {
        super(other);
        this.dst = other.dst;
        this.src = other.src;
        this.bytes = other.bytes;
    }

    public IExpr getDst() { return dst; }
    public IExpr getSrc() { return src; }
    public IExpr getBytes() { return bytes; }
    public void setBytes(IExpr bytes) { this.bytes = bytes; }

    @Override
    public ImmutableSet<Register> getDataRegs() {
        Set<Register> res = new HashSet<Register>();
        res.addAll(dst.getRegs());
        res.addAll(src.getRegs());
        return ImmutableSet.copyOf(res);
    }

    @Override
    public String toString() {
        return String.format("memcpy(%s, %s, %s)", dst, src, bytes);
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