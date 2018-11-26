package dartagnan.parsers.visitors;

import dartagnan.expression.op.AOpBin;
import dartagnan.parsers.LitmusAArch64BaseVisitor;
import dartagnan.parsers.LitmusAArch64Parser;
import dartagnan.parsers.LitmusAArch64Visitor;
import dartagnan.expression.AConst;
import dartagnan.expression.AExpr;
import dartagnan.parsers.utils.ProgramBuilder;
import dartagnan.parsers.utils.branch.Cmp;
import dartagnan.parsers.utils.branch.CondJump;
import dartagnan.parsers.utils.branch.Label;
import dartagnan.program.Thread;
import dartagnan.program.event.LoadFromAddress;
import dartagnan.program.event.rmw.opt.RMWStoreOpt;
import dartagnan.program.event.rmw.opt.RMWStoreOptStatus;
import dartagnan.program.memory.Location;
import dartagnan.program.Register;
import dartagnan.program.event.*;
import dartagnan.program.event.StoreToAddress;
import dartagnan.program.event.rmw.RMWLoad;

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
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { 0:EAX=0; 1:EAX=1; x=2; }

    @Override
    public Object visitVariableDeclaratorLocation(LitmusAArch64Parser.VariableDeclaratorLocationContext ctx) {
        programBuilder.addDeclarationLocImm(ctx.location().getText(), Integer.parseInt(ctx.value().getText()));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusAArch64Parser.VariableDeclaratorRegisterContext ctx) {
        programBuilder.addDeclarationRegImm(ctx.threadId().id, ctx.register64().id, Integer.parseInt(ctx.value().getText()));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusAArch64Parser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.addDeclarationRegLoc(ctx.threadId().id, ctx.register64().id, ctx.location().getText());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(LitmusAArch64Parser.VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.addDeclarationLocLoc(ctx.location(0).getText(), ctx.location(1).getText());
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
        AExpr expr = ctx.expr32() != null ? (AExpr)ctx.expr32().accept(this) : (AExpr)ctx.expr64().accept(this);
        return programBuilder.addChild(mainThread, new Local(register, expr));
    }

    @Override
    public Object visitCmp(LitmusAArch64Parser.CmpContext ctx) {
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.rD);
        AExpr expr = ctx.expr32() != null ? (AExpr)ctx.expr32().accept(this) : (AExpr)ctx.expr64().accept(this);
        return programBuilder.addChild(mainThread, new Cmp(register, expr));
    }

    @Override
    public Object visitArithmetic(LitmusAArch64Parser.ArithmeticContext ctx) {
        Register rD = programBuilder.getOrCreateRegister(mainThread, ctx.rD);
        Register r1 = programBuilder.getOrErrorRegister(mainThread, ctx.rV);
        AExpr expr = ctx.expr32() != null ? (AExpr)ctx.expr32().accept(this) : (AExpr)ctx.expr64().accept(this);
        return programBuilder.addChild(mainThread, new Local(rD, new AExpr(r1, ctx.arithmeticInstruction().op, expr)));
    }

    @Override
    public Object visitLoad(LitmusAArch64Parser.LoadContext ctx) {
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.rD);
        Register address = programBuilder.getOrErrorRegister(mainThread, ctx.address().id);
        if(ctx.offset() != null){
            address = visitOffset(ctx.offset(), address);
        }
        return programBuilder.addChild(mainThread, new LoadFromAddress(register, address, ctx.loadInstruction().mo));
    }

    @Override
    public Object visitLoadExclusive(LitmusAArch64Parser.LoadExclusiveContext ctx) {
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.rD);
        Location location = programBuilder.getLocForReg(mainThread, ctx.address().id);
        RMWLoad load = new RMWLoad(register, location, ctx.loadExclusiveInstruction().mo);
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
        return programBuilder.addChild(mainThread, new StoreToAddress(address, register, ctx.storeInstruction().mo));
    }

    @Override
    public Object visitStoreExclusive(LitmusAArch64Parser.StoreExclusiveContext ctx) {
        RMWLoad loadEvent = ldxrMap.remove(mainThread);
        Location location = programBuilder.getLocForReg(mainThread, ctx.address().id);
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.rV);
        Register statusReg = programBuilder.getOrCreateRegister(mainThread, ctx.rS);
        RMWStoreOpt store = new RMWStoreOpt(loadEvent, location, register, ctx.storeExclusiveInstruction().mo);
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
        programBuilder.addChild(mainThread, new Cmp(register, new AConst(0)));
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
    public AExpr visitExpressionRegister64(LitmusAArch64Parser.ExpressionRegister64Context ctx) {
        AExpr expr = programBuilder.getOrCreateRegister(mainThread, ctx.register64().id);
        if(ctx.shift() != null){
            AConst val = new AConst(Integer.parseInt(ctx.shift().immediate().value().getText()));
            expr = new AExpr(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public AExpr visitExpressionRegister32(LitmusAArch64Parser.ExpressionRegister32Context ctx) {
        AExpr expr = programBuilder.getOrCreateRegister(mainThread, ctx.register32().id);
        if(ctx.shift() != null){
            AConst val = new AConst(Integer.parseInt(ctx.shift().immediate().value().getText()));
            expr = new AExpr(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public AExpr visitExpressionImmediate(LitmusAArch64Parser.ExpressionImmediateContext ctx) {
        AExpr expr = new AConst(Integer.parseInt(ctx.immediate().value().getText()));
        if(ctx.shift() != null){
            AConst val = new AConst(Integer.parseInt(ctx.shift().immediate().value().getText()));
            expr = new AExpr(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public AExpr visitExpressionConversion(LitmusAArch64Parser.ExpressionConversionContext ctx) {
        // TODO: Implementation
        return programBuilder.getOrCreateRegister(mainThread, ctx.register32().id);
    }

    private Register visitOffset(LitmusAArch64Parser.OffsetContext ctx, Register register){
        Register result = programBuilder.getOrCreateRegister(mainThread, null);
        AExpr expr = ctx.immediate() == null
                ? programBuilder.getOrErrorRegister(mainThread, ctx.expressionConversion().register32().id)
                : new AConst(Integer.parseInt(ctx.immediate().value().getText()));
        programBuilder.addChild(mainThread, new Local(result, new AExpr(register, AOpBin.PLUS, expr)));
        return result;
    }
}
