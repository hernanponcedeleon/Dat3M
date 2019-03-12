package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class Jump extends Event {

    protected final Label label;

    public Jump(Label label){
        if(label == null){
            throw new IllegalArgumentException("Jump event requires non null label event");
        }
        this.label = label;
        addFilters(EType.ANY);
    }

    public Label getLabel(){
        return label;
    }

    @Override
    public String toString(){
        return "goto " + label;
    }


    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int unroll(int bound, int nextId, Event predecessor) {
        if(label.getOId() < oId){
            throw new UnsupportedOperationException("Unrolling of cycles in Jump is not implemented");
        }
        return super.unroll(bound, nextId, predecessor);
    }

    @Override
    public Jump getCopy(){
        throw new UnsupportedOperationException("Cloning is not implemented for Jump event");
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, int nextId, Event predecessor) {
        cId = nextId++;
        if(successor == null){
            throw new RuntimeException("Malformed Jump event");
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
            label.addCfCond(ctx, var);
            cfEnc = ctx.mkAnd(ctx.mkEq(var, cfCond), encodeExec(ctx));
            cfEnc = ctx.mkAnd(cfEnc, successor.encodeCF(ctx, ctx.mkFalse()));
        }
        return cfEnc;
    }
}
