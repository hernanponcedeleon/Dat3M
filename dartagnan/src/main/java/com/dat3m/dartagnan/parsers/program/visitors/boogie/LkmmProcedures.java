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
import com.dat3m.dartagnan.program.event.core.Event;

import static com.dat3m.dartagnan.expression.op.IOpBin.*;

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
			"__LKMM_WRITE_ONCE",
			"__LKMM_READ_ONCE",
			"__LKMM_FENCE");

	public static void handleLkmmFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		if(name.startsWith("__LKMM_load")) {
			Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			String mo = Linux.intToMo(((IConst) params.get(1).accept(visitor)).getValueAsInt());
	        Event event = EventFactory.newLoad(reg, address, mo);
	        visitor.programBuilder.addChild(visitor.threadCount, event);
	        return;
		}
		if(name.startsWith("__LKMM_store")) {
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			IExpr value = (IExpr) params.get(1).accept(visitor);
			String mo = Linux.intToMo(((IConst) params.get(2).accept(visitor)).getValueAsInt());
	        if(mo.equals(Tag.Linux.MO_MB)){
	            Event event = EventFactory.newStore(address, value, Tag.Linux.MO_RELAXED);
	            visitor.programBuilder.addChild(visitor.threadCount, event);
	            visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Linux.newMemoryBarrier());
	            return;
	        }
	        Event event = EventFactory.newStore(address, value, mo);
	        visitor.programBuilder.addChild(visitor.threadCount, event);
	        return;
		}
		if(name.startsWith("__LKMM_xchg")) {
			Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			IExpr value = (IExpr) params.get(1).accept(visitor);
			String mo = Linux.intToMo(((IConst) params.get(2).accept(visitor)).getValueAsInt());
	        Event event = EventFactory.Linux.newRMWExchange(address, reg, value, mo);
	        visitor.programBuilder.addChild(visitor.threadCount, event);
			return;
		}
		if(name.startsWith("__LKMM_cmpxchg")) {
			Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			IExpr expectedVal = (IExpr) params.get(1).accept(visitor);
			IExpr desiredVal = (IExpr) params.get(2).accept(visitor);
			String mo = Linux.intToMo(((IConst) params.get(3).accept(visitor)).getValueAsInt());
	        Event event = EventFactory.Linux.newRMWCompareExchange(address, reg, expectedVal, desiredVal, mo);
	        visitor.programBuilder.addChild(visitor.threadCount, event);
			return;
		}
		if(name.startsWith("__LKMM_atomic_fetch_op")) {
			Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			IExpr value = (IExpr) params.get(1).accept(visitor);
			String mo = Linux.intToMo(((IConst) params.get(2).accept(visitor)).getValueAsInt());
			IOpBin op;
			String opText = params.get(3).getText();
			switch(Integer.parseInt(opText)) {
				case 0:
					op = PLUS;
					break;
				case 1:
					op = MINUS;
					break;
				case 2:
					op = AND;
					break;
				case 3:
					op = OR;
					break;
				default:
					throw new ParsingException("Unrecognized operation " + opText);
			}
	        Event event = EventFactory.Linux.newRMWFetchOp(address, reg, value, op, mo);
	        visitor.programBuilder.addChild(visitor.threadCount, event);
			return;
		}
		if(name.startsWith("__LKMM_atomic_op")) {
			Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			IExpr value = (IExpr) params.get(1).accept(visitor);
			IOpBin op;
			String opText = params.get(3).getText();
			switch(Integer.parseInt(opText)) {
				case 0:
					op = PLUS;
					break;
				case 1:
					op = MINUS;
					break;
				case 2:
					op = AND;
					break;
				case 3:
					op = OR;
					break;
				default:
					throw new ParsingException("Unrecognized operation " + opText);
			}
	        Event event = EventFactory.Linux.newRMWOp(address, reg, value, op);
	        visitor.programBuilder.addChild(visitor.threadCount, event);
			return;
		}
		if(name.startsWith("__LKMM_WRITE_ONCE")) {
			List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
			IExpr address = (IExpr) params.get(0).accept(visitor);
			ExprInterface value = (ExprInterface)params.get(1).accept(visitor);
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newStore(address, value, "Once"));
			return;			
		}
		if(name.startsWith("__LKMM_READ_ONCE")) {
			Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
			IExpr address = (IExpr)ctx.call_params().exprs().expr(0).accept(visitor);
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newLoad(reg, address, "Once"));
			return;			
		}
		if(name.startsWith("__LKMM_FENCE")) {
			String text = ctx.call_params().exprs().expr(0).getText();
			String fence;
			switch(Integer.parseInt(text)) {
				case 6:
					fence = "Mb";
					break;
				case 7:
					fence = "Wmb";
					break;
				case 8:
					fence = "Rmb";
					break;
				default:
					throw new ParsingException("Unrecognized fence " + text);
			}
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newFence(fence));
			return;			
		}
		throw new UnsupportedOperationException(name + " procedure is not part of LKMMPROCEDURES");
	}
}
