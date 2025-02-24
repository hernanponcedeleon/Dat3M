package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusAArch64BaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusAArch64Parser.*;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import static com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder.replaceZeroRegisters;
import static com.google.common.base.Preconditions.checkArgument;

public class VisitorLitmusAArch64 extends LitmusAArch64BaseVisitor<Object> {

    private record CmpInstruction(Expression left, Expression right) {}

    private final ProgramBuilder programBuilder = ProgramBuilder.forArch(Program.SourceLanguage.LITMUS, Arch.ARM8);
    private final TypeFactory types = programBuilder.getTypeFactory();
    private final IntegerType archType = types.getArchType();
    private final IntegerType i32 = types.getIntegerType(32);
    private final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    private int mainThread;
    private int threadCount = 0;
    private final Map<Integer, CmpInstruction> lastCmpInstructionPerThread = new HashMap<>();

    public VisitorLitmusAArch64() {
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
        VisitorLitmusAssertions.parseAssertions(programBuilder, ctx.assertionList(), ctx.assertionFilter());
        Program prog = programBuilder.build();
        replaceZeroRegisters(prog, Arrays.asList("XZR, WZR"));
        return prog;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { 0:EAX=0; 1:EAX=1; x=2; }

    @Override
    public Object visitVariableDeclaratorLocation(VariableDeclaratorLocationContext ctx) {
        programBuilder.initLocEqConst(ctx.location().getText(), parseValue(ctx.constant(), archType));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(VariableDeclaratorRegisterContext ctx) {
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register64().id, parseValue(ctx.constant(), archType));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register64().id, ctx.location().getText(), archType);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions), e.g. " P0  |   P1  |   P2  ;"

    @Override
    public Object visitThreadDeclaratorList(ThreadDeclaratorListContext ctx) {
        for(ThreadIdContext threadCtx : ctx.threadId()){
            programBuilder.newThread(threadCtx.id);
            threadCount++;
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override
    public Object visitInstructionRow(InstructionRowContext ctx) {
        for(int i = 0; i < threadCount; i++){
            mainThread = i;
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

    @Override
    public Object visitMov(MovContext ctx) {
        Register register = programBuilder.getOrNewRegister(mainThread, ctx.rD, archType);
        Expression expr = ctx.expr32() != null ? (Expression)ctx.expr32().accept(this) : (Expression)ctx.expr64().accept(this);
        return add(EventFactory.newLocal(register, expr));
    }

    @Override
    public Object visitCmp(CmpContext ctx) {
        Register register = programBuilder.getOrNewRegister(mainThread, ctx.rD, archType);
        Expression expr = ctx.expr32() != null ? (Expression)ctx.expr32().accept(this) : (Expression)ctx.expr64().accept(this);
        lastCmpInstructionPerThread.put(mainThread, new CmpInstruction(register, expr));
        return null;
    }

    @Override
    public Object visitArithmetic(ArithmeticContext ctx) {
        final Register r64 = programBuilder.getOrNewRegister(mainThread, ctx.rD, archType);
        final Register register = getOrNewRegister32(ctx.rD32, r64);
        final Register operand = programBuilder.getOrErrorRegister(mainThread, ctx.rV);
        final Expression expr = (Expression) (ctx.expr32() != null ? ctx.expr32() : ctx.expr64()).accept(this);
        final Expression fittedOperand = expressions.makeCast(operand, expr.getType());
        final Expression result = expressions.makeIntBinary(fittedOperand, ctx.arithmeticInstruction().op, expr);
        add(EventFactory.newLocal(register, result));
        add32To64BitUpdate(r64, register);
        return null;
    }

    @Override
    public Object visitLoad(LoadContext ctx) {
        final Register r64 = programBuilder.getOrNewRegister(mainThread, ctx.rD, archType);
        final Register register = getOrNewRegister32(ctx.rD32, r64);
        final Register base = programBuilder.getOrErrorRegister(mainThread, ctx.address().id);
        final Expression address = applyOffset(ctx.offset(), base);
        add(EventFactory.newLoadWithMo(register, address, ctx.loadInstruction().mo));
        add32To64BitUpdate(r64, register);
        return null;
    }

    @Override
    public Object visitLoadExclusive(LoadExclusiveContext ctx) {
        final Register r64 = programBuilder.getOrNewRegister(mainThread, ctx.rD, archType);
        final Register register = getOrNewRegister32(ctx.rD32, r64);
        final Register base = programBuilder.getOrErrorRegister(mainThread, ctx.address().id);
        final Expression address = applyOffset(ctx.offset(), base);
        add(EventFactory.newRMWLoadExclusiveWithMo(register, address, ctx.loadExclusiveInstruction().mo));
        add32To64BitUpdate(r64, register);
        return null;
    }

    @Override
    public Object visitStore(StoreContext ctx) {
        final Register r64 = programBuilder.getOrNewRegister(mainThread, ctx.rV, archType);
        final Expression value = ctx.rV32 == null ? r64 : expressions.makeIntegerCast(r64, i32, false);
        final Register base = programBuilder.getOrErrorRegister(mainThread, ctx.address().id);
        final Expression address = applyOffset(ctx.offset(), base);
        return add(EventFactory.newStoreWithMo(address, value, ctx.storeInstruction().mo));
    }

    @Override
    public Object visitStoreExclusive(StoreExclusiveContext ctx) {
        final Register r64 = programBuilder.getOrNewRegister(mainThread, ctx.rV, archType);
        final Expression value = ctx.rV32 == null ? r64 : expressions.makeIntegerCast(r64, i32, false);
        final Register status = programBuilder.getOrNewRegister(mainThread, ctx.rS, i32);
        final Register base = programBuilder.getOrErrorRegister(mainThread, ctx.address().id);
        final Expression address = applyOffset(ctx.offset(), base);
        return add(EventFactory.Common.newExclusiveStore(status, address, value, ctx.storeExclusiveInstruction().mo));
    }

    @Override
    public Object visitBranch(BranchContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.label().getText());
        if(ctx.branchCondition() == null){
            return add(EventFactory.newGoto(label));
        }
        CmpInstruction cmp = lastCmpInstructionPerThread.put(mainThread, null);
        if(cmp == null){
            throw new ParsingException("Invalid syntax near " + ctx.getText());
        }
        Expression expr = expressions.makeIntCmp(cmp.left, ctx.branchCondition().op, cmp.right);
        return add(EventFactory.newJump(expr, label));
    }

    @Override
    public Object visitBranchRegister(BranchRegisterContext ctx) {
        Register register = programBuilder.getOrErrorRegister(mainThread, ctx.rV);
        if (!(register.getType() instanceof IntegerType integerType)) {
            throw new ParsingException("Comparing non-integer register.");
        }
        IntLiteral zero = expressions.makeZero(integerType);
        Expression expr = expressions.makeIntCmp(register, ctx.branchRegInstruction().op, zero);
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.label().getText());
        return add(EventFactory.newJump(expr, label));
    }

    @Override
    public Object visitBranchLabel(BranchLabelContext ctx) {
        return add(programBuilder.getOrCreateLabel(mainThread, ctx.label().getText()));
    }

    @Override
    public Object visitFence(FenceContext ctx) {
        return add(EventFactory.newFenceOpt(ctx.Fence().getText(), ctx.opt));
    }

    @Override
    public Object visitReturn(ReturnContext ctx) {
        Label end = programBuilder.getEndOfThreadLabel(mainThread);
        return add(EventFactory.newGoto(end));
    }

    @Override
    public Expression visitExpressionRegister64(ExpressionRegister64Context ctx) {
        Expression expr = programBuilder.getOrNewRegister(mainThread, ctx.register64().id, archType);
        if(ctx.shift() != null){
            IntLiteral val = parseValue(ctx.shift().immediate().constant(), archType);
            expr = expressions.makeIntBinary(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public Expression visitExpressionRegister32(ExpressionRegister32Context ctx) {
        final Register r64 = programBuilder.getOrNewRegister(mainThread, ctx.register32().id, archType);
        final Expression expr = expressions.makeIntExtract(r64, 0, 32);
        if (ctx.shift() == null) {
            return expr;
        }
        final IntLiteral val = parseValue(ctx.shift().immediate().constant(), archType);
        return expressions.makeIntBinary(expr, ctx.shift().shiftOperator().op, val);
    }

    @Override
    public Expression visitExpressionImmediate(ExpressionImmediateContext ctx) {
        Expression expr = parseValue(ctx.immediate().constant(), archType);
        if(ctx.shift() != null){
            IntLiteral val = parseValue(ctx.shift().immediate().constant(), archType);
            expr = expressions.makeIntBinary(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public Expression visitExpressionConversion(ExpressionConversionContext ctx) {
        final Register r64 = programBuilder.getOrNewRegister(mainThread, ctx.register32().id, archType);
        return expressions.makeIntegerCast(expressions.makeIntExtract(r64, 0, 32), archType, ctx.signed);
    }

    private Expression applyOffset(OffsetContext ctx, Register register) {
        if (ctx == null) {
            return register;
        }
        Expression expr = ctx.immediate() == null
                ? programBuilder.getOrErrorRegister(mainThread, ctx.register64() != null ? ctx.register64().id : ctx.expressionConversion().register32().id)
                : parseValue(ctx.immediate().constant(), archType);
        return expressions.makeAdd(register, expr);
    }

    @Override
    public Expression visitImmediate(ImmediateContext ctx) {
        final int radix = ctx.Hexa() != null ? 16 : 10;
        BigInteger value = new BigInteger(ctx.constant().getText(), radix);
        return expressions.makeValue(value, archType);
    }

    private IntLiteral parseValue(ConstantContext ctx, IntegerType type) {
        if (ctx.hex != null) {
            return expressions.makeValue(new BigInteger(ctx.hex.getText().substring(2), 16), type);
        }
        return expressions.parseValue(ctx.getText(), type);
    }

    private Register getOrNewRegister32(Register32Context ctx, Register other) {
        return ctx == null ? other : programBuilder.getOrNewRegister(mainThread, ctx.getText(), i32);
    }

    private void add32To64BitUpdate(Register r64, Register r32) {
        checkArgument(r64.getType().equals(archType), "Unexpectedly-typed register %s", r64);
        if (r64 == r32) {
            return;
        }
        checkArgument(r32.getType().equals(i32), "Unexpectedly-typed register %s", r32);
        add(EventFactory.newLocal(r64, expressions.makeIntegerCast(r32, archType, false)));
    }

    private Void add(Event event) {
        programBuilder.addChild(mainThread, event);
        return null;
    }
}
