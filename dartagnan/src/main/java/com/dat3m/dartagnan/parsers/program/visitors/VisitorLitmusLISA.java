package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusLISABaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusLISAParser;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.misc.Interval;

public class VisitorLitmusLISA extends LitmusLISABaseVisitor<Object> {

	private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final ProgramBuilder programBuilder;
	private final IntegerType archType = TypeFactory.getInstance().getArchType();
    private int mainThread;
    private int threadCount = 0;

    public VisitorLitmusLISA(ProgramBuilder pb){
        this.programBuilder = pb;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusLISAParser.MainContext ctx) {
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

	@Override
	public Object visitVariableDeclaratorLocation(LitmusLISAParser.VariableDeclaratorLocationContext ctx) {
		IValue value = expressions.parseValue(ctx.constant().getText(), archType);
		programBuilder.initLocEqConst(ctx.location().getText(), value);
		return null;
	}

	@Override
	public Object visitVariableDeclaratorRegister(LitmusLISAParser.VariableDeclaratorRegisterContext ctx) {
		IValue value = expressions.parseValue(ctx.constant().getText(), archType);
		programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(), value);
		return null;
	}

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusLISAParser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(), archType);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(LitmusLISAParser.VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions), e.g. " P0  |   P1  |   P2  ;"

    @Override
    public Object visitThreadDeclaratorList(LitmusLISAParser.ThreadDeclaratorListContext ctx) {
        for(LitmusLISAParser.ThreadIdContext threadCtx : ctx.threadId()){
            programBuilder.initThread(threadCtx.id);
            threadCount++;
        }
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override
    public Object visitInstructionRow(LitmusLISAParser.InstructionRowContext ctx) {
        for(int i = 0; i < threadCount; i++){
            mainThread = i;
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

	@Override
	public Object visitLoad(LitmusLISAParser.LoadContext ctx) {
        Register reg = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        IExpr address = (IExpr) ctx.expression().accept(this);
        String mo = ctx.mo() != null ? ctx.mo().getText() : "";
		programBuilder.addChild(mainThread, EventFactory.newLoad(reg, address, mo));
		return null;
	}

	@Override
	public Object visitLocal(LitmusLISAParser.LocalContext ctx) {
        Register reg = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
		ExprInterface e = (ExprInterface) ctx.expression().accept(this);
        programBuilder.addChild(mainThread, EventFactory.newLocal(reg, e));
		return null;
	}

	@Override
	public Object visitStore(LitmusLISAParser.StoreContext ctx) {
		IExpr value = (IExpr) ctx.value().accept(this);
        IExpr address = (IExpr) ctx.expression().accept(this);
        String mo = ctx.mo() != null ? ctx.mo().getText() : "";
        programBuilder.addChild(mainThread, EventFactory.newStore(address, value, mo));
		return null;

	}

	@Override
	public Object visitRmw(LitmusLISAParser.RmwContext ctx) {
        Register reg = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
		IExpr value = (IExpr) ctx.value().accept(this);
        IExpr address = (IExpr) ctx.expression().accept(this);
        String mo = ctx.mo() != null ? ctx.mo().getText() : "";
        programBuilder.addChild(mainThread, EventFactory.LISA.newRMW(address, reg, value, mo));
		return null;
	}

	@Override
	public Object visitFence(LitmusLISAParser.FenceContext ctx) {
        String mo = ctx.mo() != null ? ctx.mo().getText() : "";
        programBuilder.addChild(mainThread, EventFactory.newFence(mo));
		return null;
	}

	@Override
	public Object visitLabel(LitmusLISAParser.LabelContext ctx) {
		String name = ctx.getText();
        Label label = programBuilder.getOrCreateLabel(name.substring(0, name.length()-1));
		programBuilder.addChild(mainThread, label);
		return null;
	}

	@Override
	public Object visitJump(LitmusLISAParser.JumpContext ctx) {
        Label label = programBuilder.getOrCreateLabel(ctx.labelName().getText());
        Register reg = (Register) ctx.register().accept(this);
		ExprInterface one = expressions.makeOne(reg.getType());
        ExprInterface cond = expressions.makeEqual(reg, one);
		programBuilder.addChild(mainThread, EventFactory.newJump(cond, label));
		return null;
	}

	// Other

	@Override
	public Object visitLocation(LitmusLISAParser.LocationContext ctx) {
		return programBuilder.getOrNewObject(ctx.getText());
	}

	@Override
	public Object visitRegister(LitmusLISAParser.RegisterContext ctx) {
		return programBuilder.getOrNewRegister(mainThread, ctx.getText(), archType);
	}

	@Override
	public Object visitConstant(LitmusLISAParser.ConstantContext ctx) {
		return expressions.parseValue(ctx.getText(), archType);
	}

	@Override
	public Object visitAdd(LitmusLISAParser.AddContext ctx) {
		IExpr e1 = (IExpr) ctx.expression(0).accept(this);
		IExpr e2 = (IExpr) ctx.expression(1).accept(this);
		return expressions.makePlus(e1, e2);
	}

	@Override
	public Object visitSub(LitmusLISAParser.SubContext ctx) {
		IExpr e1 = (IExpr) ctx.expression(0).accept(this);
		IExpr e2 = (IExpr) ctx.expression(1).accept(this);
		return expressions.makeMinus(e1, e2);
	}

	@Override
	public Object visitXor(LitmusLISAParser.XorContext ctx) {
		IExpr e1 = (IExpr) ctx.expression(0).accept(this);
		IExpr e2 = (IExpr) ctx.expression(1).accept(this);
		return expressions.makeXor(e1, e2);
	}

	@Override
	public Object visitOr(LitmusLISAParser.OrContext ctx) {
		IExpr e1 = (IExpr) ctx.expression(0).accept(this);
		IExpr e2 = (IExpr) ctx.expression(1).accept(this);
		return expressions.makeBitwiseOr(e1, e2);
	}

	@Override
	public Object visitAnd(LitmusLISAParser.AndContext ctx) {
		IExpr e1 = (IExpr) ctx.expression(0).accept(this);
		IExpr e2 = (IExpr) ctx.expression(1).accept(this);
		return expressions.makeBitwiseAnd(e1, e2);
	}

	@Override
	public Object visitEq(LitmusLISAParser.EqContext ctx) {
		ExprInterface e1 = (ExprInterface) ctx.expression(0).accept(this);
		ExprInterface e2 = (ExprInterface) ctx.expression(1).accept(this);
		return expressions.makeEqual(e1, e2);
	}

	@Override
	public Object visitNeq(LitmusLISAParser.NeqContext ctx) {
		ExprInterface e1 = (ExprInterface) ctx.expression(0).accept(this);
		ExprInterface e2 = (ExprInterface) ctx.expression(1).accept(this);
		return expressions.makeNotEqual(e1, e2);
	}

	@Override
	public Object visitParaExpr(LitmusLISAParser.ParaExprContext ctx) {
		return ctx.expression().accept(this);
	}

	@Override
	public Object visitArrayAccess(LitmusLISAParser.ArrayAccessContext ctx) {
		MemoryObject base = (MemoryObject) ctx.location().accept(this);
		IExpr offset = (IExpr) ctx.value().accept(this);
		return expressions.makePlus(base, offset);
	}

}
