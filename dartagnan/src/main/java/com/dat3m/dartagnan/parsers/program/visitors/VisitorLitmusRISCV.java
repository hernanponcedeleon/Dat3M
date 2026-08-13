package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusRISCVBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusRISCVParser.*;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.List;

import static com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder.replaceZeroRegisters;
import static com.dat3m.dartagnan.program.event.EventFactory.RISCV.MemoryOrder.*;

public class VisitorLitmusRISCV extends LitmusRISCVBaseVisitor<Object> {

    private final ProgramBuilder programBuilder = ProgramBuilder.forArch(Program.SourceLanguage.LITMUS, Arch.RISCV);
    private final TypeFactory types = programBuilder.getTypeFactory();
    private final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    private final IntegerType archType = types.getArchType();
    private final IntegerType i32 = types.getIntegerType(32);
    private int mainThread;
    private int threadCount = 0;

    public VisitorLitmusRISCV(){
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
        replaceZeroRegisters(prog, List.of("x0"));
        return prog;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list

    @Override
    public Object visitVariableDeclaratorLocation(VariableDeclaratorLocationContext ctx) {
        IntLiteral value = expressions.parseValue(ctx.constant().getText(), archType);
        programBuilder.initLocEqConst(ctx.location().name, value);
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
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().name, archType, ctx.getStart().getLine());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorPointerLocation(VariableDeclaratorPointerLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.Identifier().getText(), ctx.location().name);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorSymbolic(VariableDeclaratorSymbolicContext ctx) {
        // We do not know to which thread a symbolic register belogns to until its usage,
        // thus we create a register for each thread
        for (Integer tid : programBuilder.getThreadIds()) {
            final String regName = ctx.SymRegister().getText();
            final int lineOfCode = ctx.getStart().getLine();
            programBuilder.initRegEqLocPtr(tid.intValue(), regName, ctx.location().name, types.getIntegerType(64), lineOfCode);
        }
        return null;
    }

    @Override
    public Object visitVariableDeclaratorArray(VariableDeclaratorArrayContext ctx) {
        final int typeBytes = typeBytes(ctx.type());
        final int arraySize = toInt(ctx.constant());
        programBuilder.newMemoryObject(ctx.location().name, typeBytes * arraySize);
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
    public Object visitMv(MvContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        return append(EventFactory.newLocal(r1, r2), ctx);
    }

    @Override
    public Object visitLi(LiContext ctx) {
        Register register = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return append(EventFactory.newLocal(register, constant), ctx);
    }

    @Override
    public Object visitLui(LuiContext ctx) {
        Register register = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), i32);
        Expression shifted = expressions.makeLshift(constant, expressions.makeValue(12, i32));
        Expression sext = expressions.makeIntegerCast(shifted, archType, true);
        return append(EventFactory.newLocal(register, sext), ctx);
    }

    @Override
    public Object visitXor(XorContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return append(EventFactory.newLocal(r1, expressions.makeIntXor(r2, r3)), ctx);
    }

    @Override
    public Object visitAnd(AndContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return append(EventFactory.newLocal(r1, expressions.makeIntAnd(r2, r3)), ctx);
    }

    @Override
    public Object visitOr(OrContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return append(EventFactory.newLocal(r1, expressions.makeIntOr(r2, r3)), ctx);
    }

    @Override
    public Object visitAdd(AddContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return append(EventFactory.newLocal(r1, expressions.makeAdd(r2, r3)), ctx);
    }

    @Override
    public Object visitXori(XoriContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return append(EventFactory.newLocal(r1, expressions.makeIntXor(r2, constant)), ctx);
    }

    @Override
    public Object visitAndi(AndiContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return append(EventFactory.newLocal(r1, expressions.makeIntAnd(r2, constant)), ctx);
    }

    @Override
    public Object visitOri(OriContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return append(EventFactory.newLocal(r1, expressions.makeIntOr(r2, constant)), ctx);
    }

    @Override
    public Object visitAddi(AddiContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return append(EventFactory.newLocal(r1, expressions.makeAdd(r2, constant)), ctx);
    }

    @Override
    public Object visitAddiw(AddiwContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        Expression add = expressions.makeAdd(r2, constant);
        Expression trunc = expressions.makeIntegerCast(add, i32, true);
        Expression sext = expressions.makeIntegerCast(trunc, archType, true);
        return append(EventFactory.newLocal(r1, sext), ctx);
    }

    @Override
    public Object visitLd(LdContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        return append(EventFactory.RISCV.newLoad(r1, ra, getMo(ctx.moRISCV())), ctx);
    }

    @Override
    public Object visitLw(LwContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        return append(EventFactory.RISCV.newLoad(r1, ra, getMo(ctx.moRISCV())), ctx);
    }

    @Override
    public Object visitSw(SwContext ctx) {
        Register r1 = programBuilder.getOrErrorRegister(mainThread, ctx.register(0).getText());
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        return append(EventFactory.RISCV.newStore(ra, r1, getMo(ctx.moRISCV())), ctx);
    }

    @Override
    public Object visitLr(LrContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        return append(EventFactory.RISCV.newLoadReserve(r1, ra, getMo(ctx.moRISCV())), ctx);
    }

    @Override
    public Object visitSc(ScContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return append(EventFactory.RISCV.newStoreConditional(r1, ra, r2, getMo(ctx.moRISCV())), ctx);
    }

    @Override
    public Object visitReturn(ReturnContext ctx) {
        Label end = programBuilder.getEndOfThreadLabel(mainThread);
        return append(EventFactory.newGoto(end), ctx);
    }

    @Override
    public Object visitSext(SextContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        Expression trunc = expressions.makeIntegerCast(r2, i32, true);
        Expression sext = expressions.makeIntegerCast(trunc, archType, true);
        return append(EventFactory.newLocal(r1, sext), ctx);
    }

    @Override
    public Object visitZext(ZextContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        Expression trunc = expressions.makeIntegerCast(r2, i32, false);
        Expression zext = expressions.makeIntegerCast(trunc, archType, false);
        return append(EventFactory.newLocal(r1, zext), ctx);
    }

    @Override
    public Object visitBranchLabel(BranchLabelContext ctx) {
        return append(programBuilder.getOrCreateLabel(mainThread, ctx.label().getText()), ctx);
    }

    @Override
    public Object visitBranch(BranchContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.label().getText());
        return append(EventFactory.newGoto(label), ctx);
    }

    @Override
    public Object visitBranchCond(BranchCondContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.label().getText());
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        Expression expr = expressions.makeIntCmp(r1, ctx.cond().op, r2);
        return append(EventFactory.newJump(expr, label), ctx);
    }

    @Override
    public Object visitFence(FenceContext ctx) {
        return append(EventFactory.RISCV.newFence(ctx.fenceMode().mode), ctx);
    }

    @Override
    public Object visitAmoadd(AmoaddContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        Register ra = programBuilder.getOrNewRegister(mainThread, ctx.register(2).getText(), archType);
        return append(EventFactory.RISCV.newAmoAdd(r1, ra, r2, getMo(ctx.moRISCV())), ctx);
    }

    @Override
    public Object visitAmoor(AmoorContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        Register ra = programBuilder.getOrNewRegister(mainThread, ctx.register(2).getText(), archType);
        return append(EventFactory.RISCV.newAmoOr(r1, ra, r2, getMo(ctx.moRISCV())), ctx);
    }

    @Override
    public Object visitAmoxor(AmoxorContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        Register ra = programBuilder.getOrNewRegister(mainThread, ctx.register(2).getText(), archType);
        return append(EventFactory.RISCV.newAmoXor(r1, ra, r2, getMo(ctx.moRISCV())), ctx);
    }

    @Override
    public Object visitAmoswap(AmoswapContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        Register ra = programBuilder.getOrNewRegister(mainThread, ctx.register(2).getText(), archType);
        return append(EventFactory.RISCV.newAmoSwap(r1, ra, r2, getMo(ctx.moRISCV())), ctx);
    }

    // =======================================
    // ================ Utils ================
    // =======================================

    private EventFactory.RISCV.MemoryOrder getMo(List<MoRISCVContext> mo) {
        boolean acq = false;
        boolean rel = false;
        for (MoRISCVContext ctx : mo) {
            acq |= ctx.Acq() != null;
            rel |= ctx.Rel() != null;
        }
        return acq ? rel ? ACQ_REL : ACQUIRE : rel ? RELEASE : PLAIN;
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
