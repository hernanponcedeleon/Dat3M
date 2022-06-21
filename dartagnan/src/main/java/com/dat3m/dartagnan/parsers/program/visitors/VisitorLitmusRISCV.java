package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.parsers.LitmusRISCVBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusRISCVParser;
import com.dat3m.dartagnan.parsers.LitmusRISCVVisitor;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import org.antlr.v4.runtime.misc.Interval;

import static com.dat3m.dartagnan.GlobalSettings.ARCH_PRECISION;

import java.math.BigInteger;

public class VisitorLitmusRISCV extends LitmusRISCVBaseVisitor<Object>
        implements LitmusRISCVVisitor<Object> {

    private final ProgramBuilder programBuilder;
    private int mainThread;
    private int threadCount = 0;

    public VisitorLitmusRISCV(ProgramBuilder pb){
        this.programBuilder = pb;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusRISCVParser.MainContext ctx) {
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
    // Variable declarator list

    @Override
    public Object visitVariableDeclaratorLocation(LitmusRISCVParser.VariableDeclaratorLocationContext ctx) {
        programBuilder.initLocEqConst(ctx.location().getText(), new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusRISCVParser.VariableDeclaratorRegisterContext ctx) {
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register64().id, new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusRISCVParser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register64().id, ctx.location().getText(), ARCH_PRECISION);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(LitmusRISCVParser.VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions), e.g. " P0  |   P1  |   P2  ;"

    @Override
    public Object visitThreadDeclaratorList(LitmusRISCVParser.ThreadDeclaratorListContext ctx) {
        for(LitmusRISCVParser.ThreadIdContext threadCtx : ctx.threadId()){
            programBuilder.initThread(threadCtx.id);
            threadCount++;
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override
    public Object visitInstructionRow(LitmusRISCVParser.InstructionRowContext ctx) {
        for(int i = 0; i < threadCount; i++){
            mainThread = i;
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }
}
