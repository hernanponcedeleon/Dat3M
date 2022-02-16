package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;

import java.util.Arrays;
import java.util.List;

public class LkmmProcedures {

	public static List<String> LKMMPROCEDURES = Arrays.asList(
			"smp_mb",
			"WRITE_ONCE",
			"READ_ONCE");

	public static void handleLkmmFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		if(name.startsWith("WRITE_ONCE")) {
			IExpr address = (IExpr)ctx.call_params().exprs().expr(0).accept(visitor);
			ExprInterface value = (ExprInterface)ctx.call_params().exprs().expr(1).accept(visitor);
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newStore(address, value, "Once"));
			return;			
		}
		if(name.startsWith("READ_ONCE")) {
			Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
			IExpr address = (IExpr)ctx.call_params().exprs().expr(0).accept(visitor);
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newLoad(reg, address, "Once"));
			return;			
		}
		if(name.equals("smp_mb")) {
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newMemoryBarrier());
			return;			
		}
		throw new UnsupportedOperationException(name + " procedure is not part of LKMMPROCEDURES");
	}
}
