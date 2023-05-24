package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.Linux;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.Literal;

import java.util.Arrays;
import java.util.List;

public class LkmmProcedures {

	public static List<String> LKMMPROCEDURES = Arrays.asList(
			"__LKMM_LOAD",
			"__LKMM_STORE",
			"__LKMM_XCHG",
			"__LKMM_CMPXCHG",
			"__LKMM_ATOMIC_FETCH_OP",
			"__LKMM_ATOMIC_OP",
			"__LKMM_ATOMIC_OP_RETURN",
			"__LKMM_FENCE",
			"__LKMM_SPIN_LOCK",
			"__LKMM_SPIN_UNLOCK");

	public static void handleLkmmFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();

		String registerName = visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText();
		Register reg = visitor.thread.getOrNewRegister(registerName, visitor.types.getIntegerType());
		
		Object p0 = params.get(0).accept(visitor);
		int i0 = p0 instanceof Literal ? ((Literal) p0).getValueAsInt() : -1;
		Object p1 = params.size() > 1 ? params.get(1).accept(visitor) : null;
		int i1 = p1 instanceof Literal ? ((Literal) p1).getValueAsInt() : -1;
		Object p2 = params.size() > 2 ? params.get(2).accept(visitor) : null;
		int i2 = p2 instanceof Literal ? ((Literal) p2).getValueAsInt() : -1;
		Object p3 = params.size() > 3 ? params.get(3).accept(visitor) : null;
		int i3 = p3 instanceof Literal ? ((Literal) p3).getValueAsInt() : -1;

		String mo;
		IOpBin op;
		
		switch (name) {
		case "__LKMM_LOAD":
			mo = Linux.intToMo(i1);
			visitor.append(EventFactory.Linux.newLKMMLoad(reg, (Expression) p0, mo));
	        return;
		case "__LKMM_STORE":
			mo = Linux.intToMo(i2);
			visitor.append(EventFactory.Linux.newLKMMStore((Expression) p0, (Expression) p1, mo.equals(Linux.MO_MB) ? Tag.Linux.MO_ONCE : mo));
	        if(mo.equals(Tag.Linux.MO_MB)){
	            visitor.append(EventFactory.Linux.newMemoryBarrier());
	        }
	        return;
		case "__LKMM_XCHG":
			mo = Linux.intToMo(i2);
			visitor.append(EventFactory.Linux.newRMWExchange((Expression) p0, reg, (Expression) p1, mo));
			return;
		case "__LKMM_CMPXCHG":
			mo = Linux.intToMo(i3);
			visitor.append(EventFactory.Linux.newRMWCompareExchange((Expression) p0, reg, (Expression) p1, (Expression) p2, mo));
			return;
		case "__LKMM_ATOMIC_FETCH_OP":
			mo = Linux.intToMo(i2);
			op = IOpBin.intToOp(i3);
	        visitor.append(EventFactory.Linux.newRMWFetchOp((Expression) p0, reg, (Expression) p1, op, mo));
			return;
		case "__LKMM_ATOMIC_OP_RETURN":
			mo = Linux.intToMo(i2);
			op = IOpBin.intToOp(i3);
	        visitor.append(EventFactory.Linux.newRMWOpReturn((Expression) p0, reg, (Expression) p1, op, mo));
			return;
		case "__LKMM_ATOMIC_OP":
			op = IOpBin.intToOp(i2);
	        visitor.append(EventFactory.Linux.newRMWOp((Expression) p0, reg, (Expression) p1, op));
			return;
		case "__LKMM_FENCE":
			String fence = Linux.intToMo(i0);
			visitor.append(EventFactory.Linux.newLKMMFence(fence));
			return;
		case "__LKMM_SPIN_LOCK":
			visitor.append(EventFactory.Linux.newLock((Expression) p0));
			return;
		case "__LKMM_SPIN_UNLOCK":
			visitor.append(EventFactory.Linux.newUnlock((Expression) p0));
			return;
		default:
			throw new UnsupportedOperationException(name + " procedure is not part of LKMMPROCEDURES");
		}
	}
}
