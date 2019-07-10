package com.dat3m.dartagnan.parsers.program.visitors;

import java.util.stream.IntStream;

import org.antlr.v4.runtime.tree.ParseTree;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.parsers.BoogieBaseVisitor;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Attr_typed_idents_whereContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Impl_declContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Local_varsContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Proc_declContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Var_declContext;
import com.dat3m.dartagnan.parsers.BoogieVisitor;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
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

	public VisitorBoogie(ProgramBuilder pb) {
		this.programBuilder = pb;
	}
	
    @Override
    public Object visitMain(BoogieParser.MainContext ctx) {
    	for(Var_declContext varDelContext : ctx.var_decl()) {
    		visitVar_decl(varDelContext);
    	}
    	for(Proc_declContext procDecContext : ctx.proc_decl()) {
    		visitProc_decl(procDecContext);
    	}
    	for(Impl_declContext implDecContext : ctx.impl_decl()) {
    		visitImpl_decl(implDecContext);
    	}
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
				if(programBuilder.getLocation(ident.getText()) != null) {
	                throw new ParsingException("Variable " + ident.getText() + " is already defined globally");
				}
				programBuilder.getOrCreateRegister(scope, ident.getText());
			}			
		}
   	 	return null;
   	 }

    @Override
    public Object visitProc_decl(BoogieParser.Proc_declContext ctx) {
    	if(ctx.impl_body() == null) {
    		return null;
    	}
    	
    	currentThread ++;
        programBuilder.initThread(currentThread);
        
        for(Local_varsContext localVarContext : ctx.impl_body().local_vars()) {
        	visitLocal_vars(localVarContext, currentThread);
        }
        
        for(ParseTree stmt : ctx.impl_body().stmt_list().children) {
        	stmt.accept(this);
        }

        return null;
    }
    
    @Override public Object visitImpl_decl(BoogieParser.Impl_declContext ctx) { 
    	if(ctx.impl_body() == null) {
    		return null;
    	}
    	
    	currentThread ++;
        programBuilder.initThread(currentThread);
        
        for(Local_varsContext localVarContext : ctx.impl_body().local_vars()) {
        	visitLocal_vars(localVarContext, currentThread);
        }
        
        for(ParseTree stmt : ctx.impl_body().stmt_list().children) {
        	stmt.accept(this);
        }

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

        // case when the else branch is a stmt list
        if(ctx.stmt_list().size() > 1){
            ctx.stmt_list(1).accept(this);
        }

        // case when the else branch is another if        
        if(ctx.if_cmd() != null) {
        	ctx.if_cmd().accept(this);
        }
        
        programBuilder.addChild(currentThread, exitElseBranch);
        return null;

	}

	@Override
	public Object visitAssign_cmd(BoogieParser.Assign_cmdContext ctx) {
		//TODO handle complex lhs ... e.g lala(expr)

		// To be sure we get the exprs after the define
		int index = ctx.exprs().size() == 1? 0 : 1;
        ExprInterface value = (ExprInterface)ctx.exprs(index).expr(0).accept(this);
		
        for(int i : IntStream.range(0, ctx.Ident().size()).toArray()) {
        	if(ctx.exprs(index).expr().size() != 1 && ctx.exprs(index).expr().size() != ctx.Ident().size()) {
                throw new ParsingException("There should be one expression per variable\nor only one expression for all in " + ctx.getText());
        	}
        	// No need to recompute value in the first iteration
			if(ctx.exprs(index).expr().size() != 1 && i != 0) {
				// if there is more than one expression, there should be exactly one per variable, thus we use 'i'
				value = (ExprInterface)ctx.exprs(index).expr(i).accept(this);
			}
			Register register = programBuilder.getRegister(currentThread, ctx.Ident(i).getText());
	        if(register != null){
	            programBuilder.addChild(currentThread, new Local(register, value));
	        }
	        Location location = programBuilder.getLocation(ctx.Ident(i).getText());
	        if(location != null){
	            programBuilder.addChild(currentThread, new Store(location.getAddress(), value, "NA"));
	        }
		}
        
		return null;
	}

	@Override
	public Object visitRel_expr(BoogieParser.Rel_exprContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.bv_term(0).accept(this);
		ExprInterface v2 = null;
		for(int i : IntStream.range(0, ctx.bv_term().size()-1).toArray()) {
			v2 = (ExprInterface)ctx.bv_term(i+1).accept(this);
			v1 = new Atom(v1, ctx.rel_op(i).op, v2);
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
	public Object visitVar_expr(BoogieParser.Var_exprContext ctx) {
        Register register = programBuilder.getRegister(currentThread, ctx.getText());
        if(register != null){
            return register;
        }
        Location location = programBuilder.getLocation(ctx.getText());
        if(location != null){
            register = programBuilder.getOrCreateRegister(currentThread, null);
            programBuilder.addChild(currentThread, new Load(register, location.getAddress(), "NA"));
            return register;
        }
        return null;
	}

	@Override
	public Object visitParen_expr(BoogieParser.Paren_exprContext ctx) {
		return ctx.expr().accept(this);
	}

	@Override
	public Object visitInt_expr(BoogieParser.Int_exprContext ctx) {
		return new IConst(Integer.parseInt(ctx.getText()));
	}
	
	@Override
	public Object visitBool_lit(BoogieParser.Bool_litContext ctx) {
		return new BConst(Boolean.parseBoolean(ctx.getText()));
	}

	@Override
	public Object visitDec(BoogieParser.DecContext ctx) {
        throw new ParsingException("Floats are not yet supported");
	}


}