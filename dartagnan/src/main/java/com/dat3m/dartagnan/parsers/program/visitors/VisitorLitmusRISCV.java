package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusRISCVBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusRISCVParser;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;
import org.antlr.v4.runtime.misc.Interval;

public class VisitorLitmusRISCV extends LitmusRISCVBaseVisitor<Object> {

    private final ProgramBuilder programBuilder = ProgramBuilder.forArch(Program.SourceLanguage.LITMUS, Arch.RISCV);
    private final TypeFactory types = programBuilder.getTypeFactory();
    private final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    private final IntegerType archType = types.getArchType();
    private int mainThread;
    private int threadCount = 0;

    public VisitorLitmusRISCV(){
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
        IValue value = expressions.parseValue(ctx.constant().getText(), archType);
        programBuilder.initLocEqConst(ctx.location().getText(), value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusRISCVParser.VariableDeclaratorRegisterContext ctx) {
        IValue value = expressions.parseValue(ctx.constant().getText(), archType);
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(), value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusRISCVParser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(), archType);
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
            programBuilder.newThread(threadCtx.id);
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
        Register register = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        IValue constant = expressions.parseValue(ctx.constant().getText(), archType);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, constant));
	}

	@Override
	public Object visitXor(LitmusRISCVParser.XorContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeXOR(r2, r3)));

	}

	@Override
	public Object visitAnd(LitmusRISCVParser.AndContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeAND(r2, r3)));

	}

	@Override
	public Object visitOr(LitmusRISCVParser.OrContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeOR(r2, r3)));

	}

	@Override
	public Object visitAdd(LitmusRISCVParser.AddContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeADD(r2, r3)));

	}

	@Override
	public Object visitXori(LitmusRISCVParser.XoriContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        IValue constant = expressions.parseValue(ctx.constant().getText(), archType);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeXOR(r2, constant)));
	}

	@Override
	public Object visitAndi(LitmusRISCVParser.AndiContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        IValue constant = expressions.parseValue(ctx.constant().getText(), archType);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeAND(r2, constant)));
	}

	@Override
	public Object visitOri(LitmusRISCVParser.OriContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        IValue constant = expressions.parseValue(ctx.constant().getText(), archType);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeOR(r2, constant)));
	}

	@Override
	public Object visitAddi(LitmusRISCVParser.AddiContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        IValue constant = expressions.parseValue(ctx.constant().getText(), archType);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeADD(r2, constant)));
	}

	@Override
	public Object visitLw(LitmusRISCVParser.LwContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        return programBuilder.addChild(mainThread, EventFactory.newLoadWithMo(r1, ra, getMo(ctx.moRISCV(0), ctx.moRISCV(1))));
	}

	@Override
	public Object visitSw(LitmusRISCVParser.SwContext ctx) {
        Register r1 = programBuilder.getOrErrorRegister(mainThread, ctx.register(0).getText());
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        return programBuilder.addChild(mainThread, EventFactory.newStoreWithMo(ra, r1, getMo(ctx.moRISCV(0), ctx.moRISCV(1))));
	}

	@Override
	public Object visitLr(LitmusRISCVParser.LrContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        return programBuilder.addChild(mainThread, EventFactory.newRMWLoadExclusiveWithMo(r1, ra, getMo(ctx.moRISCV(0), ctx.moRISCV(1))));
	}

	@Override
	public Object visitSc(LitmusRISCVParser.ScContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        Register ra = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, EventFactory.Common.newExclusiveStore(r1, ra, r2, getMo(ctx.moRISCV(0), ctx.moRISCV(1))));
	}

	@Override
	public Object visitLabel(LitmusRISCVParser.LabelContext ctx) {
		return programBuilder.addChild(mainThread, programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText()));
	}

	@Override
	public Object visitBranchCond(LitmusRISCVParser.BranchCondContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        Expression expr = expressions.makeBinary(r1, ctx.cond().op, r2);
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
		String moR = mo1 != null ? mo1.mo : "";
		String moW = mo2 != null ? mo2.mo : "";
		return !moR.isEmpty() ? (!moW.isEmpty() ? Tag.RISCV.MO_ACQ_REL : moR) : moW;
	}
}
