package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.Linux;
import static com.dat3m.dartagnan.program.event.Tag.Linux.*;

import java.util.Arrays;
import java.util.List;

public class LkmmProcedures {

	public static List<String> LKMMPROCEDURES = Arrays.asList(
			"__LKMM_load",
			"__LKMM_store",
			"__LKMM_xchg",
			"__LKMM_cmpxchg",
			"__LKMM_atomic_fetch_op",
			"__LKMM_atomic_op",
			"__LKMM_atomic_op_return",
			"__LKMM_WRITE_ONCE",
			"__LKMM_READ_ONCE",
			"__LKMM_FENCE",
			"__LKMM_spin_lock",
			"__LKMM_spin_unlock");

	public static void handleLkmmFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		if(name.startsWith("__LKMM_load")) {
			Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			String mo = Linux.intToMo(((IConst) params.get(1).accept(visitor)).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newLoad(reg, address, mo))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
	        return;
		}
		if(name.startsWith("__LKMM_store")) {
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			IExpr value = (IExpr) params.get(1).accept(visitor);
			String mo = Linux.intToMo(((IConst) params.get(2).accept(visitor)).getValueAsInt());
	        if(mo.equals(Tag.Linux.MO_MB)){
				visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newStore(address, value, Tag.Linux.MO_RELAXED))
	            		.setCLine(visitor.currentLine)
	            		.setSourceCodeFile(visitor.sourceCodeFile);
	            visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newMemoryBarrier())
        				.setCLine(visitor.currentLine)
        				.setSourceCodeFile(visitor.sourceCodeFile);
	            return;
	        }
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newStore(address, value, mo))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
	        return;
		}
		if(name.startsWith("__LKMM_xchg")) {
			Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			IExpr value = (IExpr) params.get(1).accept(visitor);
			String mo = Linux.intToMo(((IConst) params.get(2).accept(visitor)).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWExchange(address, reg, value, mo))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		}
		if(name.startsWith("__LKMM_cmpxchg")) {
			Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			IExpr expectedVal = (IExpr) params.get(1).accept(visitor);
			IExpr desiredVal = (IExpr) params.get(2).accept(visitor);
			String mo = Linux.intToMo(((IConst) params.get(3).accept(visitor)).getValueAsInt());
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWCompareExchange(address, reg, expectedVal, desiredVal, mo))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		}
		if(name.startsWith("__LKMM_atomic_fetch_op")) {
			Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			IExpr value = (IExpr) params.get(1).accept(visitor);
			String mo = Linux.intToMo(((IConst) params.get(2).accept(visitor)).getValueAsInt());
			IOpBin op = IOpBin.intToOp(((IConst)params.get(3).accept(visitor)).getValueAsInt());
	        visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWFetchOp(address, reg, value, op, mo))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		}
		if(name.startsWith("__LKMM_atomic_op_return")) {
			Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			IExpr value = (IExpr) params.get(1).accept(visitor);
			String mo = Linux.intToMo(((IConst) params.get(2).accept(visitor)).getValueAsInt());
			IOpBin op = IOpBin.intToOp(((IConst)params.get(3).accept(visitor)).getValueAsInt());
	        visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWOpReturn(address, reg, value, op, mo))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		}
		if(name.startsWith("__LKMM_atomic_op")) {
			Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			IExpr value = (IExpr) params.get(1).accept(visitor);
			IOpBin op = IOpBin.intToOp(((IConst)params.get(3).accept(visitor)).getValueAsInt());
	        visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newRMWOp(address, reg, value, op))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		}
		if(name.startsWith("__LKMM_WRITE_ONCE")) {
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			ExprInterface value = (ExprInterface)params.get(1).accept(visitor);
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newStore(address, value, "Once"))
					.setCLine(visitor.currentLine)
					.setSourceCodeFile(visitor.sourceCodeFile);
			return;			
		}
		if(name.startsWith("__LKMM_READ_ONCE")) {
			Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
			IExpr address = (IExpr)ctx.call_params().exprs().expr(0).accept(visitor);
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newLoad(reg, address, "Once"))
					.setCLine(visitor.currentLine)
					.setSourceCodeFile(visitor.sourceCodeFile);
			return;			
		}
		if(name.startsWith("__LKMM_FENCE")) {
			int fenceAsInt = ((IConst)ctx.call_params().exprs().expr(0).accept(visitor)).getValueAsInt();
			String fence;
			switch(fenceAsInt) {
				case 6:
					fence = MO_MB;
					break;
				case 7:
					fence = MO_WMB;
					break;
				case 8:
					fence = MO_RMB;
					break;
				case 9:
					fence = RCU_LOCK;
					break;
				case 10:
					fence = RCU_UNLOCK;
					break;
				case 11:
					fence = RCU_SYNC;
					break;
				default:
					throw new ParsingException("Unrecognized fence " + fenceAsInt);
			}
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newFence(fence))
					.setCLine(visitor.currentLine)
					.setSourceCodeFile(visitor.sourceCodeFile);
			return;			
		}
		if(name.startsWith("__LKMM_spin_lock")) {
			IExpr lock = (IExpr)ctx.call_params().exprs().expr(0).accept(visitor);
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newLock(lock))
					.setCLine(visitor.currentLine)
					.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		}
		if(name.startsWith("__LKMM_spin_unlock")) {
			IExpr lock = (IExpr)ctx.call_params().exprs().expr(0).accept(visitor);
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newUnlock(lock))
					.setCLine(visitor.currentLine)
					.setSourceCodeFile(visitor.sourceCodeFile);
			return;
		}
		throw new UnsupportedOperationException(name + " procedure is not part of LKMMPROCEDURES");
	}
}
