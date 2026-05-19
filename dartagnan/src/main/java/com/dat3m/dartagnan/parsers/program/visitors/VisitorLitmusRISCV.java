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

import java.util.List;

import static com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder.replaceZeroRegisters;
import static com.dat3m.dartagnan.program.event.EventFactory.RISCV.MemoryOrder.*;

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
        Register register = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return append(EventFactory.newLocal(register, constant), ctx);
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
	public Object visitLabel(LabelContext ctx) {
		return append(programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText()), ctx);
	}

	@Override
	public Object visitBranchCond(BranchCondContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
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
		throw new UnsupportedOperationException("No support for amoadd instructions");
    }

	@Override
	public Object visitAmoor(AmoorContext ctx) {
		throw new UnsupportedOperationException("No support for amoor instructions");	}

	@Override
	public Object visitAmoswap(AmoswapContext ctx) {
		throw new UnsupportedOperationException("No support for amoswap instructions");
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
}
