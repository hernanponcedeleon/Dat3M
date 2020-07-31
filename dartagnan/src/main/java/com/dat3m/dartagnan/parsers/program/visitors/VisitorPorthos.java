package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.parsers.PorthosBaseVisitor;
import com.dat3m.dartagnan.parsers.PorthosParser;
import com.dat3m.dartagnan.parsers.PorthosVisitor;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.arch.pts.event.Read;
import com.dat3m.dartagnan.program.arch.pts.event.Write;
import com.dat3m.dartagnan.program.memory.Location;
import org.antlr.v4.runtime.misc.Interval;

public class VisitorPorthos extends PorthosBaseVisitor<Object> implements PorthosVisitor<Object> {

    private ProgramBuilder programBuilder;
    private int currentThread;

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
            programBuilder.getOrCreateLocation(locationContext.getText(), -1);
        }
        return null;
    }

    @Override
    public Object visitThread(PorthosParser.ThreadContext ctx) {
        currentThread = ctx.threadId().id;
        programBuilder.initThread(currentThread);
        return ctx.expressionSequence().accept(this);
    }

    @Override
    public Event visitExpressionWhile(PorthosParser.ExpressionWhileContext ctx) {
        ExprInterface expr = (ExprInterface)ctx.boolExpr().accept(this);
        Skip exitEvent = new Skip();
        While whileEvent = new While(expr, exitEvent);
        programBuilder.addChild(currentThread, whileEvent);
        ctx.expressionSequence().accept(this);
        return programBuilder.addChild(currentThread, exitEvent);
    }

    @Override
    public Object visitExpressionIf(PorthosParser.ExpressionIfContext ctx) {
        ExprInterface expr = (ExprInterface)ctx.boolExpr().accept(this);
        Skip exitMainBranch = new Skip();
        Skip exitElseBranch = new Skip();
        If ifEvent = new If(expr, exitMainBranch, exitElseBranch);
        programBuilder.addChild(currentThread, ifEvent);

        ctx.expressionSequence(0).accept(this);
        programBuilder.addChild(currentThread, exitMainBranch);

        if(ctx.expressionSequence(1) != null){
            ctx.expressionSequence(1).accept(this);
        }
        programBuilder.addChild(currentThread, exitElseBranch);
        return null;
    }

    @Override
    public Event visitInstructionLocal(PorthosParser.InstructionLocalContext ctx) {
        Register register = programBuilder.getOrCreateRegister(currentThread, ctx.register().getText(), -1);
        IExpr expr = (IExpr)ctx.arithExpr().accept(this);
        return programBuilder.addChild(currentThread, new Local(register, expr));
    }

    @Override
    public Event visitInstructionLoad(PorthosParser.InstructionLoadContext ctx) {
        Register register = programBuilder.getOrCreateRegister(currentThread, ctx.register().getText(), -1);
        Location location = programBuilder.getOrErrorLocation(ctx.location().getText());
        return programBuilder.addChild(currentThread, new Load(register, location.getAddress(), null));
    }

    @Override
    public Event visitInstructionStore(PorthosParser.InstructionStoreContext ctx) {
        IExpr expr = (IExpr)ctx.arithExpr().accept(this);
        Location location = programBuilder.getOrErrorLocation(ctx.location().getText());
        return programBuilder.addChild(currentThread, new Store(location.getAddress(), expr, null));
    }

    @Override
    public Event visitInstructionRead(PorthosParser.InstructionReadContext ctx) {
        Register register = programBuilder.getOrCreateRegister(currentThread, ctx.register().getText(), -1);
        Location location = programBuilder.getOrErrorLocation(ctx.location().getText());
        return programBuilder.addChild(currentThread, new Read(register, location.getAddress(), ctx.MemoryOrder().getText()));
    }

    @Override
    public Event visitInstructionWrite(PorthosParser.InstructionWriteContext ctx) {
        IExpr e = (IExpr)ctx.arithExpr().accept(this);
        Location location = programBuilder.getOrErrorLocation(ctx.location().getText());
        return programBuilder.addChild(currentThread, new Write(location.getAddress(), e, ctx.MemoryOrder().getText()));
    }

    @Override
    public Event visitInstructionFence(PorthosParser.InstructionFenceContext ctx) {
        return programBuilder.addChild(currentThread, new Fence(ctx.getText()));
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
        return new IConst(Integer.parseInt(ctx.getText()), -1);
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
