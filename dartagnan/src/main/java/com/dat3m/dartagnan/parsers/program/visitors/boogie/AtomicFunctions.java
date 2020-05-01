package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import static com.dat3m.dartagnan.program.atomic.utils.Mo.intToMo;

import java.util.Arrays;
import java.util.List;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.atomic.event.Atomic_Load_Explicit;
import com.dat3m.dartagnan.program.atomic.event.Atomic_Store_Explicit;
import com.dat3m.dartagnan.program.memory.Address;
import com.google.common.base.Joiner;

public class AtomicFunctions {

	public static List<String> ATOMICFUNCTIONS = Arrays.asList(
			"atomic_store_explicit",
			"atomic_load_explicit");
	
	public static void handleAtomicFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		switch(name) {
		case "atomic_store_explicit":
			atomicStoreExplicit(visitor, ctx);
			return;
		case "atomic_load_explicit":
			atomicLoadExplicit(visitor, ctx);
			return;
		default:
        	throw new UnsupportedOperationException(name + " funcition is not part of " + Joiner.on(",").join(ATOMICFUNCTIONS));
		}
	}
	
	private static void atomicStoreExplicit(VisitorBoogie visitor, Call_cmdContext ctx) {
		Address add = (Address)ctx.call_params().exprs().expr().get(0).accept(visitor);
		ExprInterface value = (ExprInterface)ctx.call_params().exprs().expr().get(1).accept(visitor);
		String mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(2).accept(visitor)).getValue());
		visitor.programBuilder.addChild(visitor.threadCount, new Atomic_Store_Explicit(add, value, mo));
	}

	private static void atomicLoadExplicit(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText());
		Address add = (Address)ctx.call_params().exprs().expr().get(0).accept(visitor);
		String mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(1).accept(visitor)).getValue());
		visitor.programBuilder.addChild(visitor.threadCount, new Atomic_Load_Explicit(reg, add, mo));
	}
}
