package com.dat3m.dartagnan.parsers.visitors;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.LitmusAArch64BaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusAArch64Parser;
import com.dat3m.dartagnan.parsers.LitmusAArch64Visitor;
import com.dat3m.dartagnan.parsers.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.utils.branch.Cmp;
import com.dat3m.dartagnan.parsers.utils.branch.CondJump;
import com.dat3m.dartagnan.parsers.utils.branch.Label;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.FenceOpt;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.rmw.RMWLoad;
import com.dat3m.dartagnan.program.event.rmw.opt.RMWStoreOpt;
import com.dat3m.dartagnan.program.event.rmw.opt.RMWStoreOptStatus;
import org.antlr.v4.runtime.misc.Interval;

import java.util.HashMap;
import java.util.Map;

public class VisitorLitmusAArch64 extends LitmusAArch64BaseVisitor<Object>
        implements LitmusAArch64Visitor<Object> {

    private ProgramBuilder programBuilder;
    private String mainThread;
    private Integer threadCount = 0;

    private Map<String, RMWLoad> ldxrMap = new HashMap<>();

    public VisitorLitmusAArch64(ProgramBuilder pb){
        this.programBuilder = pb;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusAArch64Parser.MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
        if(ctx.assertionList() != null){
            int a = ctx.assertionList().getStart().getStartIndex();
            int b = ctx.assertionList().getStop().getStopIndex();
            String raw = ctx.assertionList().getStart().getInputStream().getText(new Interval(a, b));
            programBuilder.setAssert(AssertionHelper.parseAssertionList(programBuilder, raw));
        }
        if(ctx.assertionFilter() != null){
            int a = ctx.assertionFilter().getStart().getStartIndex();
            int b = ctx.assertionFilter().getStop().getStopIndex();
            String raw = ctx.assertionFilter().getStart().getInputStream().getText(new Interval(a, b));
            programBuilder.setAssertFilter(AssertionHelper.parseAssertionFilter(programBuilder, raw));
        }
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { 0:EAX=0; 1:EAX=1; x=2; }

    @Override
    public Object visitVariableDeclaratorLocation(LitmusAArch64Parser.VariableDeclaratorLocationContext ctx) {
        programBuilder.initLocEqConst(ctx.location().getText(), new IConst(Integer.parseInt(ctx.constant().getText())));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusAArch64Parser.VariableDeclaratorRegisterContext ctx) {
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register64().id, new IConst(Integer.parseInt(ctx.constant().getText())));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusAArch64Parser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register64().id, ctx.location().getText());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(LitmusAArch64Parser.VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions), e.g. " P0  |   P1  |   P2  ;"

    @Override
    public Object visitThreadDeclaratorList(LitmusAArch64Parser.ThreadDeclaratorListContext ctx) {
        for(LitmusAArch64Parser.ThreadIdContext threadCtx : ctx.threadId()){
            programBuilder.initThread(threadCtx.id);
            threadCount++;
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override
    public Object visitInstructionRow(LitmusAArch64Parser.InstructionRowContext ctx) {
        for(Integer i = 0; i < threadCount; i++){
            mainThread = i.toString();
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

    @Override
    public Object visitMov(LitmusAArch64Parser.MovContext ctx) {
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.rD);
        IExpr expr = ctx.expr32() != null ? (IExpr)ctx.expr32().accept(this) : (IExpr)ctx.expr64().accept(this);
        return programBuilder.addChild(mainThread, new Local(register, expr));
    }

    @Override
    public Object visitCmp(LitmusAArch64Parser.CmpContext ctx) {
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.rD);
        IExpr expr = ctx.expr32() != null ? (IExpr)ctx.expr32().accept(this) : (IExpr)ctx.expr64().accept(this);
        return programBuilder.addChild(mainThread, new Cmp(register, expr));
    }

    @Override
    public Object visitArithmetic(LitmusAArch64Parser.ArithmeticContext ctx) {
        Register rD = programBuilder.getOrCreateRegister(mainThread, ctx.rD);
        Register r1 = programBuilder.getOrErrorRegister(mainThread, ctx.rV);
        IExpr expr = ctx.expr32() != null ? (IExpr)ctx.expr32().accept(this) : (IExpr)ctx.expr64().accept(this);
        return programBuilder.addChild(mainThread, new Local(rD, new IExprBin(r1, ctx.arithmeticInstruction().op, expr)));
    }

    @Override
    public Object visitLoad(LitmusAArch64Parser.LoadContext ctx) {
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.rD);
        Register address = programBuilder.getOrErrorRegister(mainThread, ctx.address().id);
        if(ctx.offset() != null){
            address = visitOffset(ctx.offset(), address);
        }
        return programBuilder.addChild(mainThread, new Load(register, address, ctx.loadInstruction().mo));
    }

    @Override
    public Object visitLoadExclusive(LitmusAArch64Parser.LoadExclusiveContext ctx) {
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.rD);
        Register address = programBuilder.getOrErrorRegister(mainThread, ctx.address().id);
        if(ctx.offset() != null){
            address = visitOffset(ctx.offset(), address);
        }
        RMWLoad load = new RMWLoad(register, address, ctx.loadExclusiveInstruction().mo);
        ldxrMap.put(mainThread, load);
        return programBuilder.addChild(mainThread, load);
    }

    @Override
    public Object visitStore(LitmusAArch64Parser.StoreContext ctx) {
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.rV);
        Register address = programBuilder.getOrErrorRegister(mainThread, ctx.address().id);
        if(ctx.offset() != null){
            address = visitOffset(ctx.offset(), address);
        }
        return programBuilder.addChild(mainThread, new Store(address, register, ctx.storeInstruction().mo));
    }

    @Override
    public Object visitStoreExclusive(LitmusAArch64Parser.StoreExclusiveContext ctx) {
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.rV);
        Register statusReg = programBuilder.getOrCreateRegister(mainThread, ctx.rS);
        RMWLoad loadEvent = ldxrMap.remove(mainThread);
        Register address = programBuilder.getOrErrorRegister(mainThread, ctx.address().id);
        if(ctx.offset() != null){
            address = visitOffset(ctx.offset(), address);
        }
        RMWStoreOpt store = new RMWStoreOpt(loadEvent, address, register, ctx.storeExclusiveInstruction().mo);
        RMWStoreOptStatus status = new RMWStoreOptStatus(statusReg, store);
        return programBuilder.addChild(mainThread, Thread.fromArray(false, store, status));
    }

    @Override
    public Object visitBranch(LitmusAArch64Parser.BranchContext ctx) {
        if(ctx.branchCondition() == null){
            throw new RuntimeException("Unconditional branching is not implemented");
        }
        return programBuilder.addChild(mainThread, new CondJump(ctx.branchCondition().op, programBuilder.getOrCreateLabel(mainThread, ctx.label().getText())));
    }

    @Override
    public Object visitBranchRegister(LitmusAArch64Parser.BranchRegisterContext ctx) {
        Register register = programBuilder.getOrErrorRegister(mainThread, ctx.rV);
        programBuilder.addChild(mainThread, new Cmp(register, new IConst(0)));
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.label().getText());
        return programBuilder.addChild(mainThread, new CondJump(ctx.branchRegInstruction().op, label));
    }

    @Override
    public Object visitBranchLabel(LitmusAArch64Parser.BranchLabelContext ctx) {
        return programBuilder.addChild(mainThread, programBuilder.getOrCreateLabel(mainThread, ctx.label().getText()));
    }

    @Override
    public Object visitFence(LitmusAArch64Parser.FenceContext ctx) {
        return programBuilder.addChild(mainThread, new FenceOpt(ctx.Fence().getText(), ctx.opt));
    }

    @Override
    public IExpr visitExpressionRegister64(LitmusAArch64Parser.ExpressionRegister64Context ctx) {
        IExpr expr = programBuilder.getOrCreateRegister(mainThread, ctx.register64().id);
        if(ctx.shift() != null){
            IConst val = new IConst(Integer.parseInt(ctx.shift().immediate().constant().getText()));
            expr = new IExprBin(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public IExpr visitExpressionRegister32(LitmusAArch64Parser.ExpressionRegister32Context ctx) {
        IExpr expr = programBuilder.getOrCreateRegister(mainThread, ctx.register32().id);
        if(ctx.shift() != null){
            IConst val = new IConst(Integer.parseInt(ctx.shift().immediate().constant().getText()));
            expr = new IExprBin(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public IExpr visitExpressionImmediate(LitmusAArch64Parser.ExpressionImmediateContext ctx) {
        IExpr expr = new IConst(Integer.parseInt(ctx.immediate().constant().getText()));
        if(ctx.shift() != null){
            IConst val = new IConst(Integer.parseInt(ctx.shift().immediate().constant().getText()));
            expr = new IExprBin(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public IExpr visitExpressionConversion(LitmusAArch64Parser.ExpressionConversionContext ctx) {
        // TODO: Implement when adding support for mixed-size accesses
        return programBuilder.getOrCreateRegister(mainThread, ctx.register32().id);
    }

    private Register visitOffset(LitmusAArch64Parser.OffsetContext ctx, Register register){
        Register result = programBuilder.getOrCreateRegister(mainThread, null);
        IExpr expr = ctx.immediate() == null
                ? programBuilder.getOrErrorRegister(mainThread, ctx.expressionConversion().register32().id)
                : new IConst(Integer.parseInt(ctx.immediate().constant().getText()));
        programBuilder.addChild(mainThread, new Local(result, new IExprBin(register, IOpBin.PLUS, expr)));
        return result;
    }
}
