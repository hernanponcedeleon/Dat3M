package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.parsers.PorthosBaseVisitor;
import com.dat3m.dartagnan.parsers.PorthosParser;
import com.dat3m.dartagnan.parsers.PorthosVisitor;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.arch.pts.event.Read;
import com.dat3m.dartagnan.program.arch.pts.event.Write;
import com.dat3m.dartagnan.program.memory.Location;
import org.antlr.v4.runtime.misc.Interval;

import java.util.ArrayList;
import java.util.List;

public class VisitorPorthos extends PorthosBaseVisitor<Object> implements PorthosVisitor<Object> {

    private ProgramBuilder programBuilder;
    private String currentThread;

    public VisitorPorthos(ProgramBuilder pb){
        this.programBuilder = pb;
    }

    @Override
    public Object visitMain(PorthosParser.MainContext ctx) {
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitProgram(ctx.program());
        if(ctx.assertionList() != null){
            int a = ctx.assertionList().getStart().getStartIndex();
            int b = ctx.assertionList().getStop().getStopIndex();
            String raw = ctx.assertionList().getStart().getInputStream().getText(new Interval(a, b));
            programBuilder.setAssert(AssertionHelper.parseAssertionList(programBuilder, raw));
        }
        return programBuilder.build();
    }

    @Override
    public Object visitVariableDeclaratorList(PorthosParser.VariableDeclaratorListContext ctx) {
        for(PorthosParser.LocationContext locationContext : ctx.location()){
            programBuilder.getOrCreateLocation(locationContext.getText());
        }
        return null;
    }

    @Override
    public Object visitThread(PorthosParser.ThreadContext ctx) {
        currentThread = ctx.threadId().getText();
        programBuilder.initThread(currentThread);
        programBuilder.addChild(currentThread, (Thread)ctx.expressionSequence().accept(this));
        return null;
    }

    @Override
    public Thread visitExpressionInstruction(PorthosParser.ExpressionInstructionContext ctx) {
        return (Thread)ctx.instruction().accept(this);
    }

    @Override
    public Thread visitExpressionWhile(PorthosParser.ExpressionWhileContext ctx) {
        BExpr e = (BExpr)ctx.boolExpr().accept(this);
        Thread t = (Thread)ctx.expressionSequence().accept(this);
        return new While(e, t);
    }

    @Override
    public Thread visitExpressionIf(PorthosParser.ExpressionIfContext ctx) {
        BExpr e = (BExpr)ctx.boolExpr().accept(this);
        Thread t1 = (Thread)ctx.expressionSequence(0).accept(this);
        if(ctx.expressionSequence(1) != null){
            Thread t2 = (Thread)ctx.expressionSequence(1).accept(this);
            return new If(e, t1, t2);
        }
        return new If(e, t1, new Skip());
    }

    @Override
    public Thread visitExpressionSequence(PorthosParser.ExpressionSequenceContext ctx){
        List<Thread> children = new ArrayList<>();
        for(PorthosParser.ExpressionContext expression : ctx.expression()){
            children.add((Thread)expression.accept(this));
        }
        return Thread.fromList(true, children);
    }

    @Override
    public Thread visitInstructionLocal(PorthosParser.InstructionLocalContext ctx) {
        Register register = programBuilder.getOrCreateRegister(currentThread, ctx.register().getText());
        IExpr expr = (IExpr)ctx.arithExpr().accept(this);
        return new Local(register, expr);
    }

    @Override
    public Thread visitInstructionLoad(PorthosParser.InstructionLoadContext ctx) {
        Register register = programBuilder.getOrCreateRegister(currentThread, ctx.register().getText());
        Location location = programBuilder.getOrErrorLocation(ctx.location().getText());
        return new Load(register, location.getAddress(), "_rx");
    }

    @Override
    public Thread visitInstructionStore(PorthosParser.InstructionStoreContext ctx) {
        IExpr expr = (IExpr)ctx.arithExpr().accept(this);
        Location location = programBuilder.getOrErrorLocation(ctx.location().getText());
        return new Store(location.getAddress(), expr, "_rx");
    }

    @Override
    public Thread visitInstructionRead(PorthosParser.InstructionReadContext ctx) {
        Register register = programBuilder.getOrCreateRegister(currentThread, ctx.register().getText());
        Location location = programBuilder.getOrErrorLocation(ctx.location().getText());
        return new Read(register, location.getAddress(), ctx.MemoryOrder().getText());
    }

    @Override
    public Thread visitInstructionWrite(PorthosParser.InstructionWriteContext ctx) {
        IExpr e = (IExpr)ctx.arithExpr().accept(this);
        Location location = programBuilder.getOrErrorLocation(ctx.location().getText());
        return new Write(location.getAddress(), e, ctx.MemoryOrder().getText());
    }

    @Override
    public Thread visitInstructionFence(PorthosParser.InstructionFenceContext ctx) {
        return new Fence(ctx.getText());
    }

    @Override
    public IExpr visitArithExprAExpr(PorthosParser.ArithExprAExprContext ctx) {
        IExpr e1 = (IExpr)ctx.arithExpr(0).accept(this);
        IExpr e2 = (IExpr)ctx.arithExpr(1).accept(this);
        return new IExprBin(e1, ctx.opArith().op, e2);
    }

    @Override
    public IExpr visitArithExprChild(PorthosParser.ArithExprChildContext ctx) {
        return (IExpr)ctx.arithExpr().accept(this);
    }

    @Override
    public Register visitArithExprRegister(PorthosParser.ArithExprRegisterContext ctx) {
        return programBuilder.getOrErrorRegister(currentThread, ctx.register().getText());
    }

    @Override
    public IConst visitArithExprConst(PorthosParser.ArithExprConstContext ctx) {
        return new IConst(Integer.parseInt(ctx.getText()));
    }

    @Override
    public BExprBin visitBoolExprBExprBin(PorthosParser.BoolExprBExprBinContext ctx) {
        BExpr e1 = (BExpr)ctx.boolExpr(0).accept(this);
        BExpr e2 = (BExpr)ctx.boolExpr(1).accept(this);
        return new BExprBin(e1, ctx.opBoolBin().op, e2);
    }

    @Override
    public BExprUn visitBoolExprBExprUn(PorthosParser.BoolExprBExprUnContext ctx) {
        BExpr e = (BExpr)ctx.boolExpr().accept(this);
        return new BExprUn(ctx.opBoolUn().op, e);
    }

    @Override
    public Atom visitBoolExprAtom(PorthosParser.BoolExprAtomContext ctx) {
        IExpr e1 = (IExpr)ctx.arithExpr(0).accept(this);
        IExpr e2 = (IExpr)ctx.arithExpr(1).accept(this);
        return new Atom(e1, ctx.opCompare().op, e2);
    }

    @Override
    public BExpr visitBoolExprChild(PorthosParser.BoolExprChildContext ctx) {
        return (BExpr)ctx.boolExpr().accept(this);
    }

    @Override
    public BConst visitBoolExprConst(PorthosParser.BoolExprConstContext ctx) {
        return new BConst(Boolean.parseBoolean(ctx.getText()));
    }
}
