package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;

public class StdProcedures {
	
	public static List<String> STDPROCEDURES = Arrays.asList(
			"devirtbounce",
			"external_alloc",
			"$alloc",
			"__assert_rtn",
			"assert_.i32",
			"__assert_fail",
			"$malloc",
			"calloc",
			"malloc",
			"fopen",
			"free",
			"memcpy",
			"$memcpy",
			"memset",
			"$memset",
			"nvram_read_byte", 
			"strcpy",
			"strcmp",
			"strncpy", 
			"llvm.stackrestore",
			"llvm.stacksave",
			"llvm.lifetime.start",
			"llvm.lifetime.end");
	
	public static void handleStdFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		if(name.equals("$alloc") || name.equals("$malloc") || name.equals("calloc") || name.equals("malloc") || name.equals("external_alloc") ) {
			alloc(visitor, ctx);
			return;
		}
		if(name.equals("__assert_rtn") || name.equals("assert_.i32") || name.equals("__assert_fail")) {
			__assert(visitor, ctx);
			return;
		}
		if(name.startsWith("fopen")) {
			// TODO: Implement this
			return;			
		}
		if(name.startsWith("free")) {
			// TODO: Implement this
			return;			
		}
		if(name.startsWith("memcpy") | name.startsWith("$memcpy")) {
			// TODO: Implement this
			return;			
		}
		if(name.startsWith("memset") || name.startsWith("$memset")) {
			throw new ParsingException(name + " cannot be handled");
		}
		if(name.startsWith("nvram_read_byte")) {
			throw new ParsingException(name + " cannot be handled");
		}
		if(name.startsWith("strcpy")) {
			throw new ParsingException(name + " cannot be handled");
		}
		if(name.startsWith("strcmp")) {
			// TODO: Implement this
			return;			
		}
		if(name.startsWith("strncpy")) {
			throw new ParsingException(name + " cannot be handled");
		}
		if(name.startsWith("llvm.stackrestore")) {
			// TODO: Implement this
			return;			
		}
		if(name.startsWith("llvm.stacksave")) {
			// TODO: Implement this
			return;			
		}
		if(name.startsWith("llvm.lifetime.start")) {
			// TODO: Implement this
			return;			
		}
		if(name.startsWith("llvm.lifetime.end")) {
			// TODO: Implement this
			return;			
		}
        throw new UnsupportedOperationException(name + " procedure is not part of STDPROCEDURES");
	}	
	
	private static void alloc(VisitorBoogie visitor, Call_cmdContext ctx) {
		int size;
		try {
			size = ((IExpr)ctx.call_params().exprs().expr(0).accept(visitor)).reduce().getValueAsInt();
		} catch (Exception e) {
			String tmp = ctx.call_params().getText();
			tmp = tmp.contains(",") ? tmp.substring(0, tmp.indexOf(',')) : tmp.substring(0, tmp.indexOf(')')); 
			tmp = tmp.substring(tmp.lastIndexOf('(')+1);
			size = Integer.parseInt(tmp);			
		}
		//Uniquely identify the allocated storage in the entire program
		String ptr = visitor.currentScope.getID()+":"+ctx.call_params().Ident(0).getText();
		Register start = visitor.programBuilder.getRegister(visitor.threadCount,ptr);
		MemoryObject object = visitor.programBuilder.newObject(ptr,size);
		visitor.programBuilder.addChild(visitor.threadCount,EventFactory.newLocal(start,object));
		visitor.allocationRegs.add(start);
	}
	
	private static void __assert(VisitorBoogie visitor, Call_cmdContext ctx) {
    	Register ass = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, "assert_" + visitor.assertionIndex, -1);
    	visitor.assertionIndex++;
    	ExprInterface expr = (ExprInterface)ctx.call_params().exprs().accept(visitor);
    	if(expr instanceof IConst && ((IConst)expr).getValue().compareTo(BigInteger.ONE) == 0) {
    		return;
    	}
    	Local event = EventFactory.newLocal(ass, expr);
		event.addFilters(Tag.ASSERTION);
		visitor.programBuilder.addChild(visitor.threadCount, event);
	}

}
