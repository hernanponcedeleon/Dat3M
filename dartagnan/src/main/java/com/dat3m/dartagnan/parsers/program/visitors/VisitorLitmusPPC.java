package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusPPCBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusPPCParser.*;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.HashMap;
import java.util.Map;

public class VisitorLitmusPPC extends LitmusPPCBaseVisitor<Object> {

    private record CmpInstruction(Expression left, Expression right) {}

    private final ProgramBuilder programBuilder = ProgramBuilder.forArch(Program.SourceLanguage.LITMUS, Arch.POWER);
    private final TypeFactory types = programBuilder.getTypeFactory();
    private final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    private final IntegerType archType = types.getArchType();
    private final Map<Integer, CmpInstruction> lastCmpInstructionPerThread = new HashMap<>();
    private int mainThread;
    private int threadCount = 0;

    public VisitorLitmusPPC() {
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
        VisitorLitmusAssertions.parseAssertions(programBuilder, ctx.assertionList(), ctx.assertionFilter());
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list

    @Override
    public Object visitVariableDeclaratorLocation(VariableDeclaratorLocationContext ctx) {
        IntLiteral value = expressions.parseValue(ctx.constant().getText(), archType);
        programBuilder.initLocEqConst(ctx.location().getText(), value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(VariableDeclaratorRegisterContext ctx) {
        IntLiteral value = expressions.parseValue(ctx.constant().getText(), archType);
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(), value, ctx.getStart().getLine());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(), archType, ctx.getStart().getLine());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorPointerLocation(VariableDeclaratorPointerLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.Identifier().getText(), ctx.location().getText());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorSymbolic(VariableDeclaratorSymbolicContext ctx) {
        // We do not know to which thread a symbolic register belogns to until its usage,
        // thus we create a register for each thread
        for (Integer tid : programBuilder.getThreadIds()) {
            final String regName = ctx.SymRegister().getText();
            final int lineOfCode = ctx.getStart().getLine();
            programBuilder.initRegEqLocPtr(tid.intValue(), regName, ctx.location().getText(), types.getIntegerType(64), lineOfCode);
        }
        return null;
    }

    @Override
    public Object visitVariableDeclaratorArray(VariableDeclaratorArrayContext ctx) {
        final int typeBytes = typeBytes(ctx.type());
        final int arraySize = toInt(ctx.constant());
        programBuilder.newMemoryObject(ctx.location().getText(), typeBytes * arraySize);
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
    public Object visitLi(LiContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        append(EventFactory.newLocal(register, constant), ctx);
        return null;
    }

    @Override
    public Object visitLd(LdContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register ra = (Register) ctx.register(1).accept(this);
        append(EventFactory.Power.newLoad(r1, ra), ctx);
        return null;
    }

    @Override
    public Object visitLwa(LwaContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register r1b = programBuilder.getOrNewRegister(mainThread, "dummy", types.getIntegerType(32));
        Register ra = (Register) ctx.register(1).accept(this);
        Expression cast = expressions.makeIntegerCast(r1b, types.getIntegerType(64), true);
        append(EventFactory.Power.newLoad(r1b, ra), ctx);
        append(EventFactory.newLocal(r1, cast), ctx);
        return null;
    }

    @Override
    public Object visitLwz(LwzContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register r1b = programBuilder.getOrNewRegister(mainThread, "dummy", types.getIntegerType(32));
        Register ra = (Register) ctx.register(1).accept(this);
        Expression cast = expressions.makeIntegerCast(r1b, types.getIntegerType(64), false);
        append(EventFactory.Power.newLoad(r1b, ra), ctx);
        append(EventFactory.newLocal(r1, cast), ctx);
        return null;
    }

    @Override
    public Object visitLwzx(LwzxContext ctx) {
        // TODO: Implementation
        throw new UnsupportedOperationException("lwzx is not implemented");
    }

    @Override
    public Object visitLwarx(LwarxContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register ra = (Register) ctx.register(1).accept(this);
        Register rb = (Register) ctx.register(2).accept(this);
        append(EventFactory.Power.newLoadReserve(r1, expressions.makeAdd(ra, rb)), ctx);
        return null;
    }

    @Override
    public Object visitStw(StwContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register ra = (Register) ctx.register(1).accept(this);
        append(EventFactory.Power.newStore(ra, r1), ctx);
        return null;
    }

    @Override
    public Object visitStwx(StwxContext ctx) {
        // TODO: Implementation
        throw new UnsupportedOperationException("stwx is not implemented");
    }

    @Override
    public Object visitStwcx(StwcxContext ctx) {
        // This instruction is usually followed by a branch instruction.
        // Thus, the execution status of the store is saved in r0
        // (the default register for branch conditions).
        Register rs = programBuilder.getOrNewRegister(mainThread, "r0", types.getBooleanType());
        Register r1 = (Register) ctx.register(0).accept(this);
        Register ra = (Register) ctx.register(1).accept(this);
        Register rb = (Register) ctx.register(2).accept(this);
        append(EventFactory.Power.newStoreConditional(rs, expressions.makeAdd(ra, rb), r1), ctx);
        return null;
    }

    @Override
    public Object visitMr(MrContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register r2 = (Register) ctx.register(1).accept(this);
        append(EventFactory.newLocal(r1, r2), ctx);
        return null;
    }

    @Override
    public Object visitAddi(AddiContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register r2 = (Register) ctx.register(1).accept(this);
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        append(EventFactory.newLocal(r1, expressions.makeAdd(r2, constant)), ctx);
        return null;
    }

    @Override
    public Object visitXor(XorContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register r2 = (Register) ctx.register(1).accept(this);
        Register r3 = (Register) ctx.register(2).accept(this);
        append(EventFactory.newLocal(r1, expressions.makeIntXor(r2, r3)), ctx);
        return null;
    }

    @Override
    public Object visitCmpw(CmpwContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register r2 = (Register) ctx.register(1).accept(this);
        lastCmpInstructionPerThread.put(mainThread, new CmpInstruction(r1, r2));
        return null;
    }

    @Override
    public Object visitBranchCond(BranchCondContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        CmpInstruction cmp = lastCmpInstructionPerThread.put(mainThread, null);
        Expression expr = cmp == null ?
            // In PPC, when there is no previous comparison instruction,
            // the value of r0 is used as the branching condition
            expressions.makeBooleanCast(programBuilder.getOrNewRegister(mainThread, "r0")) :
            expressions.makeIntCmp(cmp.left, ctx.cond().op, cmp.right);
        append(EventFactory.newJump(expr, label), ctx);
        return null;
    }

    @Override
    public Object visitLabel(LabelContext ctx) {
        append(programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText()), ctx);
        return null;
    }

    @Override
    public Object visitFence(FenceContext ctx) {
        append(EventFactory.Power.newBarrier(ctx.getText().toLowerCase()), ctx);
        return null;
    }

    @Override
    public Register visitRegister(RegisterContext ctx) {
        return programBuilder.getOrNewRegister(mainThread, ctx.getText(), archType);
    }

    private Event append(Event event, ParserRuleContext ctx) {
        return programBuilder.addChild(mainThread, event, ctx.getStart().getLine());
    }

    private int toInt(ConstantContext ctx) {
        final int radix = ctx.hex == null ? 10 : 16;
        final TerminalNode node = ctx.hex == null ? ctx.DigitSequence() : ctx.HexDigitSequence();
        return Integer.parseInt(node.getText(), radix);
    }

    private int typeBytes(TypeContext ignore) {
        //defaults to 64 bits
        return 8;
    }
}
