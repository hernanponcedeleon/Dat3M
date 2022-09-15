package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory.Atomic;
import com.dat3m.dartagnan.program.event.Tag.C11;
import java.util.Arrays;
import java.util.List;

public class LlvmProcedures {

	public static List<String> LLVMPROCEDURES = Arrays.asList(
			"my_load_atomic",
			"my_store_atomic",
			"my_atomicrmw_xchg",
			"my_atomicrmw_add",
			"my_atomicrmw_sub",
			"my_atomicrmw_and",
			"my_atomicrmw_or",
			"my_atomicrmw_xor");

	public static void handleLlvmFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
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
		case "my_load_atomic":
			mo = C11.intToMo(((IConst) p1).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, Atomic.newLoad(reg, (IExpr) p0, mo))
	        	.setCLine(visitor.currentLine)
	        	.setSourceCodeFile(visitor.sourceCodeFile);
	        return;
		case "my_store_atomic":
			mo = C11.intToMo(((IConst) p2).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, Atomic.newStore((IExpr) p0, (ExprInterface) p1, mo))
				.setCLine(visitor.currentLine)
				.setSourceCodeFile(visitor.sourceCodeFile);
	        return;
		case "my_atomicrmw_xchg":
			mo = C11.intToMo(((IConst) p2).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, Atomic.newExchange(reg, (IExpr) p0, (IExpr) p1, mo))
	        	.setCLine(visitor.currentLine)
	        	.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		default:
			throw new UnsupportedOperationException(name + " procedure is not part of LKMMPROCEDURES");
		}
	}
}
