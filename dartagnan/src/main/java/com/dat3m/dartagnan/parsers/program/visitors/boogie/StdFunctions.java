package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import java.util.Arrays;
import java.util.List;

import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;

public class StdFunctions {

	public static List<String> STDFUNCTIONS = Arrays.asList(
			"free");
	
	public static void handleStdFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		if(name.contains("free")) {
			// TODO: implement this?
			return;			
		}

        throw new UnsupportedOperationException(name + " funcition is not part of STDFUNCTIONS");
	}	
}
