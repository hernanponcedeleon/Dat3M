package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.LitmusLISABaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusLISAParser;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.misc.Interval;

public class VisitorLitmusLISA extends LitmusLISABaseVisitor<Object> {

    private final ProgramBuilder programBuilder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
    private final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    private final IntegerType archType = programBuilder.getTypeFactory().getArchType();
    private int mainThread;
    private int threadCount = 0;

    public VisitorLitmusLISA() {
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusLISAParser.MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
        if (ctx.assertionList() != null) {
            int a = ctx.assertionList().getStart().getStartIndex();
            int b = ctx.assertionList().getStop().getStopIndex();
            String raw = ctx.assertionList().getStart().getInputStream().getText(new Interval(a, b));
            programBuilder.setAssert(AssertionHelper.parseAssertionList(programBuilder, raw));
        }
        if (ctx.assertionFilter() != null) {
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
        IntLiteral value = expressions.parseValue(ctx.constant().getText(), archType);
        programBuilder.initLocEqConst(ctx.location().getText(), value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusLISAParser.VariableDeclaratorRegisterContext ctx) {
        IntLiteral value = expressions.parseValue(ctx.constant().getText(), archType);
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
        for (LitmusLISAParser.ThreadIdContext threadCtx : ctx.threadId()) {
            programBuilder.newThread(threadCtx.id);
            threadCount++;
        }
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override
    public Object visitInstructionRow(LitmusLISAParser.InstructionRowContext ctx) {
        for (int i = 0; i < threadCount; i++) {
            mainThread = i;
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

    @Override
    public Object visitLoad(LitmusLISAParser.LoadContext ctx) {
        Register reg = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        Expression address = (Expression) ctx.expression().accept(this);
        String mo = ctx.mo() != null ? ctx.mo().getText() : "";
        programBuilder.addChild(mainThread, EventFactory.newLoadWithMo(reg, address, mo));
        return null;
    }

    @Override
    public Object visitLocal(LitmusLISAParser.LocalContext ctx) {
        Register reg = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        Expression e = (Expression) ctx.expression().accept(this);
        programBuilder.addChild(mainThread, EventFactory.newLocal(reg, e));
        return null;
    }

    @Override
    public Object visitStore(LitmusLISAParser.StoreContext ctx) {
        Expression value = (Expression) ctx.value().accept(this);
        Expression address = (Expression) ctx.expression().accept(this);
        String mo = ctx.mo() != null ? ctx.mo().getText() : "";
        programBuilder.addChild(mainThread, EventFactory.newStoreWithMo(address, value, mo));
        return null;

    }

    @Override
    public Object visitRmw(LitmusLISAParser.RmwContext ctx) {
        Register reg = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        Expression value = (Expression) ctx.value().accept(this);
        Expression address = (Expression) ctx.expression().accept(this);
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
        Label label = programBuilder.getOrCreateLabel(mainThread, name.substring(0, name.length() - 1));
        programBuilder.addChild(mainThread, label);
        return null;
    }

    @Override
    public Object visitJump(LitmusLISAParser.JumpContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.labelName().getText());
        Register reg = (Register) ctx.register().accept(this);
        Expression cond = expressions.makeBooleanCast(reg);
		programBuilder.addChild(mainThread, EventFactory.newJump(cond, label));
		return null;
	}

    // Other

    @Override
    public Object visitLocation(LitmusLISAParser.LocationContext ctx) {
        return programBuilder.getOrNewMemoryObject(ctx.getText());
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
        Expression e1 = (Expression) ctx.expression(0).accept(this);
        Expression e2 = (Expression) ctx.expression(1).accept(this);
        return expressions.makeADD(e1, e2);
    }

    @Override
    public Object visitSub(LitmusLISAParser.SubContext ctx) {
        Expression e1 = (Expression) ctx.expression(0).accept(this);
        Expression e2 = (Expression) ctx.expression(1).accept(this);
        return expressions.makeSUB(e1, e2);
    }

    @Override
    public Object visitXor(LitmusLISAParser.XorContext ctx) {
        Expression e1 = (Expression) ctx.expression(0).accept(this);
        Expression e2 = (Expression) ctx.expression(1).accept(this);
        return expressions.makeXOR(e1, e2);
    }

    @Override
    public Object visitOr(LitmusLISAParser.OrContext ctx) {
        Expression e1 = (Expression) ctx.expression(0).accept(this);
        Expression e2 = (Expression) ctx.expression(1).accept(this);
        return expressions.makeOR(e1, e2);
    }

    @Override
    public Object visitAnd(LitmusLISAParser.AndContext ctx) {
        Expression e1 = (Expression) ctx.expression(0).accept(this);
        Expression e2 = (Expression) ctx.expression(1).accept(this);
        return expressions.makeAND(e1, e2);
    }

	@Override
	public Object visitEq(LitmusLISAParser.EqContext ctx) {
		Expression e1 = (Expression) ctx.expression(0).accept(this);
		Expression e2 = (Expression) ctx.expression(1).accept(this);
		return expressions.makeCast(expressions.makeEQ(e1, e2), archType);
	}

	@Override
	public Object visitNeq(LitmusLISAParser.NeqContext ctx) {
		Expression e1 = (Expression) ctx.expression(0).accept(this);
		Expression e2 = (Expression) ctx.expression(1).accept(this);
		return expressions.makeCast(expressions.makeNEQ(e1, e2), archType);
	}

    @Override
    public Object visitParaExpr(LitmusLISAParser.ParaExprContext ctx) {
        return ctx.expression().accept(this);
    }

    @Override
    public Object visitArrayAccess(LitmusLISAParser.ArrayAccessContext ctx) {
        MemoryObject base = (MemoryObject) ctx.location().accept(this);
        Expression offset = (Expression) ctx.value().accept(this);
        return expressions.makeADD(base, offset);
    }

}
