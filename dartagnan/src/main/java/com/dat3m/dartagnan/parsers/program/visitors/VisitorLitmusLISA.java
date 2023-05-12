package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.LitmusLISABaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusLISAParser.*;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.EventIdReassignment;
import org.antlr.v4.runtime.misc.Interval;

import java.util.HashMap;
import java.util.Map;

public class VisitorLitmusLISA extends LitmusLISABaseVisitor<Object> {

	private final Program program = new Program(Program.SourceLanguage.LITMUS);
	private final TypeFactory types = TypeFactory.getInstance();
	private final ExpressionFactory expressions = ExpressionFactory.getInstance();
	private final Type type = types.getPointerType();
	private Thread[] threadList;
	private Thread thread;
	private final Map<String, Label> labelMap = new HashMap<>();

	// ----------------------------------------------------------------------------------------------------------------
	// Entry point

	@Override
	public Object visitMain(MainContext ctx) {
		visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
		visitVariableDeclaratorList(ctx.variableDeclaratorList());
		visitInstructionList(ctx.program().instructionList());
		if (ctx.assertionList() != null) {
			int a = ctx.assertionList().getStart().getStartIndex();
			int b = ctx.assertionList().getStop().getStopIndex();
			String raw = ctx.assertionList().getStart().getInputStream().getText(new Interval(a, b));
			AssertionHelper.parseAssertionList(program, raw);
		}
		if (ctx.assertionFilter() != null) {
			int a = ctx.assertionFilter().getStart().getStartIndex();
			int b = ctx.assertionFilter().getStop().getStopIndex();
			String raw = ctx.assertionFilter().getStart().getInputStream().getText(new Interval(a, b));
			AssertionHelper.parseAssertionFilter(program, raw);
		}
		for (Thread thread : threadList) {
			thread.append(labelMap.computeIfAbsent(thread.getEndLabelName(), EventFactory::newLabel));
		}
		EventIdReassignment.newInstance().run(program);
		program.getEvents().forEach(e -> e.setOId(e.getGlobalId()));
		return program;
	}


	// ----------------------------------------------------------------------------------------------------------------

	@Override
	public Object visitVariableDeclaratorLocation(VariableDeclaratorLocationContext ctx) {
		MemoryObject object = program.getMemory().getOrNewObject(ctx.location().getText());
		IValue value = expressions.parseValue(ctx.constant().getText(), type);
		object.setInitialValue(0, value);
		return null;
	}

	@Override
	public Object visitVariableDeclaratorRegister(VariableDeclaratorRegisterContext ctx) {
		Thread thread = program.getOrNewThread(Integer.toString(ctx.threadId().id));
		Register register = thread.getOrNewRegister(ctx.register().getText(), type);
		IValue value = expressions.parseValue(ctx.constant().getText(), type);
		thread.append(EventFactory.newLocal(register, value));
		return null;
	}

	@Override
	public Object visitVariableDeclaratorRegisterLocation(VariableDeclaratorRegisterLocationContext ctx) {
		Thread thread = program.getOrNewThread(Integer.toString(ctx.threadId().id));
		Register register = thread.getOrNewRegister(ctx.register().getText(), type);
		MemoryObject value = program.getMemory().getOrNewObject(ctx.location().getText());
		thread.append(EventFactory.newLocal(register, value));
		return null;
	}

	@Override
	public Object visitVariableDeclaratorLocationLocation(VariableDeclaratorLocationLocationContext ctx) {
		MemoryObject object = program.getMemory().getOrNewObject(ctx.location(0).getText());
		MemoryObject value = program.getMemory().getOrNewObject(ctx.location(1).getText());
		object.setInitialValue(0, value);
		return null;
	}


	// ----------------------------------------------------------------------------------------------------------------
	// Thread declarator list (on top of instructions), e.g. " P0  |   P1  |   P2  ;"

	@Override
	public Object visitThreadDeclaratorList(ThreadDeclaratorListContext ctx) {
		threadList = new Thread[ctx.threadId().size()];
		for (int i = 0; i < threadList.length; i++) {
			threadList[i] = program.getOrNewThread(Integer.toString(ctx.threadId(i).id));
		}
		return null;
	}


	// ----------------------------------------------------------------------------------------------------------------
	// Instruction list (the program itself)

	@Override
	public Object visitInstructionRow(InstructionRowContext ctx) {
		for (int i = 0; i < threadList.length; i++) {
			thread = threadList[i];
			visitInstruction(ctx.instruction(i));
		}
		return null;
	}

	@Override
	public Object visitLoad(LoadContext ctx) {
		Register result = thread.getOrNewRegister(ctx.register().getText(), type);
		Expression address = (Expression) ctx.expression().accept(this);
		String mo = ctx.mo() != null ? ctx.mo().getText() : "";
		thread.append(EventFactory.newLoad(result, address, mo));
		return null;
	}

	@Override
	public Object visitLocal(LocalContext ctx) {
		Register result = thread.getOrNewRegister(ctx.register().getText(), type);
		Expression expression = (Expression) ctx.expression().accept(this);
		thread.append(EventFactory.newLocal(result, expression));
		return null;
	}

	@Override
	public Object visitStore(StoreContext ctx) {
		Expression value = (Expression) ctx.value().accept(this);
		Expression address = (Expression) ctx.expression().accept(this);
		String mo = ctx.mo() != null ? ctx.mo().getText() : "";
		thread.append(EventFactory.newStore(address, value, mo));
		return null;

	}

	@Override
	public Object visitRmw(RmwContext ctx) {
		Register result = thread.getOrNewRegister(ctx.register().getText(), type);
		Expression value = (Expression) ctx.value().accept(this);
		Expression address = (Expression) ctx.expression().accept(this);
		String mo = ctx.mo() != null ? ctx.mo().getText() : "";
		thread.append(EventFactory.LISA.newRMW(address, result, value, mo));
		return null;
	}

	@Override
	public Object visitFence(FenceContext ctx) {
		String mo = ctx.mo() != null ? ctx.mo().getText() : "";
		thread.append(EventFactory.newFence(mo));
		return null;
	}

	@Override
	public Object visitLabel(LabelContext ctx) {
		String name = ctx.getText();
		Label label = labelMap.computeIfAbsent(name.substring(0, name.length() - 1), EventFactory::newLabel);
		thread.append(label);
		return null;
	}

	@Override
	public Object visitJump(JumpContext ctx) {
		Label label = labelMap.computeIfAbsent(ctx.labelName().getText(), EventFactory::newLabel);
		Register left = (Register) ctx.register().accept(this);
		Expression condition = expressions.makeBinary(left, COpBin.EQ, IValue.ONE);
		thread.append(EventFactory.newJump(condition, label));
		return null;
	}

	// Other

	@Override
	public Object visitLocation(LocationContext ctx) {
		return program.getMemory().getOrNewObject(ctx.getText());
	}

	@Override
	public Object visitRegister(RegisterContext ctx) {
		return thread.getOrNewRegister(ctx.getText(), type);
	}

	@Override
	public Object visitConstant(ConstantContext ctx) {
		return expressions.parseValue(ctx.getText(), type);
	}

	@Override
	public Object visitAdd(AddContext ctx) {
		Expression e1 = (Expression) ctx.expression(0).accept(this);
		Expression e2 = (Expression) ctx.expression(1).accept(this);
		return expressions.makeBinary(e1, IOpBin.PLUS, e2);
	}

	@Override
	public Object visitSub(SubContext ctx) {
		Expression e1 = (Expression) ctx.expression(0).accept(this);
		Expression e2 = (Expression) ctx.expression(1).accept(this);
		return expressions.makeBinary(e1, IOpBin.MINUS, e2);
	}

	@Override
	public Object visitXor(XorContext ctx) {
		Expression e1 = (Expression) ctx.expression(0).accept(this);
		Expression e2 = (Expression) ctx.expression(1).accept(this);
		return expressions.makeBinary(e1, IOpBin.XOR, e2);
	}

	@Override
	public Object visitOr(OrContext ctx) {
		Expression e1 = (Expression) ctx.expression(0).accept(this);
		Expression e2 = (Expression) ctx.expression(1).accept(this);
		return expressions.makeBinary(e1, IOpBin.OR, e2);
	}

	@Override
	public Object visitAnd(AndContext ctx) {
		Expression e1 = (Expression) ctx.expression(0).accept(this);
		Expression e2 = (Expression) ctx.expression(1).accept(this);
		return expressions.makeBinary(e1, IOpBin.AND, e2);
	}

	@Override
	public Object visitEq(EqContext ctx) {
		Expression e1 = (Expression) ctx.expression(0).accept(this);
		Expression e2 = (Expression) ctx.expression(1).accept(this);
		return expressions.makeBinary(e1, COpBin.EQ, e2);
	}

	@Override
	public Object visitNeq(NeqContext ctx) {
		Expression e1 = (Expression) ctx.expression(0).accept(this);
		Expression e2 = (Expression) ctx.expression(1).accept(this);
		return expressions.makeBinary(e1, COpBin.NEQ, e2);
	}

	@Override
	public Object visitParaExpr(ParaExprContext ctx) {
		return ctx.expression().accept(this);
	}

	@Override
	public Object visitArrayAccess(ArrayAccessContext ctx) {
		MemoryObject base = (MemoryObject) ctx.location().accept(this);
		Expression offset = (Expression) ctx.value().accept(this);
		return expressions.makeBinary(base, IOpBin.PLUS, offset);
	}

}
