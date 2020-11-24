package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import static com.dat3m.dartagnan.program.atomic.utils.Mo.intToMo;

import java.util.Arrays;
import java.util.List;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.atomic.event.AtomicFetchOp;
import com.dat3m.dartagnan.program.atomic.event.AtomicLoad;
import com.dat3m.dartagnan.program.atomic.event.AtomicStore;
import com.dat3m.dartagnan.program.atomic.event.AtomicThreadFence;
import com.dat3m.dartagnan.program.atomic.event.AtomicXchg;
import com.dat3m.dartagnan.program.event.Store;

public class AtomicProcedures {

	public static List<String> ATOMICPROCEDURES = Arrays.asList(
			"atomic_init",
			"atomic_store",
			"atomic_load",
			"atomic_fetch",
			"atomic_exchange",
			"atomic_thread_fence");
	
	public static void handleAtomicFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		if(name.contains("atomic_init")) {
			atomicInit(visitor, ctx);
			return;
		}
		if(name.contains("atomic_store")) {
			atomicStore(visitor, ctx);
			return;
		}
		if(name.contains("atomic_load")) {
			atomicLoad(visitor, ctx);
			return;
		}			
		if(name.contains("atomic_fetch")) {
			atomicFetchOp(visitor, ctx);
			return;
		}			
		if(name.contains("atomic_exchange")) {
			atomicXchg(visitor, ctx);
			return;
		}			
		if(name.contains("atomic_thread_fence")) {
			atomicThreadFence(visitor, ctx);
			return;
		}	
        throw new UnsupportedOperationException(name + " procedure is not part of ATOMICPROCEDURES");
	}
	
	private static void atomicInit(VisitorBoogie visitor, Call_cmdContext ctx) {
		IExpr add = (IExpr)ctx.call_params().exprs().expr().get(0).accept(visitor);
		ExprInterface value = (ExprInterface)ctx.call_params().exprs().expr().get(1).accept(visitor);
		Store child = new Store(add, value, null);
		child.setCLine(visitor.currentLine);
		visitor.programBuilder.addChild(visitor.threadCount, child);
	}

	private static void atomicStore(VisitorBoogie visitor, Call_cmdContext ctx) {
		IExpr add = (IExpr)ctx.call_params().exprs().expr().get(0).accept(visitor);
		ExprInterface value = (ExprInterface)ctx.call_params().exprs().expr().get(1).accept(visitor);
		String mo = null;
		if(ctx.call_params().exprs().expr().size() > 2) {
			mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(2).accept(visitor)).getValue());			
		}
		AtomicStore child = new AtomicStore(add, value, mo);
		child.setCLine(visitor.currentLine);
		visitor.programBuilder.addChild(visitor.threadCount, child);
	}

	private static void atomicLoad(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
		IExpr add = (IExpr)ctx.call_params().exprs().expr().get(0).accept(visitor);
		String mo = null;
		if(ctx.call_params().exprs().expr().size() > 1) {
			mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(1).accept(visitor)).getValue());			
		}
		AtomicLoad child = new AtomicLoad(reg, add, mo);
		child.setCLine(visitor.currentLine);
		visitor.programBuilder.addChild(visitor.threadCount, child);
	}

	private static void atomicFetchOp(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
		IExpr add = (IExpr)ctx.call_params().exprs().expr().get(0).accept(visitor);
		ExprInterface value = (IExpr)ctx.call_params().exprs().expr().get(1).accept(visitor);
		String mo = null;
		IOpBin op;
		if(ctx.getText().contains("_add")) {
			op = IOpBin.PLUS;
		} else if(ctx.getText().contains("_sub")) {
			op = IOpBin.MINUS;
		} else if(ctx.getText().contains("_and")) {
			op = IOpBin.AND;
		} else if(ctx.getText().contains("_or")) {
			op = IOpBin.OR;
		} else if(ctx.getText().contains("_xor")) {
			op = IOpBin.XOR;
		} else {
			throw new RuntimeException("AtomicFetchOp operation cannot be handled");
		}
		if(ctx.call_params().exprs().expr().size() > 2) {
			mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(2).accept(visitor)).getValue());			
		}
		AtomicFetchOp child = new AtomicFetchOp(reg, add, value, op, mo);
		child.setCLine(visitor.currentLine);
		visitor.programBuilder.addChild(visitor.threadCount, child);
	}

	private static void atomicXchg(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
		IExpr add = (IExpr)ctx.call_params().exprs().expr().get(0).accept(visitor);
		ExprInterface value = (ExprInterface)ctx.call_params().exprs().expr().get(1).accept(visitor);
		String mo = null;
		if(ctx.call_params().exprs().expr().size() > 2) {
			mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(2).accept(visitor)).getValue());			
		}
		AtomicXchg child = new AtomicXchg(reg, add, value, mo);
		child.setCLine(visitor.currentLine);
		visitor.programBuilder.addChild(visitor.threadCount, child);
	}

	private static void atomicThreadFence(VisitorBoogie visitor, Call_cmdContext ctx) {
		String mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(0).accept(visitor)).getValue());
		AtomicThreadFence child = new AtomicThreadFence(mo);
		child.setCLine(visitor.currentLine);
		visitor.programBuilder.addChild(visitor.threadCount, child);
	}
}
