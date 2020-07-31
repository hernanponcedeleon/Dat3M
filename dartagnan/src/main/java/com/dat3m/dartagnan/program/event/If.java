package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.*;

public class If extends Event implements RegReaderData {

    private final ExprInterface expr;
    private Event successorMain;
    private Event successorElse;
    private Event exitMainBranch;
    private Event exitElseBranch;

    private final ImmutableSet<Register> dataRegs;

    public If(ExprInterface expr, Skip exitMainBranch, Skip exitElseBranch) {
        if(expr == null){
            throw new IllegalArgumentException("Expression in \"if\" event must be not null");
        }
        if(exitMainBranch == null || exitElseBranch == null){
            throw new IllegalArgumentException("Branch exit in \"if\" event must be not null");
        }
        if(exitMainBranch.equals(exitElseBranch)){
            throw new IllegalArgumentException("Last events in \"if\" branches must be distinct");
        }
        this.expr = expr;
        this.exitMainBranch = exitMainBranch;
        this.exitElseBranch = exitElseBranch;
        this.dataRegs = expr.getRegs();
        addFilters(EType.ANY, EType.CMP, EType.REG_READER);
    }

    public Event getExitMainBranch(){
        return exitMainBranch;
    }

    public Event getExitElseBranch(){
        return exitElseBranch;
    }

    public List<Event> getMainBranchEvents(){
        if(cId > -1){
            return successorMain.getSuccessors();
        }
        throw new RuntimeException("Not implemented");
    }

    public List<Event> getElseBranchEvents(){
        if(cId > -1){
            return successorElse.getSuccessors();
        }
        throw new RuntimeException("Not implemented");
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }

    @Override
    public LinkedList<Event> getSuccessors(){
        if(cId > -1){
            LinkedList<Event> result = successorMain.getSuccessors();
            result.addAll(successorElse.getSuccessors());
            if(successor != null){
                result.addAll(successor.getSuccessors());
            }
            result.addFirst(this);
            return result;
        }
        return super.getSuccessors();
    }

    @Override
    public String toString() {
        return "if(" + expr + ")";
    }


    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public If getCopy(){
        Skip copyExitMainBranch = (Skip) exitMainBranch.getCopy();
        Skip copyExitElseBranch =(Skip) exitElseBranch.getCopy();
        If copy = new If(expr, copyExitMainBranch, copyExitElseBranch);
        copy.setOId(oId);

        Event ptr = copyPath(successor, exitMainBranch, copy);
        ptr.successor = copyExitMainBranch;
        ptr = copyPath(exitMainBranch.successor, exitElseBranch, copyExitMainBranch);
        ptr.successor = copyExitElseBranch;

        return copy;
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, int nextId, Event predecessor) {
        cId = nextId++;
        if(successor == null){
            throw new RuntimeException("Malformed If event");
        }
        nextId = successor.compile(target, nextId, this);

        successorMain = successor;
        successorElse = exitMainBranch.successor;
        successor = exitElseBranch.successor;
        exitMainBranch.successor = null;
        exitElseBranch.successor = null;

        return nextId;
    }


    // Encoding
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public BoolExpr encodeCF(Context ctx, BoolExpr cond) {
        if(cfEnc == null){
            cfCond = (cfCond == null) ? cond : ctx.mkOr(cfCond, cond);
            BoolExpr ifCond = expr.toZ3Bool(this, ctx);
            cfEnc = ctx.mkAnd(ctx.mkEq(cfVar, cfCond), encodeExec(ctx));

            cfEnc = ctx.mkAnd(cfEnc, successorMain.encodeCF(ctx, ctx.mkAnd(ifCond, cfVar)));
            cfEnc = ctx.mkAnd(cfEnc, successorElse.encodeCF(ctx, ctx.mkAnd(ctx.mkNot(ifCond), cfVar)));

            if(successor != null){
                cfEnc = ctx.mkAnd(cfEnc, successor.encodeCF(ctx, ctx.mkOr(exitMainBranch.cfCond, exitElseBranch.cfCond)));
            }
        }
        return cfEnc;
    }
}