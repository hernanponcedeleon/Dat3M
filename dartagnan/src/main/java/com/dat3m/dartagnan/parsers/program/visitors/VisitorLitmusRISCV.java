package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Atom;
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
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;
import org.antlr.v4.runtime.misc.Interval;

import java.math.BigInteger;

import static com.dat3m.dartagnan.GlobalSettings.ARCH_PRECISION;

public class VisitorLitmusRISCV
        extends LitmusRISCVBaseVisitor<Object>
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
	public Object visitXor(LitmusRISCVParser.XorContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText(), ARCH_PRECISION);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, new IExprBin(r2, IOpBin.XOR, r3)));

	}
	
	@Override
	public Object visitAnd(LitmusRISCVParser.AndContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText(), ARCH_PRECISION);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, new IExprBin(r2, IOpBin.AND, r3)));

	}
	
	@Override
	public Object visitOr(LitmusRISCVParser.OrContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText(), ARCH_PRECISION);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, new IExprBin(r2, IOpBin.OR, r3)));

	}
	
	@Override
	public Object visitAdd(LitmusRISCVParser.AddContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText(), ARCH_PRECISION);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, new IExprBin(r2, IOpBin.PLUS, r3)));

	}
	
	@Override
	public Object visitXori(LitmusRISCVParser.XoriContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText(), ARCH_PRECISION);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, new IExprBin(r2, IOpBin.XOR, constant)));
	}
	
	@Override
	public Object visitAndi(LitmusRISCVParser.AndiContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText(), ARCH_PRECISION);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, new IExprBin(r2, IOpBin.AND, constant)));
	}
	
	@Override
	public Object visitOri(LitmusRISCVParser.OriContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText(), ARCH_PRECISION);
        Register r2 = programBuilder.getOrCreateRegister(mainThread, ctx.register(1).getText(), ARCH_PRECISION);
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, new IExprBin(r2, IOpBin.OR, constant)));
	}

	@Override
	public Object visitAddi(LitmusRISCVParser.AddiContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText(), ARCH_PRECISION);
        Register r2 = programBuilder.getOrCreateRegister(mainThread, ctx.register(1).getText(), ARCH_PRECISION);
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, new IExprBin(r2, IOpBin.PLUS, constant)));
	}

	@Override
	public Object visitLw(LitmusRISCVParser.LwContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText(), ARCH_PRECISION);
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        return programBuilder.addChild(mainThread, EventFactory.newLoad(r1, ra, getMo(ctx.moRISCV(0), ctx.moRISCV(1))));
	}

	@Override
	public Object visitSw(LitmusRISCVParser.SwContext ctx) {
        Register r1 = programBuilder.getOrErrorRegister(mainThread, ctx.register(0).getText());
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        return programBuilder.addChild(mainThread, EventFactory.newStore(ra, r1, getMo(ctx.moRISCV(0), ctx.moRISCV(1))));
	}
	
	@Override
	public Object visitLr(LitmusRISCVParser.LrContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText(), ARCH_PRECISION);
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        return programBuilder.addChild(mainThread, EventFactory.newRMWLoadExclusive(r1, ra, getMo(ctx.moRISCV(0), ctx.moRISCV(1))));
	}

	@Override
	public Object visitSc(LitmusRISCVParser.ScContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText(), ARCH_PRECISION);
        Register r2 = programBuilder.getOrCreateRegister(mainThread, ctx.register(1).getText(), ARCH_PRECISION);
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, EventFactory.newExclusiveStore(r1, ra, r2, getMo(ctx.moRISCV(0), ctx.moRISCV(1))));
	}

	@Override
	public Object visitLabel(LitmusRISCVParser.LabelContext ctx) {
		return programBuilder.addChild(mainThread, programBuilder.getOrCreateLabel(ctx.Label().getText()));
	}
	
	@Override
	public Object visitBranchCond(LitmusRISCVParser.BranchCondContext ctx) {
        Label label = programBuilder.getOrCreateLabel(ctx.Label().getText());
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText(), ARCH_PRECISION);
        Register r2 = programBuilder.getOrCreateRegister(mainThread, ctx.register(1).getText(), ARCH_PRECISION);
        Atom expr = new Atom(r1, ctx.cond().op, r2);
        return programBuilder.addChild(mainThread, EventFactory.newJump(expr, label));
	}
	
	@Override
	public Object visitFence(LitmusRISCVParser.FenceContext ctx) {
		return programBuilder.addChild(mainThread, EventFactory.newFence("Fence." + ctx.fenceMode().mode));
	}
	
	@Override
	public Object visitAmoadd(LitmusRISCVParser.AmoaddContext ctx) {
		throw new ParsingException("No support for amoadd instructions");	}
	
	@Override
	public Object visitAmoor(LitmusRISCVParser.AmoorContext ctx) {
		throw new ParsingException("No support for amoor instructions");	}
	
	@Override
	public Object visitAmoswap(LitmusRISCVParser.AmoswapContext ctx) {
		throw new ParsingException("No support for amoswap instructions");
	}

	// =======================================
	// ================ Utils ================
	// =======================================
	
	private String getMo(LitmusRISCVParser.MoRISCVContext mo1, LitmusRISCVParser.MoRISCVContext mo2) {
		String moR = mo1 != null ? mo1.mo : null;
		String moW = mo2 != null ? mo2.mo : null;
		return moR != null ? (moW != null ? Tag.RISCV.MO_ACQ_REL : moR) : moW;
	}
}
