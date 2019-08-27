package com.dat3m.dartagnan.parsers.program.visitors;

import static com.dat3m.dartagnan.expression.op.BOpUn.NOT;
import static com.dat3m.dartagnan.expression.op.COpBin.EQ;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.antlr.v4.runtime.tree.ParseTree;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.expression.BExprBin;
import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.IExprUn;
import com.dat3m.dartagnan.expression.IfExpr;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.parsers.BoogieBaseVisitor;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Attr_typed_idents_whereContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Axiom_declContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Const_declContext;
import com.dat3m.dartagnan.parsers.BoogieParser.ExprsContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Func_declContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Impl_bodyContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Local_varsContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Proc_declContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Var_declContext;
import com.dat3m.dartagnan.parsers.BoogieVisitor;
import com.dat3m.dartagnan.parsers.boogie.Function;
import com.dat3m.dartagnan.parsers.boogie.FunctionCall;
import com.dat3m.dartagnan.parsers.boogie.Scope;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Assertion;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.If;
import com.dat3m.dartagnan.program.event.Jump;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.Skip;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.While;
import com.dat3m.dartagnan.program.memory.Location;

public class VisitorBoogie extends BoogieBaseVisitor<Object> implements BoogieVisitor<Object> {

	private ProgramBuilder programBuilder;
    private int threadCount = 0;
    
    private Label currentLabel = null;
    private Map<Label, Label> pairLabels = new HashMap<>();
    
    private Map<String, Function> functions = new HashMap<>();
	private FunctionCall currentCall = null;
	
	private boolean initMode = false;
	
	private Map<String, Proc_declContext> procedures = new HashMap<>();
	private List<Proc_declContext> threadsToCreate = new ArrayList<Proc_declContext>();
	
	private int nextScopeID = 0;
	private Scope currentScope = new Scope(nextScopeID, null);
	
	private Register currentReturn = null;
	private String currentReturnName = null;
	
	private List<String> constants = new ArrayList<>();
	private Map<String, ExprInterface> constantsMap = new HashMap<>();
	
	private int assertionIndex = 0;

	public VisitorBoogie(ProgramBuilder pb) {
		this.programBuilder = pb;
	}
	
    @Override
    public Object visitMain(BoogieParser.MainContext ctx) {
    	for(Func_declContext funDecContext : ctx.func_decl()) {
    		visitFunc_decl(funDecContext);
    	}
    	for(Const_declContext constDecContext : ctx.const_decl()) {
    		visitConst_decl(constDecContext);
    	}
    	for(Axiom_declContext axiomDecContext : ctx.axiom_decl()) {
    		visitAxiom_decl(axiomDecContext);
    	}
    	for(Var_declContext varDecContext : ctx.var_decl()) {
    		visitVar_decl(varDecContext);
    	}
    	for(Proc_declContext procDecContext : ctx.proc_decl()) {
    		preProc_decl(procDecContext);
    	}
    	if(!procedures.containsKey("main")) {
    		throw new ParsingException("Program shall have a main procedure");
    	}

    	threadsToCreate.add(procedures.get("main"));
    	while(!threadsToCreate.isEmpty()) {
    		Proc_declContext nextThread = threadsToCreate.remove(0);
    		visitProc_decl(nextThread, true);	
    	}
    	return programBuilder.build();
    }

	private void preProc_decl(Proc_declContext ctx) {
		String name = ctx.proc_sign().Ident().getText();;
    	if(procedures.containsKey(name)) {
    		throw new ParsingException("Procedure " + name + " is already defined");
    	}
    	procedures.put(name, ctx);
	}

	@Override
	public Object visitAxiom_decl(BoogieParser.Axiom_declContext ctx) {
		// TODO how to deal with b == b or b == a /\ a == b?
		ExprInterface exp = (ExprInterface)ctx.proposition().accept(this);
		if(exp instanceof Atom && ((Atom)exp).getLHS() instanceof Register && ((Atom)exp).getOp().equals(EQ)) {
			String name = ((Register)((Atom)exp).getLHS()).getName();
			ExprInterface def = ((Atom)exp).getRHS();
			constantsMap.put(name, def);
		}
		return null;
	}

	@Override
	public Object visitConst_decl(BoogieParser.Const_declContext ctx) {
		for(ParseTree ident : ctx.typed_idents().idents().Ident()) {
			constants.add(ident.getText());
		}
		return null;
	}

	@Override
	public Object visitFunc_decl(BoogieParser.Func_declContext ctx) {
		String name = ctx.Ident().getText();
		functions.put(name, new Function(name, ctx.var_or_type(), ctx.expr()));
		return null;
	}

    @Override
    public Object visitVar_decl(BoogieParser.Var_declContext ctx) {
    	 for(Attr_typed_idents_whereContext atiwC : ctx.typed_idents_wheres().attr_typed_idents_where()) {
 			if(atiwC.typed_idents_where().typed_idents().type().getText().contains("bv")) {
				throw new ParsingException("Bitvectors are not yet supported");		
			}
 			for(ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
 				programBuilder.getOrCreateLocation(ident.getText());
 			}
    	 }
    	 return null;
    }
    
	public Object visitLocal_vars(BoogieParser.Local_varsContext ctx, int scope) {
		for(Attr_typed_idents_whereContext atiwC : ctx.typed_idents_wheres().attr_typed_idents_where()) {
			if(atiwC.typed_idents_where().typed_idents().type().getText().contains("bv")) {
				throw new ParsingException("Bitvectors are not yet supported");		
			}
			for(ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
				String name = ident.getText();
				if(constants.contains(name)) {
	                throw new ParsingException("Variable " + name + " is already defined as a constant");
				}
				if(programBuilder.getLocation(name) != null) {
	                throw new ParsingException("Variable " + name + " is already defined globally");
				}
				programBuilder.getOrCreateRegister(scope, currentScope.getID() + ":" + name);
			}			
		}
   	 	return null;
   	 }

    public void visitProc_decl(BoogieParser.Proc_declContext ctx, boolean create) {
    	if(ctx.proc_sign().proc_sign_out() != null) {
    		for(Attr_typed_idents_whereContext atiwC : ctx.proc_sign().proc_sign_out().attr_typed_idents_wheres().attr_typed_idents_where()) {
    			for(ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
    				currentReturnName = ident.getText();
    			}
    		}    		
    	}
		
    	if(create) {
        	threadCount ++;
            programBuilder.initThread(threadCount);
    	}

    	currentScope = new Scope(nextScopeID, currentScope);
    	nextScopeID++;
    	
    	Impl_bodyContext body = ctx.impl_body();;
    	if(body == null) {
    		currentScope = currentScope.getParent();
    		return;
    	}
    	    	
        for(Local_varsContext localVarContext : body.local_vars()) {
        	visitLocal_vars(localVarContext, threadCount);
        }

        visitChildren(body.stmt_list());

       	String labelName = "END_OF_" + currentScope.getID();
		Label label = programBuilder.getOrCreateLabel(labelName);
   		programBuilder.addChild(threadCount, label);
        
        currentScope = currentScope.getParent();
    }
    
    @Override 
    public Object visitAssert_cmd(BoogieParser.Assert_cmdContext ctx) {
    	Register ass = programBuilder.getOrCreateRegister(threadCount, "assert_" + assertionIndex);
    	ExprInterface expr = (ExprInterface)ctx.proposition().expr().accept(this);
    	Assertion event = new Assertion(ass, expr);
		programBuilder.addChild(threadCount, event);
    	assertionIndex ++;
    	return null;
    }
    
	@Override
	public Object visitCall_cmd(BoogieParser.Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		if(name.equals("$initialize")) {
			initMode = true;;
		}
		if(name.equals("$alloc")) {
			return null;
		}
		if(name.equals("__VERIFIER_assume")) {
			__VERIFIER_assume(ctx.call_params().exprs());
			return null;
		}
		if(name.equals("__VERIFIER_nondet_int")) {
			__VERIFIER_nondet_int(ctx.call_params().Ident(0).getText());
			return null;
		}
		if(name.equals("pthread_create")) {
			pthread_create(ctx.call_params().exprs().expr().get(2).getText());
			return null;
		}
		if(name.equals("pthread_join") && ctx.call_params().Define() != null) {
			pthread_join(ctx.call_params().Ident(0).getText());
        	return null;
		}
		if(ctx.call_params().Define() != null) {
			Register register = programBuilder.getRegister(threadCount, currentScope.getID() + ":" + ctx.call_params().Ident(0).getText());
	        if(register != null){
	            currentReturn = register;
	        }
		}
		if(!procedures.containsKey(name)) {
			throw new ParsingException("Procedure " + name + " is not defined");
		}
		visitProc_decl(procedures.get(name), false);
		currentReturn = null;
		if(name.equals("$initialize")) {
			initMode = false;
		}
		return null;
	}

	private void pthread_create(String name) {
		if(threadCount != 1) {
			throw new ParsingException("Only main procedure can fork new procedures");
		}
		if(!procedures.containsKey(name)) {
			throw new ParsingException("Procedure " + name + " is not defined");
		}
		threadsToCreate.add(procedures.get(name));		
	}

	private void pthread_join(String registerName) {
		Register register = programBuilder.getRegister(threadCount, currentScope.getID() + ":" + registerName);
	    if(register != null){
	    	programBuilder.addChild(threadCount, new Local(register, new IConst(0)));
	    }		
	}

	private void __VERIFIER_nondet_int(String registerName) {
		Register register = programBuilder.getRegister(threadCount, currentScope.getID() + ":" + registerName);
		ExprInterface value = new IConst(new Random().nextInt(Integer.MAX_VALUE));
		if(register != null) {
			programBuilder.addChild(threadCount, new Local(register, value));	
		}
	}
	
	private void __VERIFIER_assume(ExprsContext exp) {
		String labelName = "END_OF_" + currentScope.getID();
       	Label label = programBuilder.getOrCreateLabel(labelName);
       	Register c = (Register)exp.accept(this);
		if(c != null) {
			programBuilder.addChild(threadCount, new CondJump(new BExprUn(NOT, c), label));	
		}
	}
	
	@Override
	public Object visitWhile_cmd(BoogieParser.While_cmdContext ctx) {
        ExprInterface expr = (ExprInterface)ctx.guard().expr().accept(this);
        Skip exitEvent = new Skip();
        While whileEvent = new While(expr, exitEvent);
        programBuilder.addChild(threadCount, whileEvent);

        visitChildren(ctx.stmt_list());
        return programBuilder.addChild(threadCount, exitEvent);
	}

	@Override
	public Object visitIf_cmd(BoogieParser.If_cmdContext ctx) {
        ExprInterface expr = (ExprInterface)ctx.guard().expr().accept(this);
        Skip exitMainBranch = new Skip();
        Skip exitElseBranch = new Skip();
        If ifEvent = new If(expr, exitMainBranch, exitElseBranch);
        programBuilder.addChild(threadCount, ifEvent);
        
        visitChildren(ctx.stmt_list(0));
        programBuilder.addChild(threadCount, exitMainBranch);

        // case when the else branch is a stmt list
        if(ctx.stmt_list().size() > 1){
            visitChildren(ctx.stmt_list(1));
        }

        // case when the else branch is another if        
        if(ctx.if_cmd() != null) {
            visitChildren(ctx.if_cmd());
        }
        
        programBuilder.addChild(threadCount, exitElseBranch);
        return null;

	}

	@Override
	public Object visitAssign_cmd(BoogieParser.Assign_cmdContext ctx) {
		//TODO handle complex lhs ... e.g foo(expr)
		
        ExprsContext exprs = ctx.def_body().exprs();
		// We get the first value and then iterate
        ExprInterface value = (ExprInterface)exprs.expr(0).accept(this);
        // Current hack to deal with pthread_join
        if(value == null) {
        	return null;
        }
		
        for(int i : IntStream.range(0, ctx.Ident().size()).toArray()) {
        	if(exprs.expr().size() != 1 && exprs.expr().size() != ctx.Ident().size()) {
                throw new ParsingException("There should be one expression per variable\nor only one expression for all in " + ctx.getText());
        	}
        	// No need to recompute value in the first iteration
			if(exprs.expr().size() != 1 && i != 0) {
				// if there is more than one expression, there should be exactly one per variable, thus we use 'i'
				value = (ExprInterface)exprs.expr(i).accept(this);
			}
			String name = ctx.Ident(i).getText();
			if(constants.contains(name)) {
				throw new ParsingException("Constants cannot be assigned: " + ctx.getText());
			}
			if(initMode) {
				programBuilder.initLocEqConst(name, value.reduce());
				return null;
			}
			Register register = programBuilder.getRegister(threadCount, currentScope.getID() + ":" + name);
	        if(register != null){
	            programBuilder.addChild(threadCount, new Local(register, value));
	            return null;
	        }
	        Location location = programBuilder.getLocation(name);
	        if(location != null){
	            programBuilder.addChild(threadCount, new Store(location.getAddress(), value, "NA"));
	            return null;
	        }
	        if(currentReturnName != null && currentReturnName.equals(name)) {
	        	if(currentReturn instanceof Register) {
	        		programBuilder.addChild(threadCount, new Local(currentReturn, value));
	        	}
	        	return null;
	        }
	        throw new ParsingException("Variable " + name + " is not defined");
		}
        return null;
	}

	@Override
	public Object visitReturn_cmd(BoogieParser.Return_cmdContext ctx) {
    	String labelName = "END_OF_" + currentScope.getID();
		Label label = programBuilder.getOrCreateLabel(labelName);
		programBuilder.addChild(threadCount, new Jump(label));
		return null;
	}

	@Override
	public Object visitAssume_cmd(BoogieParser.Assume_cmdContext ctx) {
		// We can get rid of all the "assume true" statements
		if(!ctx.proposition().expr().getText().equals("true")) {
			Label pairingLabel = null;
			if(!pairLabels.keySet().contains(currentLabel)) {
				// If the current label doesn't have a pairing label, we jump to the end of the program
				String labelName = "END_OF_" + currentScope.getID();
	        	pairingLabel = programBuilder.getOrCreateLabel(labelName);
			} else {
				pairingLabel = pairLabels.get(currentLabel);
			}
			BExpr c = (BExpr)ctx.proposition().expr().accept(this);
			// Some expression might not be parsed, e.g. "forall"
			if(c != null) {
				programBuilder.addChild(threadCount, new CondJump(new BExprUn(NOT, c), pairingLabel));	
			}
		}
        return null;
	}

	@Override
	public Object visitLabel(BoogieParser.LabelContext ctx) {
		// Since we "inline" procedures, label names might clash
		// thus we use currentScope.getID() + ":"
		String labelName = currentScope.getID() + ":" + ctx.children.get(0).getText();
		Label label = programBuilder.getOrCreateLabel(labelName);
        programBuilder.addChild(threadCount, label);
        currentLabel = label;
        return null;
	}

	@Override
	public Object visitGoto_cmd(BoogieParser.Goto_cmdContext ctx) {
    	String labelName = currentScope.getID() + ":" + ctx.idents().children.get(0).getText();
		Label l1 = programBuilder.getOrCreateLabel(labelName);
        programBuilder.addChild(threadCount, new Jump(l1));
        // If there is a loop, we return if the loop is not completely unrolled.
        // SMACK will take care of another escape if the loop is completely unrolled.
        if(l1.getOId() != -1) {
        	labelName = "END_OF_" + currentScope.getID();
    		Label label = programBuilder.getOrCreateLabel(labelName);
    		programBuilder.addChild(threadCount, new Jump(label));        	
        }
		if(ctx.idents().children.size() > 1) {
			for(int index = 2; index < ctx.idents().children.size(); index = index + 2) {
		    	labelName = currentScope.getID() + ":" + ctx.idents().children.get(index - 2).getText();
				l1 = programBuilder.getOrCreateLabel(labelName);
				// We know there are 2 labels and a comma in the middle
		    	labelName = currentScope.getID() + ":" + ctx.idents().children.get(index).getText();
				Label l2 = programBuilder.getOrCreateLabel(labelName);
				pairLabels.put(l1, l2);				
			}
		}
        return null;	
	}

	@Override
	public Object visitLogical_expr(BoogieParser.Logical_exprContext ctx) {
		if(ctx.getText().contains("forall") || ctx.getText().contains("exists") || ctx.getText().contains("lambda")) {
			return null;
		}
		ExprInterface v1 = (ExprInterface)ctx.rel_expr().accept(this);
		if(ctx.and_expr() != null) {
			ExprInterface vAnd = (ExprInterface)ctx.and_expr().accept(this);
			v1 = new BExprBin(v1, ctx.and_op().op, vAnd);
		}
		if(ctx.or_expr() != null) {
			ExprInterface vAnd = (ExprInterface)ctx.or_expr().accept(this);
			v1 = new BExprBin(v1, ctx.or_op().op, vAnd);
		}
		return v1;
	}

	@Override
	public Object visitMinus_expr(BoogieParser.Minus_exprContext ctx) {
		ExprInterface v = (ExprInterface)ctx.unary_expr().accept(this);
		return new IExprUn(IOpUn.MINUS, v);
	}

	@Override
	public Object visitNeg_expr(BoogieParser.Neg_exprContext ctx) {
		ExprInterface v = (ExprInterface)ctx.unary_expr().accept(this);
		return new BExprUn(BOpUn.NOT, v);
	}

	@Override
	public Object visitAnd_expr(BoogieParser.And_exprContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.rel_expr(0).accept(this);
		ExprInterface v2 = null;
		for(int i : IntStream.range(0, ctx.rel_expr().size()-1).toArray()) {
			v2 = (ExprInterface)ctx.rel_expr(i+1).accept(this);
			v1 = new BExprBin(v1, ctx.and_op(i).op, v2);
		}
		return v1;
	}

	@Override
	public Object visitOr_expr(BoogieParser.Or_exprContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.rel_expr(0).accept(this);
		ExprInterface v2 = null;
		for(int i : IntStream.range(0, ctx.rel_expr().size()-1).toArray()) {
			v2 = (ExprInterface)ctx.rel_expr(i+1).accept(this);
			v1 = new BExprBin(v1, ctx.or_op(i).op, v2);
		}
		return v1;
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
		String name = ctx.getText();
		if(constantsMap.containsKey(name)) {
			return constantsMap.get(name);
		}
		if(constants.contains(name)) {
			// Dummy register needed to parse axioms
			return new Register(name, -1);
		}
		if(currentCall != null && currentCall.getFunction().getBody() != null) {
			return currentCall.replaceVarsByExprs(ctx);
		}
        Register register = programBuilder.getRegister(threadCount, currentScope.getID() + ":" + name);
        if(register != null){
            return register;
        }
        Location location = programBuilder.getLocation(name);
        if(location != null){
            register = programBuilder.getOrCreateRegister(threadCount, null);
            programBuilder.addChild(threadCount, new Load(register, location.getAddress(), "NA"));
            return register;
        }
        throw new ParsingException("Variable " + name + " is not defined");
	}

	@Override
	public Object visitFun_expr(BoogieParser.Fun_exprContext ctx) {
		Function function = functions.get(ctx.Ident().getText());
		if(function == null) {
			throw new ParsingException("Function " + ctx.Ident().getText() + " is not defined");
		}
		// push currentCall to the call stack
		List<Object> callParams = ctx.expr().stream().map(e -> e.accept(this)).collect(Collectors.toList());
		currentCall = new FunctionCall(function, callParams, currentCall);
		// Some functions do not have a body
		if(function.getBody() == null) {
			currentCall = currentCall.getParent();
			return null;
		}
		Object ret = function.getBody().accept(this);
		// pop currentCall from the call stack
		currentCall = currentCall.getParent();
		return ret;
	}

	@Override
	public Object visitIf_then_else_expr(BoogieParser.If_then_else_exprContext ctx) {
		BExpr guard = (BExpr)ctx.expr(0).accept(this);
		ExprInterface tbranch = (ExprInterface)ctx.expr(1).accept(this);
		ExprInterface fbranch = (ExprInterface)ctx.expr(2).accept(this);
		return new IfExpr(guard, tbranch, fbranch);
	}

	@Override
	public Object visitParen_expr(BoogieParser.Paren_exprContext ctx) {
		return ctx.expr().accept(this);
	}

	@Override
	public Object visitInt_expr(BoogieParser.Int_exprContext ctx) {
		try {
			return new IConst(Integer.parseInt(ctx.getText()));
		} catch (Exception e) {
			return new IConst(Integer.MAX_VALUE);
		}
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