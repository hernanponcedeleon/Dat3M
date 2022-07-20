package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
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

		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), GlobalSettings.ARCH_PRECISION);
		
		Object p0 = params.get(0).accept(visitor);
		Object p1 = params.size() > 1 ? params.get(1).accept(visitor) : null;
		Object p2 = params.size() > 2 ? params.get(2).accept(visitor) : null;
		Object p3 = params.size() > 3 ? params.get(3).accept(visitor) : null;
		
		String mo;
		IOpBin op;
		
		switch (name) {
		case "__LKMM_LOAD":
			mo = Linux.intToMo(((IConst) p1).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newLKMMLoad(reg, (IExpr) p0, mo))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
	        return;
		case "__LKMM_STORE":
			mo = Linux.intToMo(((IConst) p2).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newLKMMStore((IExpr) p0, (IExpr) p1, mo.equals(Linux.MO_MB) ? Tag.Linux.MO_ONCE : mo))
    				.setCLine(visitor.currentLine)
    				.setSourceCodeFile(visitor.sourceCodeFile);
	        if(mo.equals(Tag.Linux.MO_MB)){
	            visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newMemoryBarrier())
        				.setCLine(visitor.currentLine)
        				.setSourceCodeFile(visitor.sourceCodeFile);
	        }
	        return;
		case "__LKMM_XCHG":
			mo = Linux.intToMo(((IConst) p2).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWExchange((IExpr) p0, reg, (IExpr) p1, mo))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		case "__LKMM_CMPXCHG":
			mo = Linux.intToMo(((IConst) p3).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWCompareExchange((IExpr) p0, reg, (IExpr) p1, (IExpr) p2, mo))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		case "__LKMM_ATOMIC_FETCH_OP":
			mo = Linux.intToMo(((IConst) p2).getValueAsInt());
			op = IOpBin.intToOp(((IConst) p3).getValueAsInt());
	        visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWFetchOp((IExpr) p0, reg, (IExpr) p1, op, mo))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		case "__LKMM_ATOMIC_OP_RETURN":
			mo = Linux.intToMo(((IConst) p2).getValueAsInt());
			op = IOpBin.intToOp(((IConst) p3).getValueAsInt());
	        visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWOpReturn((IExpr) p0, reg, (IExpr) p1, op, mo))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		case "__LKMM_ATOMIC_OP":
			op = IOpBin.intToOp(((IConst) p2).getValueAsInt());
	        visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWOp((IExpr) p0, reg, (IExpr) p1, op))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		case "__LKMM_FENCE":
			String fence = Linux.intToMo(((IConst) p0).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newLKMMFence(fence))
					.setCLine(visitor.currentLine)
					.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		case "__LKMM_SPIN_LOCK":
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newLock((IExpr) p0))
					.setCLine(visitor.currentLine)
					.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		case "__LKMM_SPIN_UNLOCK":
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newUnlock((IExpr) p0))
					.setCLine(visitor.currentLine)
					.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		default:
			throw new UnsupportedOperationException(name + " procedure is not part of LKMMPROCEDURES");
		}
	}
}
