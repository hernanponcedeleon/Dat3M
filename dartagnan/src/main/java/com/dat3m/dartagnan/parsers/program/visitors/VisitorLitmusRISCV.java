package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.LitmusRISCVBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusRISCVParser;
import com.dat3m.dartagnan.parsers.LitmusRISCVVisitor;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.google.common.collect.ImmutableSet;
import org.antlr.v4.runtime.misc.Interval;

import java.math.BigInteger;

import static com.dat3m.dartagnan.GlobalSettings.ARCH_PRECISION;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

public class VisitorLitmusRISCV
        extends LitmusRISCVBaseVisitor<Object>
        implements LitmusRISCVVisitor<Object> {

    private final static ImmutableSet<String> fences = ImmutableSet.of(SYNC, LWSYNC, ISYNC);

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
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(), new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusRISCVParser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(), ARCH_PRECISION);
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
    
	@Override
	public Object visitLi(LitmusRISCVParser.LiContext ctx) {
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), ARCH_PRECISION);
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, constant));
	}
	
	@Override
	public Object visitLw(LitmusRISCVParser.LwContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText(), ARCH_PRECISION);
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        String mo = ctx.mo() != null ? ctx.mo().getText() : null;
        return programBuilder.addChild(mainThread, EventFactory.newLoad(r1, ra, mo));
	}

	@Override
	public Object visitSw(LitmusRISCVParser.SwContext ctx) {
        Register r1 = programBuilder.getOrErrorRegister(mainThread, ctx.register(0).getText());
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        String mo = ctx.mo() != null ? ctx.mo().getText() : null;
        return programBuilder.addChild(mainThread, EventFactory.newStore(ra, r1, mo));
	}
	
	@Override
	public Object visitFence(LitmusRISCVParser.FenceContext ctx) {
		String name = ctx.fenceMode(0).getText();
		if(ctx.fenceMode(1) != null) {
			name = name + "." + ctx.fenceMode(1).getText(); 
		}
		return programBuilder.addChild(mainThread, EventFactory.newFence("Fence." + name));
	}

	@Override
	public Object visitOri(LitmusRISCVParser.OriContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText(), ARCH_PRECISION);
        Register r2 = programBuilder.getOrCreateRegister(mainThread, ctx.register(1).getText(), ARCH_PRECISION);
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, new IExprBin(r2, IOpBin.OR, constant)));
	}
}
