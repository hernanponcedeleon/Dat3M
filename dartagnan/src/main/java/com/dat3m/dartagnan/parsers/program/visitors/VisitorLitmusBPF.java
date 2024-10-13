package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusBPFBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusBPFParser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;
import com.google.common.collect.ImmutableSet;
import org.antlr.v4.runtime.misc.Interval;

import java.util.HashMap;
import java.util.Map;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;

public class VisitorLitmusBPF extends LitmusBPFBaseVisitor<Object> {

    private final ProgramBuilder programBuilder = ProgramBuilder.forArch(Program.SourceLanguage.LITMUS, Arch.POWER);
    private final TypeFactory types = programBuilder.getTypeFactory();
    private final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    private final IntegerType archType = types.getArchType();
    private int mainThread;
    private int threadCount = 0;

    public VisitorLitmusBPF() {
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusBPFParser.MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
        VisitorLitmusAssertions.parseAssertions(programBuilder, ctx.assertionList(), ctx.assertionFilter());
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------

    @Override
    public Object visitVariableDeclaratorLocation(LitmusBPFParser.VariableDeclaratorLocationContext ctx) {
        IntLiteral value = ctx.constant() != null ?
            expressions.parseValue(ctx.constant().getText(), archType) :
            expressions.makeZero(archType);
        programBuilder.initLocEqConst(ctx.location().getText(), value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusBPFParser.VariableDeclaratorRegisterContext ctx) {
        IntLiteral value = expressions.parseValue(ctx.constant().getText(), archType);
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(), value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusBPFParser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(), archType);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(LitmusBPFParser.VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------

    @Override 
    public Register visitRegister(LitmusBPFParser.RegisterContext ctx) {
        return programBuilder.getOrNewRegister(mainThread, ctx.getText(), archType);
    }
	
    @Override 
    public IntLiteral visitConstant(LitmusBPFParser.ConstantContext ctx) {
        return expressions.parseValue(ctx.getText(), archType);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions), e.g. " P0  |   P1  |   P2  ;"

    @Override
    public Object visitThreadDeclaratorList(LitmusBPFParser.ThreadDeclaratorListContext ctx) {
        for(LitmusBPFParser.ThreadIdContext threadCtx : ctx.threadId()){
            programBuilder.newThread(threadCtx.id);
            threadCount++;
        }
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override 
    public Object visitLocal(LitmusBPFParser.LocalContext ctx) {
        Register rd = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        Expression val = (Expression) ctx.value().accept(this);
        if(ctx.operation() != null) {
            val = expressions.makeBinary(rd, ctx.operation().op, val);
        }
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rd, val));
    }

    @Override
    public Object visitInstructionRow(LitmusBPFParser.InstructionRowContext ctx) {
        for(int i = 0; i < threadCount; i++){
            mainThread = i;
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

    @Override 
    public Object visitLoad(LitmusBPFParser.LoadContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        IntLiteral ca = expressions.parseValue(ctx.constant().getText(), archType);
        Expression address = expressions.makeAdd(ra, ca);
        return programBuilder.addChild(mainThread, EventFactory.newLoad(r1, address));
    }

    @Override
    public Object visitLoadAcquire(LitmusBPFParser.LoadAcquireContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        IntLiteral ca = expressions.parseValue(ctx.constant().getText(), archType);
        Expression address = expressions.makeAdd(ra, ca);
        return programBuilder.addChild(mainThread, EventFactory.newLoadWithMo(r1, address, Tag.BPF.ACQ));
    }

    @Override 
    public Object visitStore(LitmusBPFParser.StoreContext ctx) {
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register().getText());
        IntLiteral ca = expressions.parseValue(ctx.constant().getText(), archType);
        Expression address = expressions.makeAdd(ra, ca);
        Expression val = (Expression) ctx.value().accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newStore(address, val));
    }

    @Override
    public Object visitStoreRelease(LitmusBPFParser.StoreReleaseContext ctx) {
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register().getText());
        IntLiteral ca = expressions.parseValue(ctx.constant().getText(), archType);
        Expression address = expressions.makeAdd(ra, ca);
        Expression val = (Expression) ctx.value().accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newStoreWithMo(address, val, Tag.BPF.REL));
    }

    @Override 
    public Object visitAtomicRMW(LitmusBPFParser.AtomicRMWContext ctx) {
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register().getText());
        IntLiteral ca = expressions.parseValue(ctx.constant().getText(), archType);
        Expression address = expressions.makeAdd(ra, ca);
        IntBinaryOp operator = ctx.atomicOperation().op;
        Expression operand = (Expression) ctx.value().accept(this);
        return programBuilder.addChild(mainThread, EventFactory.BPF.newBPF_RMWOp(address, operator, operand));
    }

    @Override 
    public Object visitAtomicFetchRMW(LitmusBPFParser.AtomicFetchRMWContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        IntLiteral ca = expressions.parseValue(ctx.constant().getText(), archType);
        Expression address = expressions.makeAdd(ra, ca);
        IntBinaryOp operator = ctx.op;
        Expression operand = (Expression) ctx.value().accept(this);
        return programBuilder.addChild(mainThread, EventFactory.BPF.newBPF_RMWOpReturn(r1, address, operator, operand));
    }

    @Override
    public Object visitLabel(LitmusBPFParser.LabelContext ctx) {
        return programBuilder.addChild(mainThread, programBuilder.getOrCreateLabel(mainThread, ctx.Identifier().getText()));
    }

    @Override
    public Object visitJump(LitmusBPFParser.JumpContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Identifier().getText());
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression expr = expressions.makeIntCmp(lhs, ctx.cond().op, rhs);
        return programBuilder.addChild(mainThread, EventFactory.newJump(expr, label));
    }
}
