package dartagnan.parsers.visitors;

import dartagnan.expression.*;
import dartagnan.parsers.*;
import dartagnan.parsers.utils.ProgramBuilder;
import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.While;
import dartagnan.program.event.*;
import dartagnan.program.event.pts.Read;
import dartagnan.program.event.pts.Write;
import dartagnan.program.memory.Location;

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
            programBuilder.setAssert(ctx.assertionList().ass);
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
        AExpr expr = (AExpr)ctx.arithExpr().accept(this);
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
        AExpr expr = (AExpr)ctx.arithExpr().accept(this);
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
        AExpr e = (AExpr)ctx.arithExpr().accept(this);
        Location location = programBuilder.getOrErrorLocation(ctx.location().getText());
        return new Write(location.getAddress(), e, ctx.MemoryOrder().getText());
    }

    @Override
    public Thread visitInstructionFence(PorthosParser.InstructionFenceContext ctx) {
        return new Fence(ctx.getText());
    }

    @Override
    public AExpr visitArithExprAExpr(PorthosParser.ArithExprAExprContext ctx) {
        AExpr e1 = (AExpr)ctx.arithExpr(0).accept(this);
        AExpr e2 = (AExpr)ctx.arithExpr(1).accept(this);
        return new AExpr(e1, ctx.opArith().op, e2);
    }

    @Override
    public AExpr visitArithExprChild(PorthosParser.ArithExprChildContext ctx) {
        return (AExpr)ctx.arithExpr().accept(this);
    }

    @Override
    public Register visitArithExprRegister(PorthosParser.ArithExprRegisterContext ctx) {
        return programBuilder.getOrErrorRegister(currentThread, ctx.register().getText());
    }

    @Override
    public AConst visitArithExprConst(PorthosParser.ArithExprConstContext ctx) {
        return new AConst(Integer.parseInt(ctx.getText()));
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
        AExpr e1 = (AExpr)ctx.arithExpr(0).accept(this);
        AExpr e2 = (AExpr)ctx.arithExpr(1).accept(this);
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
