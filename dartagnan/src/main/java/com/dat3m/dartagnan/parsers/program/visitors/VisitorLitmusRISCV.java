package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusRISCVBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusRISCVParser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;

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
        VisitorLitmusAssertions.parseAssertions(programBuilder, ctx.assertionList(), ctx.assertionFilter());
        Program prog = programBuilder.build();
        replaceX0Register(prog);

        return prog;
    }

    /*
    The "x0" register plays a special role in RISCV:
      1. Reading accesses always return the value 0.
      2. Writing accesses are discarded.
     TODO: The below code is a simple fix to guarantee point 1. above.
      Point 2. might also be resolved: although we do not prevent writing to x0,
      the value of x0 is never read after the transformation so its value is effectively 0.
      However, the exists/forall clauses could still refer to that register and observe a non-zero value.
     */
    private void replaceX0Register(Program program) {
        final ExpressionVisitor<Expression> x0Replacer = new ExprTransformer() {
            @Override
            public Expression visitRegister(Register reg) {
                return reg.getName().equals("x0") ? expressions.makeGeneralZero(reg.getType()) : reg;
            }
        };
        program.getThreadEvents(RegReader.class)
                .forEach(e -> e.transformExpressions(x0Replacer));
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list

    @Override
    public Object visitVariableDeclaratorLocation(LitmusRISCVParser.VariableDeclaratorLocationContext ctx) {
        IntLiteral value = expressions.parseValue(ctx.constant().getText(), archType);
        programBuilder.initLocEqConst(ctx.location().getText(), value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusRISCVParser.VariableDeclaratorRegisterContext ctx) {
        IntLiteral value = expressions.parseValue(ctx.constant().getText(), archType);
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
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, constant));
	}

	@Override
	public Object visitXor(LitmusRISCVParser.XorContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeIntXor(r2, r3)));

	}

	@Override
	public Object visitAnd(LitmusRISCVParser.AndContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeIntAnd(r2, r3)));

	}

	@Override
	public Object visitOr(LitmusRISCVParser.OrContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeIntOr(r2, r3)));

	}

	@Override
	public Object visitAdd(LitmusRISCVParser.AddContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeAdd(r2, r3)));

	}

	@Override
	public Object visitXori(LitmusRISCVParser.XoriContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeIntXor(r2, constant)));
	}

	@Override
	public Object visitAndi(LitmusRISCVParser.AndiContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeIntAnd(r2, constant)));
	}

	@Override
	public Object visitOri(LitmusRISCVParser.OriContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeIntOr(r2, constant)));
	}

	@Override
	public Object visitAddi(LitmusRISCVParser.AddiContext ctx) {
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(r1, expressions.makeAdd(r2, constant)));
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
        Expression expr = expressions.makeIntCmp(r1, ctx.cond().op, r2);
        return programBuilder.addChild(mainThread, EventFactory.newJump(expr, label));
	}

	@Override
	public Object visitFence(LitmusRISCVParser.FenceContext ctx) {
        String mo = ctx.fenceMode().mode;
        Event fence = switch(mo) {
            case "r.r" -> EventFactory.RISCV.newRRFence();
            case "r.w" -> EventFactory.RISCV.newRWFence();
            case "r.rw" -> EventFactory.RISCV.newRRWFence();
            case "w.r" -> EventFactory.RISCV.newWRFence();
            case "w.w" -> EventFactory.RISCV.newWWFence();
            case "w.rw" -> EventFactory.RISCV.newWRWFence();
            case "rw.r" -> EventFactory.RISCV.newRWRFence();
            case "rw.w" -> EventFactory.RISCV.newRWWFence();
            case "rw.rw" -> EventFactory.RISCV.newRWRWFence();
            case "tso" -> EventFactory.RISCV.newTsoFence();
            case "i" -> EventFactory.RISCV.newSynchronizeFence();
            default -> throw new ParsingException("Invalid fence mode " + mo);
        };
		return programBuilder.addChild(mainThread, fence);
	}

	@Override
	public Object visitAmoadd(LitmusRISCVParser.AmoaddContext ctx) {
		throw new ParsingException("No support for amoadd instructions");
    }

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
