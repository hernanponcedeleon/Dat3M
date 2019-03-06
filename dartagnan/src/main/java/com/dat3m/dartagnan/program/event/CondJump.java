package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class CondJump extends Event implements RegReaderData {

    private final Label label;
    private final BExpr expr;
    private final ImmutableSet<Register> dataRegs;

    public CondJump(BExpr expr, Label label){
        if(expr == null){
            throw new IllegalArgumentException("CondJump event requires non null expression");
        }
        if(label == null){
            throw new IllegalArgumentException("CondJump event requires non null label event");
        }
        this.expr = expr;
        this.label = label;
        dataRegs = expr.getRegs();
        addFilters(EType.ANY, EType.COND_JUMP, EType.REG_READER);
    }

    private CondJump(CondJump other){
        super(other);
        this.label = other.label;
        this.expr = other.expr;
        this.dataRegs = other.dataRegs;
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }

    @Override
    public String toString(){
        return "if(" + expr + "); then goto " + label;
    }


    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int unroll(int bound, int nextId, Event predecessor) {
        if(label.getOId() < oId){
            throw new UnsupportedOperationException("Unrolling of cycles in CondJump is not implemented");
        }
        return super.unroll(bound, nextId, predecessor);
    }

    @Override
    public CondJump getCopy(){
        throw new UnsupportedOperationException("Cloning is not implemented for CondJump event");
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, int nextId, Event predecessor) {
        cId = nextId++;
        if(successor == null){
            throw new RuntimeException("Malformed CondJump event");
        }
        return successor.compile(target, nextId, this);
    }


    // Encoding
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public BoolExpr encodeCF(Context ctx, BoolExpr cond) {
        if(cfEnc == null){
            cfCond = (cfCond == null) ? cond : ctx.mkOr(cfCond, cond);
            BoolExpr var = ctx.mkBoolConst(cfVar());
            BoolExpr ifCond = expr.toZ3Bool(this, ctx);

            label.addCfCond(ctx, ctx.mkAnd(ifCond, var));

            cfEnc = ctx.mkAnd(ctx.mkEq(var, cfCond), encodeExec(ctx));
            cfEnc = ctx.mkAnd(cfEnc, successor.encodeCF(ctx, ctx.mkAnd(ctx.mkNot(ifCond), var)));
        }
        return cfEnc;
    }
}
