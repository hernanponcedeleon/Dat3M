package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;

import java.util.ArrayList;
import java.util.List;

public class If extends Event implements RegReaderData {

    private Thread t1;
    private Thread t2;
    private ExprInterface expr;
    private ImmutableSet<Register> dataRegs;

    public If(ExprInterface expr, Thread t1, Thread t2) {
        this.expr = expr;
        this.t1 = t1;
        this.t2 = t2;
        t1.incCondLevel();
        t2.incCondLevel();
        dataRegs = expr.getRegs();
        addFilters(EType.ANY, EType.CMP, EType.REG_READER);
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }

    public Thread getT1() {
        return t1;
    }

    public Thread getT2() {
        return t2;
    }

    public void setT1(Thread t) {
        t1 = t;
    }

    public void setT2(Thread t) {
        t2 = t;
    }

    @Override
    public void setMainThread(Thread t) {
        this.mainThread = t;
        t1.setMainThread(t);
        t2.setMainThread(t);
    }

    @Override
    public int setTId(int i) {
        this.tid = i;
        i++;
        i = t1.setTId(i);
        i = t2.setTId(i);
        return i;
    }

    @Override
    public void incCondLevel() {
        condLevel++;
        t1.incCondLevel();
        t2.incCondLevel();
    }

    @Override
    public void decCondLevel() {
        condLevel--;
        t1.decCondLevel();
        t2.decCondLevel();
    }

    @Override
    public int setEId(int i) {
        i = super.setEId(i);
        i = t1.setEId(i);
        i = t2.setEId(i);
        return i;
    }

    @Override
    public List<Event> getEvents() {
        List<Event> ret = new ArrayList<>();
        ret.addAll(t1.getEvents());
        ret.addAll(t2.getEvents());
        ret.add(this);
        return ret;
    }

    @Override
    public void beforeClone(){
        super.beforeClone();
        t1.beforeClone();
        t2.beforeClone();
    }

    @Override
    public If clone() {
        if(clone == null){
            Thread newT1 = t1.clone();
            newT1.decCondLevel();
            Thread newT2 = t2.clone();
            newT2.decCondLevel();
            clone = new If(expr, newT1, newT2);
            afterClone();
        }
        return (If)clone;
    }

    @Override
    public If unroll(int steps) {
        t1 = t1.unroll(steps);
        t2 = t2.unroll(steps);
        return this;
    }

    @Override
    public If compile(Arch target) {
        t1 = t1.compile(target);
        t2 = t2.compile(target);
        return this;
    }

    @Override
    public BoolExpr encodeCF(Context ctx) {
        BoolExpr enc = ctx.mkAnd(
                ctx.mkImplies(ctx.mkBoolConst(t1.cfVar()), expr.toZ3Bool(this, ctx)),
                ctx.mkImplies(ctx.mkBoolConst(t2.cfVar()), ctx.mkNot(expr.toZ3Bool(this, ctx)))
        );

        enc = ctx.mkAnd(enc, ctx.mkAnd(
                ctx.mkEq(ctx.mkBoolConst(cfVar()), ctx.mkXor(ctx.mkBoolConst(t1.cfVar()), ctx.mkBoolConst(t2.cfVar()))),
                ctx.mkEq(ctx.mkBoolConst(cfVar()), executes(ctx))
        ));

        return ctx.mkAnd(ctx.mkAnd(enc, ctx.mkAnd(t1.encodeCF(ctx), t2.encodeCF(ctx))));
    }

    @Override
    public String toString() {
        if (t2 instanceof Skip)
            return nTimesCondLevel() + "if (" + expr + ") {\n" + t1 + "\n" + nTimesCondLevel() + "}";
        else
            return nTimesCondLevel() + "if (" + expr + ") {\n" + t1 + "\n" + nTimesCondLevel() + "}\n"
                    + nTimesCondLevel() + "else {\n" + t2 + "\n" + nTimesCondLevel() + "}";
    }
}