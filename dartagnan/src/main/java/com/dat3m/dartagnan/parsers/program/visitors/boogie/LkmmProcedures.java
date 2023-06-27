package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.Linux;

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

		Register reg = visitor.programBuilder.getOrNewRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText());
		
		Expression p0 = (Expression) params.get(0).accept(visitor);
		Expression p1 = params.size() > 1 ? (Expression) params.get(1).accept(visitor) : null;
		Expression p2 = params.size() > 2 ? (Expression) params.get(2).accept(visitor) : null;
		Expression p3 = params.size() > 3 ? (Expression) params.get(3).accept(visitor) : null;
		
		String mo;
		IOpBin op;
		
		switch (name) {
		case "__LKMM_LOAD":
			mo = Linux.intToMo(((IConst) p1).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newLKMMLoad(reg, p0, mo))
	        		.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
	        return;
		case "__LKMM_STORE":
			mo = Linux.intToMo(((IConst) p2).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newLKMMStore(p0, p1, mo.equals(Linux.MO_MB) ? Tag.Linux.MO_ONCE : mo))
					.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
	        if(mo.equals(Tag.Linux.MO_MB)){
	            visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newMemoryBarrier())
						.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
	        }
	        return;
		case "__LKMM_XCHG":
			mo = Linux.intToMo(((IConst) p2).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWExchange(p0, reg, p1, mo))
					.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
			return;
		case "__LKMM_CMPXCHG":
			mo = Linux.intToMo(((IConst) p3).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWCompareExchange(p0, reg, p1, p2, mo))
					.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
			return;
		case "__LKMM_ATOMIC_FETCH_OP":
			mo = Linux.intToMo(((IConst) p2).getValueAsInt());
			op = IOpBin.intToOp(((IConst) p3).getValueAsInt());
	        visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWFetchOp(p0, reg, p1, op, mo))
					.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
			return;
		case "__LKMM_ATOMIC_OP_RETURN":
			mo = Linux.intToMo(((IConst) p2).getValueAsInt());
			op = IOpBin.intToOp(((IConst) p3).getValueAsInt());
	        visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWOpReturn(p0, reg, p1, op, mo))
					.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
			return;
		case "__LKMM_ATOMIC_OP":
			op = IOpBin.intToOp(((IConst) p2).getValueAsInt());
	        visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWOp(p0, reg, op))
					.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
			return;
		case "__LKMM_FENCE":
			String fence = Linux.intToMo(((IConst) p0).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newLKMMFence(fence))
					.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
			return;
		case "__LKMM_SPIN_LOCK":
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newLock(p0))
					.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
			return;
		case "__LKMM_SPIN_UNLOCK":
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newUnlock(p0))
					.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
			return;
		default:
			throw new UnsupportedOperationException(name + " procedure is not part of LKMMPROCEDURES");
		}
	}
}
