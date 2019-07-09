package com.dat3m.dartagnan.parsers.program.visitors;

import java.util.stream.IntStream;

import org.antlr.v4.runtime.tree.ParseTree;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.parsers.BoogieBaseVisitor;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Attr_typed_idents_whereContext;
import com.dat3m.dartagnan.parsers.BoogieVisitor;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.If;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.Skip;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.While;
import com.dat3m.dartagnan.program.memory.Location;

public class VisitorBoogie extends BoogieBaseVisitor<Object> implements BoogieVisitor<Object> {

	private ProgramBuilder programBuilder;
    private int currentThread = 0;
    private int scope = 0;

	public VisitorBoogie(ProgramBuilder pb) {
		this.programBuilder = pb;
	}
	
    @Override
    public Object visitMain(BoogieParser.MainContext ctx) {
    	IntStream.range(0, ctx.var_decl().size()).forEach(n -> {
        	visitVar_decl(ctx.var_decl(n));});
    	IntStream.range(0, ctx.proc_decl().size()).forEach(n -> {
        	visitProc_decl(ctx.proc_decl(n));});
        return programBuilder.build();
    }

    @Override
    public Object visitVar_decl(BoogieParser.Var_declContext ctx) {
    	 for(Attr_typed_idents_whereContext atiwC : ctx.typed_idents_wheres().attr_typed_idents_where()) {
    		 for(ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
    			 programBuilder.getOrCreateLocation(ident.getText());
    		 }
    	 }
    	 return null;
    }
    
	public Object visitLocal_vars(BoogieParser.Local_varsContext ctx, int scope) {
		for(Attr_typed_idents_whereContext atiwC : ctx.typed_idents_wheres().attr_typed_idents_where()) {
			for(ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
				programBuilder.getOrCreateRegister(scope, ident.getText());
			}			
		}
   	 	return null;
   	 }

    @Override
    public Object visitProc_decl(BoogieParser.Proc_declContext ctx) {
    	currentThread ++;
    	scope = currentThread;
        programBuilder.initThread(currentThread);
        
        IntStream.range(0, ctx.impl_body().local_vars().size()).forEach(n -> {
        	visitLocal_vars(ctx.impl_body().local_vars(n), scope);
        });
        
        for(ParseTree stmt : ctx.impl_body().stmt_list().children) {
        	stmt.accept(this);
        }

        scope = -1;
        return null;
    }
    
	@Override
	public Object visitWhile_cmd(BoogieParser.While_cmdContext ctx) {
        ExprInterface expr = (ExprInterface) ctx.guard().expr().accept(this);
        Skip exitEvent = new Skip();
        While whileEvent = new While(expr, exitEvent);
        programBuilder.addChild(currentThread, whileEvent);

        ctx.stmt_list().accept(this);
        return programBuilder.addChild(currentThread, exitEvent);
	}

	@Override
	public Object visitIf_cmd(BoogieParser.If_cmdContext ctx) {
        ExprInterface expr = (ExprInterface) ctx.guard().expr().accept(this);
        Skip exitMainBranch = new Skip();
        Skip exitElseBranch = new Skip();
        If ifEvent = new If(expr, exitMainBranch, exitElseBranch);
        programBuilder.addChild(currentThread, ifEvent);
        
        ctx.stmt_list(0).accept(this);
        programBuilder.addChild(currentThread, exitMainBranch);

        if(ctx.stmt_list().size() > 1){
            ctx.stmt_list(1).accept(this);
        }
        programBuilder.addChild(currentThread, exitElseBranch);
        return null;

	}

	@Override
	public Object visitAssign_cmd(BoogieParser.Assign_cmdContext ctx) {
		//TODO handle the case when ident or expr is more than one
		if(scope > -1){
            Register register = programBuilder.getRegister(scope, ctx.Ident(0).getText());
            if(register != null){
                ExprInterface value = (ExprInterface)ctx.exprs(0).accept(this);
                programBuilder.addChild(currentThread, new Local(register, value));
            }
            Location location = programBuilder.getLocation(ctx.Ident(0).getText());
            if(location != null){
                ExprInterface value = (ExprInterface)ctx.exprs(0).accept(this);
                programBuilder.addChild(currentThread, new Store(location.getAddress(), value, "NA"));
            }
        }
		return null;
	}

	@Override
	public Object visitRel_expr(BoogieParser.Rel_exprContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.bv_term(0).accept(this);
		if(ctx.bv_term().size() > 1) {
			ExprInterface v2 = (ExprInterface)ctx.bv_term(1).accept(this);
			return new Atom(v1, ctx.rel_op(0).op, v2);
		}
		return v1;
	}
	
	@Override
	public Object visitTerm(BoogieParser.TermContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.factor(0).accept(this);
		ExprInterface v2 = null;
		for(int i : IntStream.range(0, ctx.factor().size()-1).toArray()) {
			v2 = (ExprInterface)ctx.factor(i+1).accept(this);
			v1 = new IExprBin(v1, ctx.add_op(i).op, v2);
		}
		return v1;
	}

	@Override
	public Object visitFactor(BoogieParser.FactorContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.power(0).accept(this);
		ExprInterface v2 = null;
		for(int i : IntStream.range(0, ctx.power().size()-1).toArray()) {
			v2 = (ExprInterface)ctx.power(i+1).accept(this);
			v1 = new IExprBin(v1, ctx.mul_op(i).op, v2);
		}
		return v1;
	}

	@Override
	public Object visitAtom_expr(BoogieParser.Atom_exprContext ctx) {
        if(scope > -1){
            Register register = programBuilder.getRegister(scope, ctx.getText());
            if(register != null){
                return register;
            }
            Location location = programBuilder.getLocation(ctx.getText());
            if(location != null){
                register = programBuilder.getOrCreateRegister(scope, null);
                programBuilder.addChild(currentThread, new Load(register, location.getAddress(), "NA"));
                return register;
            }
            return programBuilder.getOrCreateRegister(scope, ctx.getText());
        }
//        Location location = programBuilder.getOrCreateLocation(ctx.getText());
//        Register register = programBuilder.getOrCreateRegister(scope, null);
//        programBuilder.addChild(currentThread, new Load(register, location.getAddress(), "NA"));
//        return register;
        return null;
	}
}