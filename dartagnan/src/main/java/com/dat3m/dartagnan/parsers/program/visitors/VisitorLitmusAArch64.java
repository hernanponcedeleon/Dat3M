package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusAArch64BaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusAArch64Parser;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import org.antlr.v4.runtime.misc.Interval;

import java.util.HashMap;
import java.util.Map;

public class VisitorLitmusAArch64 extends LitmusAArch64BaseVisitor<Object> {

    private static class CmpInstruction {
        private final Expression left;
        private final Expression right;

        public CmpInstruction(Expression left, Expression right) {
            this.left = left;
            this.right = right;
        }
    }

    private final ProgramBuilder programBuilder = ProgramBuilder.forArch(Program.SourceLanguage.LITMUS, Arch.ARM8);
    private final TypeFactory types = programBuilder.getTypeFactory();
    private final IntegerType archType = types.getArchType();
    private final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    private int mainThread;
    private int threadCount = 0;
    private final Map<Integer, CmpInstruction> lastCmpInstructionPerThread = new HashMap<>();

    public VisitorLitmusAArch64() {
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
        programBuilder.initLocEqConst(ctx.location().getText(), expressions.parseValue(ctx.constant().getText(), archType));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusAArch64Parser.VariableDeclaratorRegisterContext ctx) {
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register64().id, expressions.parseValue(ctx.constant().getText(), archType));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusAArch64Parser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register64().id, ctx.location().getText(), archType);
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
            programBuilder.newThread(threadCtx.id);
            threadCount++;
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override
    public Object visitInstructionRow(LitmusAArch64Parser.InstructionRowContext ctx) {
        for(int i = 0; i < threadCount; i++){
            mainThread = i;
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

    @Override
    public Object visitMov(LitmusAArch64Parser.MovContext ctx) {
        Register register = programBuilder.getOrNewRegister(mainThread, ctx.rD, archType);
        Expression expr = ctx.expr32() != null ? (Expression)ctx.expr32().accept(this) : (Expression)ctx.expr64().accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, expr));
    }

    @Override
    public Object visitCmp(LitmusAArch64Parser.CmpContext ctx) {
        Register register = programBuilder.getOrNewRegister(mainThread, ctx.rD, archType);
        Expression expr = ctx.expr32() != null ? (Expression)ctx.expr32().accept(this) : (Expression)ctx.expr64().accept(this);
        lastCmpInstructionPerThread.put(mainThread, new CmpInstruction(register, expr));
        return null;
    }

    @Override
    public Object visitArithmetic(LitmusAArch64Parser.ArithmeticContext ctx) {
        Register rD = programBuilder.getOrNewRegister(mainThread, ctx.rD, archType);
        Register r1 = programBuilder.getOrErrorRegister(mainThread, ctx.rV);
        Expression expr = ctx.expr32() != null ? (Expression)ctx.expr32().accept(this) : (Expression)ctx.expr64().accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rD, expressions.makeIntBinary(r1, ctx.arithmeticInstruction().op, expr)));
    }

    @Override
    public Object visitLoad(LitmusAArch64Parser.LoadContext ctx) {
        Register register = programBuilder.getOrNewRegister(mainThread, ctx.rD, archType);
        Register address = programBuilder.getOrErrorRegister(mainThread, ctx.address().id);
        if(ctx.offset() != null){
            address = visitOffset(ctx.offset(), address);
        }
        return programBuilder.addChild(mainThread, EventFactory.newLoadWithMo(register, address, ctx.loadInstruction().mo));
    }

    @Override
    public Object visitLoadExclusive(LitmusAArch64Parser.LoadExclusiveContext ctx) {
        Register register = programBuilder.getOrNewRegister(mainThread, ctx.rD, archType);
        Register address = programBuilder.getOrErrorRegister(mainThread, ctx.address().id);
        if(ctx.offset() != null){
            address = visitOffset(ctx.offset(), address);
        }
        Load load = EventFactory.newRMWLoadExclusiveWithMo(register, address, ctx.loadExclusiveInstruction().mo);
        return programBuilder.addChild(mainThread, load);
    }

    @Override
    public Object visitStore(LitmusAArch64Parser.StoreContext ctx) {
        Register register = programBuilder.getOrNewRegister(mainThread, ctx.rV, archType);
        Register address = programBuilder.getOrErrorRegister(mainThread, ctx.address().id);
        if(ctx.offset() != null){
            address = visitOffset(ctx.offset(), address);
        }
        return programBuilder.addChild(mainThread, EventFactory.newStoreWithMo(address, register, ctx.storeInstruction().mo));
    }

    @Override
    public Object visitStoreExclusive(LitmusAArch64Parser.StoreExclusiveContext ctx) {
        Register register = programBuilder.getOrNewRegister(mainThread, ctx.rV, archType);
        Register statusReg = programBuilder.getOrNewRegister(mainThread, ctx.rS, archType);
        Register address = programBuilder.getOrErrorRegister(mainThread, ctx.address().id);
        if(ctx.offset() != null){
            address = visitOffset(ctx.offset(), address);
        }
        StoreExclusive event = EventFactory.Common.newExclusiveStore(statusReg, address, register, ctx.storeExclusiveInstruction().mo);
        return programBuilder.addChild(mainThread, event);
    }

    @Override
    public Object visitBranch(LitmusAArch64Parser.BranchContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.label().getText());
        if(ctx.branchCondition() == null){
            return programBuilder.addChild(mainThread, EventFactory.newGoto(label));
        }
        CmpInstruction cmp = lastCmpInstructionPerThread.put(mainThread, null);
        if(cmp == null){
            throw new ParsingException("Invalid syntax near " + ctx.getText());
        }
        Expression expr = expressions.makeIntCmp(cmp.left, ctx.branchCondition().op, cmp.right);
        return programBuilder.addChild(mainThread, EventFactory.newJump(expr, label));
    }

    @Override
    public Object visitBranchRegister(LitmusAArch64Parser.BranchRegisterContext ctx) {
        Register register = programBuilder.getOrErrorRegister(mainThread, ctx.rV);
        if (!(register.getType() instanceof IntegerType integerType)) {
            throw new ParsingException("Comparing non-integer register.");
        }
        IntLiteral zero = expressions.makeZero(integerType);
        Expression expr = expressions.makeIntCmp(register, ctx.branchRegInstruction().op, zero);
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.label().getText());
        return programBuilder.addChild(mainThread, EventFactory.newJump(expr, label));
    }

    @Override
    public Object visitBranchLabel(LitmusAArch64Parser.BranchLabelContext ctx) {
        return programBuilder.addChild(mainThread, programBuilder.getOrCreateLabel(mainThread, ctx.label().getText()));
    }

    @Override
    public Object visitFence(LitmusAArch64Parser.FenceContext ctx) {
        return programBuilder.addChild(mainThread, EventFactory.newFenceOpt(ctx.Fence().getText(), ctx.opt));
    }

    @Override
    public Expression visitExpressionRegister64(LitmusAArch64Parser.ExpressionRegister64Context ctx) {
        Expression expr = programBuilder.getOrNewRegister(mainThread, ctx.register64().id, archType);
        if(ctx.shift() != null){
            IntLiteral val = expressions.parseValue(ctx.shift().immediate().constant().getText(), archType);
            expr = expressions.makeIntBinary(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public Expression visitExpressionRegister32(LitmusAArch64Parser.ExpressionRegister32Context ctx) {
        Expression expr = programBuilder.getOrNewRegister(mainThread, ctx.register32().id, archType);
        if(ctx.shift() != null){
            IntLiteral val = expressions.parseValue(ctx.shift().immediate().constant().getText(), archType);
            expr = expressions.makeIntBinary(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public Expression visitExpressionImmediate(LitmusAArch64Parser.ExpressionImmediateContext ctx) {
        Expression expr = expressions.parseValue(ctx.immediate().constant().getText(), archType);
        if(ctx.shift() != null){
            IntLiteral val = expressions.parseValue(ctx.shift().immediate().constant().getText(), archType);
            expr = expressions.makeIntBinary(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public Expression visitExpressionConversion(LitmusAArch64Parser.ExpressionConversionContext ctx) {
        // TODO: Implement when adding support for mixed-size accesses
        return programBuilder.getOrNewRegister(mainThread, ctx.register32().id, archType);
    }

    private Register visitOffset(LitmusAArch64Parser.OffsetContext ctx, Register register){
        Register result = programBuilder.getOrNewRegister(mainThread, null, archType);
        Expression expr = ctx.immediate() == null
                ? programBuilder.getOrErrorRegister(mainThread, ctx.expressionConversion().register32().id)
                : expressions.parseValue(ctx.immediate().constant().getText(), archType);
        programBuilder.addChild(mainThread, EventFactory.newLocal(result, expressions.makeAdd(register, expr)));
        return result;
    }
}
