package com.dat3m.dartagnan.parsers.program.visitors;

import java.util.stream.IntStream;

import org.antlr.v4.runtime.tree.ParseTree;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.parsers.BoogieBaseVisitor;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Attr_typed_idents_whereContext;
import com.dat3m.dartagnan.parsers.BoogieVisitor;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.memory.Address;

public class VisitorBoogie extends BoogieBaseVisitor<Object> implements BoogieVisitor<Object> {

	private ProgramBuilder programBuilder;
    private int currentThread = 0;

	public VisitorBoogie(ProgramBuilder pb) {
		this.programBuilder = pb;
	}
	
    @Override
    public Object visitMain(BoogieParser.MainContext ctx) {
    	return null;
//    	IntStream.range(0, ctx.var_decl().size()).forEach(n -> {
//        	visitVar_decl(ctx.var_decl(n));});
//    	IntStream.range(0, ctx.proc_decl().size()).forEach(n -> {
//        	visitProc_decl(ctx.proc_decl(n));});
//        return programBuilder.build();
    }

    @Override public Object visitVar_decl(BoogieParser.Var_declContext ctx) { 
    	 for(Attr_typed_idents_whereContext atiwC : ctx.typed_idents_wheres().attr_typed_idents_where()) {
    		 for(ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
    			 programBuilder.getOrCreateLocation(ident.getText());
    		 }
    	 }
    	 return null;
    }
    
    @Override
    public Object visitProc_decl(BoogieParser.Proc_declContext ctx) {
    	currentThread ++;
        programBuilder.initThread(currentThread);
        return ctx.impl_body().stmt_list();
    }

	@Override 
	public Object visitAssign_cmd(BoogieParser.Assign_cmdContext ctx) { 
		return new Local(new Register("r1", 0), new IConst(1));
	}
}
