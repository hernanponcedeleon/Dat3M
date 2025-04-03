package com.dat3m.dartagnan.parsers.program.visitors;

import java.util.HashMap;
import java.util.Map;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusPPCBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusPPCParser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import static com.dat3m.dartagnan.program.event.FenceNameRepository.ISYNC;
import static com.dat3m.dartagnan.program.event.FenceNameRepository.LWSYNC;
import static com.dat3m.dartagnan.program.event.FenceNameRepository.SYNC;
import com.dat3m.dartagnan.program.event.core.Label;
import com.google.common.collect.ImmutableSet;

public class VisitorLitmusPPC extends LitmusPPCBaseVisitor<Object> {

    private record CmpInstruction(Expression left, Expression right) {};
    private final static ImmutableSet<String> fences = ImmutableSet.of(SYNC, LWSYNC, ISYNC);

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
    public Object visitMain(LitmusPPCParser.MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
        VisitorLitmusAssertions.parseAssertions(programBuilder, ctx.assertionList(), ctx.assertionFilter());
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { 0:EAX=0; 1:EAX=1; x=2; }

    @Override
    public Object visitVariableDeclaratorLocation(LitmusPPCParser.VariableDeclaratorLocationContext ctx) {
        IntLiteral value = expressions.parseValue(ctx.constant().getText(), archType);
        programBuilder.initLocEqConst(ctx.location().getText(), value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusPPCParser.VariableDeclaratorRegisterContext ctx) {
        IntLiteral value = expressions.parseValue(ctx.constant().getText(), archType);
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(), value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusPPCParser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(), archType);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(LitmusPPCParser.VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions), e.g. " P0  |   P1  |   P2  ;"

    @Override
    public Object visitThreadDeclaratorList(LitmusPPCParser.ThreadDeclaratorListContext ctx) {
        for(LitmusPPCParser.ThreadIdContext threadCtx : ctx.threadId()){
            programBuilder.newThread(threadCtx.id);
            threadCount++;
        }
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override
    public Object visitInstructionRow(LitmusPPCParser.InstructionRowContext ctx) {
        for(int i = 0; i < threadCount; i++){
            mainThread = i;
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

    @Override
    public Object visitLi(LitmusPPCParser.LiContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, constant));
    }

    @Override
    public Object visitLwz(LitmusPPCParser.LwzContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register ra = (Register) ctx.register(1).accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newLoad(r1, ra));
    }

    @Override
    public Object visitLwzx(LitmusPPCParser.LwzxContext ctx) {
        // TODO: Implementation
        throw new ParsingException("lwzx is not implemented");
    }

    @Override
    public Object visitLwarx(LitmusPPCParser.LwarxContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register ra = (Register) ctx.register(1).accept(this);
        Register rb = (Register) ctx.register(2).accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newRMWLoadExclusive(r1, expressions.makeAdd(ra, rb)));
    }

    @Override
    public Object visitStw(LitmusPPCParser.StwContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register ra = (Register) ctx.register(1).accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newStore(ra, r1));
    }

    @Override
    public Object visitStwx(LitmusPPCParser.StwxContext ctx) {
        // TODO: Implementation
        throw new ParsingException("stwx is not implemented");
    }

    @Override
    public Object visitStwcx(LitmusPPCParser.StwcxContext ctx) {
        // This instruction is usually followed by a branch instruction.
        // Thus, the execution status of the store is saved in r0
        // (the default register for branch conditions).
        Register rs = programBuilder.getOrNewRegister(mainThread, "r0", types.getBooleanType());
        Register r1 = (Register) ctx.register(0).accept(this);
        Register ra = (Register) ctx.register(1).accept(this);
        Register rb = (Register) ctx.register(2).accept(this);
        return programBuilder.addChild(mainThread, EventFactory.Common.newExclusiveStore(rs, expressions.makeAdd(ra, rb), r1, ""));
    }

    @Override
    public Object visitMr(LitmusPPCParser.MrContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register r2 = (Register) ctx.register(1).accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, r2));
    }

    @Override
    public Object visitAddi(LitmusPPCParser.AddiContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register r2 = (Register) ctx.register(1).accept(this);
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeAdd(r2, constant)));
    }

    @Override
    public Object visitXor(LitmusPPCParser.XorContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register r2 = (Register) ctx.register(1).accept(this);
        Register r3 = (Register) ctx.register(2).accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeIntXor(r2, r3)));
    }

    @Override
    public Object visitCmpw(LitmusPPCParser.CmpwContext ctx) {
        Register r1 = (Register) ctx.register(0).accept(this);
        Register r2 = (Register) ctx.register(1).accept(this);
        lastCmpInstructionPerThread.put(mainThread, new CmpInstruction(r1, r2));
        return null;
    }

    @Override
    public Object visitBranchCond(LitmusPPCParser.BranchCondContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        CmpInstruction cmp = lastCmpInstructionPerThread.put(mainThread, null);
        Expression expr = cmp == null ?
            // In PPC, when there is no previous comparison instruction,
            // the value of r0 is used as the branching condition
            expressions.makeBooleanCast(programBuilder.getOrNewRegister(mainThread, "r0")) :
            expressions.makeIntCmp(cmp.left, ctx.cond().op, cmp.right);
        return programBuilder.addChild(mainThread, EventFactory.newJump(expr, label));
    }

    @Override
    public Object visitLabel(LitmusPPCParser.LabelContext ctx) {
        return programBuilder.addChild(mainThread, programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText()));
    }

    @Override
    public Object visitFence(LitmusPPCParser.FenceContext ctx) {
        String name = ctx.getText().toLowerCase();
        if(fences.contains(name)){
            return programBuilder.addChild(mainThread, EventFactory.newFence(name));
        }
        throw new ParsingException("Unrecognised fence " + name);
    }

    @Override
    public Register visitRegister(LitmusPPCParser.RegisterContext ctx) {
        return programBuilder.getOrNewRegister(mainThread, ctx.getText(), archType);
    }

}
