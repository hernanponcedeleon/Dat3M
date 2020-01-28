package com.dat3m.dartagnan.parsers.program.visitors;

import static com.dat3m.dartagnan.expression.op.BOpUn.NOT;
import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.expression.op.IOpBin.XOR;
import static com.dat3m.dartagnan.expression.op.IOpBin.OR;
import static com.dat3m.dartagnan.expression.op.IOpBin.PLUS;
import static com.dat3m.dartagnan.expression.op.IOpBin.AND;
import static com.dat3m.dartagnan.expression.op.IOpBin.MOD;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.antlr.v4.runtime.tree.ParseTree;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.expression.BExprBin;
import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.expression.BNonDet;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.IExprUn;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.IfExpr;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.parsers.BoogieBaseVisitor;
import com.dat3m.dartagnan.parsers.BoogieParser.And_exprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Assert_cmdContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Assign_cmdContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Assume_cmdContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Attr_typed_idents_whereContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Axiom_declContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Bool_litContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Const_declContext;
import com.dat3m.dartagnan.parsers.BoogieParser.DecContext;
import com.dat3m.dartagnan.parsers.BoogieParser.ExprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.ExprsContext;
import com.dat3m.dartagnan.parsers.BoogieParser.FactorContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Fun_exprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Func_declContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Goto_cmdContext;
import com.dat3m.dartagnan.parsers.BoogieParser.If_cmdContext;
import com.dat3m.dartagnan.parsers.BoogieParser.If_then_else_exprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Impl_bodyContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Int_exprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.LabelContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Local_varsContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Logical_exprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.MainContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Minus_exprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Neg_exprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Or_exprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Paren_exprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Proc_declContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Rel_exprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Return_cmdContext;
import com.dat3m.dartagnan.parsers.BoogieParser.TermContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Var_declContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Var_exprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.While_cmdContext;
import com.dat3m.dartagnan.parsers.BoogieVisitor;
import com.dat3m.dartagnan.boogie.Function;
import com.dat3m.dartagnan.boogie.FunctionCall;
import com.dat3m.dartagnan.boogie.PthreadPool;
import com.dat3m.dartagnan.boogie.Scope;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Assume;
import com.dat3m.dartagnan.program.event.BoundEvent;
import com.dat3m.dartagnan.program.event.Comment;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.If;
import com.dat3m.dartagnan.program.event.Jump;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.Skip;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.While;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.program.event.rmw.BeginAtomic;
import com.dat3m.dartagnan.program.event.rmw.EndAtomic;

public class VisitorBoogie extends BoogieBaseVisitor<Object> implements BoogieVisitor<Object> {

	private ProgramBuilder programBuilder;
    private int threadCount = 0;
    
    private Label currentLabel = null;
    private Map<Label, Label> pairLabels = new HashMap<>();
    
    private Map<String, Function> functions = new HashMap<>();
	private FunctionCall currentCall = null;
	
	// Improves performance by initializing Locations rather than creating new write events
	private boolean initMode = false;
	
	private Map<String, Proc_declContext> procedures = new HashMap<>();
	private PthreadPool pool = new PthreadPool();
	
	private int nextScopeID = 0;
	private Scope currentScope = new Scope(nextScopeID, null);
	
	private List<Register> returnRegister = new ArrayList<>();
	private String currentReturnName = null;
	
	private List<String> constants = new ArrayList<>();
	private Map<String, ExprInterface> constantsMap = new HashMap<>();
	
	private List<ExprInterface> mainCallingValues = new ArrayList<>();
	
	private int assertionIndex = 0;
	
	private List<IExpr> lockAddresses = new ArrayList<>();
	
	private BeginAtomic currentBeginAtomic = null;
	private Call_cmdContext atomicMode = null;
	
	private boolean handlePointer = false;
	
	public VisitorBoogie(ProgramBuilder pb) {
		this.programBuilder = pb;
	}
	
    @Override
    public Object visitMain(MainContext ctx) {
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

    	Register next = programBuilder.getOrCreateRegister(threadCount, "ptrMain");
    	pool.add(next, "main");
    	while(pool.canCreate()) {
    		next = pool.next();
    		String nextName = pool.getNameFromPtr(next);
    		pool.addIntPtr(threadCount + 1, next);
    		visitProc_decl(procedures.get(nextName), true, mainCallingValues);	
    	}
    	return programBuilder.build();
    }

	private void preProc_decl(Proc_declContext ctx) {
		String name = ctx.proc_sign().Ident().getText();
    	if(procedures.containsKey(name)) {
    		throw new ParsingException("Procedure " + name + " is already defined");
    	}
    	if(name.equals("main") && ctx.proc_sign().proc_sign_in() != null) {
        	for(Attr_typed_idents_whereContext atiwC : ctx.proc_sign().proc_sign_in().attr_typed_idents_wheres().attr_typed_idents_where()) {
        		for(ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
            		mainCallingValues.add(programBuilder.getOrCreateRegister(threadCount, currentScope.getID() + ":" + ident.getText()));
        		}
        	}
    	}
    	procedures.put(name, ctx);
	}

	@Override
	public Object visitAxiom_decl(Axiom_declContext ctx) {
		ExprInterface exp = (ExprInterface)ctx.proposition().accept(this);
		if(exp instanceof Atom && ((Atom)exp).getLHS() instanceof Register && ((Atom)exp).getOp().equals(EQ)) {
			String name = ((Register)((Atom)exp).getLHS()).getName();
			ExprInterface def = ((Atom)exp).getRHS();
			constantsMap.put(name, def);
		}
		return null;
	}

	@Override
	public Object visitConst_decl(Const_declContext ctx) {
		for(ParseTree ident : ctx.typed_idents().idents().Ident()) {
			constants.add(ident.getText());
		}
		return null;
	}

	@Override
	public Object visitFunc_decl(Func_declContext ctx) {
		String name = ctx.Ident().getText();
		functions.put(name, new Function(name, ctx.var_or_type(), ctx.expr()));
		return null;
	}

    @Override
    public Object visitVar_decl(Var_declContext ctx) {
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
    
	public Object visitLocal_vars(Local_varsContext ctx, int scope) {
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

    public void visitProc_decl(Proc_declContext ctx, boolean create, List<ExprInterface> callingValues) {
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
            if(threadCount != 1) {
        		Location loc = programBuilder.getOrCreateLocation(pool.getPtrFromInt(threadCount) + "_active");
        		Register reg = programBuilder.getOrCreateRegister(threadCount, null);
               	Label label = programBuilder.getOrCreateLabel("END_OF_T" + threadCount);
        		programBuilder.addChild(threadCount, new Load(reg, loc.getAddress(), "NA"));
        		programBuilder.addChild(threadCount, new Assume(new Atom(reg, EQ, new IConst(1)), label));
            }
    	}

    	currentScope = new Scope(nextScopeID, currentScope);
    	nextScopeID++;
    	
    	Impl_bodyContext body = ctx.impl_body();;
    	if(body == null) {
    		currentScope = currentScope.getParent();
    		return;
    	}

    	if(ctx.proc_sign().proc_sign_in() != null) {
			int index = 0;
    		for(Attr_typed_idents_whereContext atiwC : ctx.proc_sign().proc_sign_in().attr_typed_idents_wheres().attr_typed_idents_where()) {
    			for(ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
    				// To deal with references passed to created threads
    				if(index < callingValues.size()) {
        				Register register = programBuilder.getOrCreateRegister(threadCount, currentScope.getID() + ":" + ident.getText());
        				ExprInterface value = callingValues.get(index);
        				programBuilder.addChild(threadCount, new Local(register, value));
        				index++;    					
    				}
    			}
    		}    		
    	}

        for(Local_varsContext localVarContext : body.local_vars()) {
        	visitLocal_vars(localVarContext, threadCount);
        }

        visitChildren(body.stmt_list());

		Label label = programBuilder.getOrCreateLabel("END_OF_" + currentScope.getID());
   		programBuilder.addChild(threadCount, label);
        
        currentScope = currentScope.getParent();
        
    	if(create) {
         	if(threadCount != 1) {
        		Location loc = programBuilder.getOrCreateLocation(pool.getPtrFromInt(threadCount) + "_active");
        		programBuilder.addChild(threadCount, new Store(loc.getAddress(), new IConst(0), "NA"));
         	}
        	label = programBuilder.getOrCreateLabel("END_OF_T" + threadCount);
         	programBuilder.addChild(threadCount, label);
    	}
    }
    
    @Override 
    public Object visitAssert_cmd(Assert_cmdContext ctx) {
    	// In boogie transformation, assertions result in "assert false".
    	// The control flow checks the corresponding expression, thus
    	// we cannot just add the expression to the AbstractAssertion.
    	// We need to create an event carrying the value of the expression 
    	// and see if this event can be executed.
    	Register ass = programBuilder.getOrCreateRegister(threadCount, "assert_" + assertionIndex);
    	assertionIndex++;
    	ExprInterface expr = (ExprInterface)ctx.proposition().expr().accept(this);
    	Local event = new Local(ass, expr);
		event.addFilters(EType.ASSERTION);
		programBuilder.addChild(threadCount, event);
    	return null;
    }
    
	@Override
	public Object visitCall_cmd(Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		if(name.equals("$initialize")) {
			initMode = true;;
		}
		if(name.equals("$alloc") || name.equals("$$alloc")) {
			return null;
		}
		if(name.equals("calloc") || name.equals("$malloc")) {
			throw new ParsingException("ERROR");
		}
		if(name.equals("pthread_mutex_init")) {
			mutexInit(ctx.call_params().exprs().expr(0), ctx.call_params().exprs().expr(1));
			return null;
		}
		if(name.equals("pthread_mutex_lock")) {
			mutexLock(ctx.call_params().exprs());
			return null;
		}
		if(name.equals("pthread_mutex_unlock")) {
			mutexUnlock(ctx.call_params().exprs());
			return null;
		}
		if(name.equals("corral_getThreadID")) {
			return new IConst(threadCount);
		}
		if(name.equals("abort")) {
			abort();
			return null;
		}
		// TODO seems to be obsolete in SVCOMP 2021
		if(name.equals("__VERIFIER_assume")) {
			__VERIFIER_assume(ctx.call_params().exprs());
			return null;
		}
		if(name.equals("__VERIFIER_nondet_int")) {
			__VERIFIER_nondet_int(ctx.call_params().Ident(0).getText(), true);
			return null;
		}
		if(name.equals("__VERIFIER_nondet_uint")) {
			__VERIFIER_nondet_int(ctx.call_params().Ident(0).getText(), false);
			return null;
		}
		if(name.equals("__VERIFIER_nondet_bool")) {
			__VERIFIER_nondet_bool(ctx.call_params().Ident(0).getText());
			return null;
		}
		if(name.equals("__VERIFIER_atomic_begin")) {
			__VERIFIER_atomic_begin();
			return null;
		}
		if(name.equals("__VERIFIER_atomic_end")) {
			__VERIFIER_atomic_end();
			return null;
		}
		// The order is important
		if(name.contains("__VERIFIER_atomic_")) {
			atomicMode = ctx;
			__VERIFIER_atomic_begin();
			// No return, the body still needs to be parsed.
		}	
		if(name.equals("pthread_create")) {
			String namePtr = ctx.call_params().exprs().expr().get(0).getText();
			Register threadPtr = programBuilder.getOrCreateRegister(threadCount, namePtr);
			String threadName = ctx.call_params().exprs().expr().get(2).getText();
			pthread_create(threadPtr, threadName);
			return null;
		}
		// Sometimes the compiler convert it to __pthread_join
		if(name.contains("pthread_join") && ctx.call_params().Define() != null) {
			String namePtr = ctx.call_params().exprs().expr().get(0).getText();
			Register callReg = programBuilder.getOrCreateRegister(threadCount, namePtr);
			String retName = ctx.call_params().Ident(0).getText();
			Register retReg = programBuilder.getOrCreateRegister(threadCount, retName);
			pthread_join(retReg, pool.getPtrFromReg(callReg));
			return null;
		}
		// Some procedures might have an empty implementation.
		// There will be no return for them.
		if(ctx.call_params().Define() != null && procedures.get(name).impl_body() != null) {
			Register register = programBuilder.getRegister(threadCount, currentScope.getID() + ":" + ctx.call_params().Ident(0).getText());
	        if(register != null){
	            returnRegister.add(register);
	        }
		}
	    List<ExprInterface> callingValues = new ArrayList<>();
		if(ctx.call_params().exprs() != null) {
			callingValues = ctx.call_params().exprs().expr().stream().map(c -> (ExprInterface)c.accept(this)).collect(Collectors.toList());
		}
		if(!procedures.containsKey(name)) {
			throw new ParsingException("Procedure " + name + " is not defined");
		}
		// Nice to have for debugging
		if(!name.contains("boogie_si_record") && !name.contains("printf.ref")) {
			programBuilder.addChild(threadCount, new Comment(" Start of " + name + " "));	
		}
		visitProc_decl(procedures.get(name), false, callingValues);
		if(ctx.equals(atomicMode)) {
			__VERIFIER_atomic_end();
			atomicMode = null;
		}
		if(!name.contains("boogie_si_record") && !name.contains("printf.ref")) {
			programBuilder.addChild(threadCount, new Comment(" End of " + name + " "));
		}
		if(name.equals("$initialize")) {
			initMode = false;
		}
		return null;
	}

	private void pthread_create(Register ptr, String name) {
		if(!procedures.containsKey(name)) {
			throw new ParsingException("Procedure " + name + " is not defined");
		}
		pool.add(ptr, name);
		Location loc = programBuilder.getOrCreateLocation(ptr + "_active");
		programBuilder.addChild(threadCount, new Store(loc.getAddress(), new IConst(1), "NA"));
	}

	private void pthread_join(Register retRegister, Register ptr) {
	    if(retRegister != null){
	    	programBuilder.addChild(threadCount, new Local(retRegister, new IConst(0)));
	    }		
		Location loc = programBuilder.getOrCreateLocation(ptr + "_active");
		Register reg = programBuilder.getOrCreateRegister(threadCount, null);
       	Label label = programBuilder.getOrCreateLabel("END_OF_T" + threadCount);
		programBuilder.addChild(threadCount, new Load(reg, loc.getAddress(), "NA"));
		programBuilder.addChild(threadCount, new Assume(new Atom(reg, EQ, new IConst(0)), label));
	}

	private void __VERIFIER_nondet_int(String registerName, boolean signed) {
		Register register = programBuilder.getRegister(threadCount, currentScope.getID() + ":" + registerName);
	    if(register != null){
	    	programBuilder.addChild(threadCount, new Local(register, new INonDet(signed)));
	    }		
	}

	private void __VERIFIER_nondet_bool(String registerName) {
		Register register = programBuilder.getRegister(threadCount, currentScope.getID() + ":" + registerName);
	    if(register != null){
	    	programBuilder.addChild(threadCount, new Local(register, new BNonDet()));
	    }		
	}

	private void abort() {
       	Label label = programBuilder.getOrCreateLabel("END_OF_T" + threadCount);
		programBuilder.addChild(threadCount, new Jump(label));	
	}
	
	//TODO: seems to be obsolete after SVCOMP 2020
	private void __VERIFIER_assume(ExprsContext exp) {
       	Label label = programBuilder.getOrCreateLabel("END_OF_T" + threadCount);
       	ExprInterface c = (ExprInterface)exp.accept(this);
		if(c != null) {
			programBuilder.addChild(threadCount, new Assume(c, label));	
		}
	}
	
	private void mutexInit(ExprContext lock, ExprContext value) {
		IExpr lockAddress = (IExpr)lock.accept(this);
		IExpr val = (IExpr)value.accept(this);
		if(lockAddress != null) {
			programBuilder.addChild(threadCount, new Store(lockAddress, val, "NA"));	
		}
	}
	
	private void mutexLock(ExprsContext exp) {
        Register register = programBuilder.getOrCreateRegister(threadCount, null);
		IExpr lockAddress = (IExpr)exp.accept(this);
		lockAddresses.add(lockAddress);
       	Label label = programBuilder.getOrCreateLabel("END_OF_T" + threadCount);
		if(lockAddress != null) {
	        LinkedList<Event> events = new LinkedList<>();
	        events.add(new Load(register, lockAddress, "NA"));
	        events.add(new CondJump(new Atom(register, NEQ, new IConst(0)),label));
	        events.add(new Store(lockAddress, new IConst(1), "NA"));
	        for(Event e : events) {
	        	e.addFilters(EType.LOCK);
	        	e.addFilters(EType.RMW);
				programBuilder.addChild(threadCount, e);
	        }
		}
	}
	
	private void mutexUnlock(ExprsContext exp) {
        Register register = programBuilder.getOrCreateRegister(threadCount, null);
		IExpr lockAddress = (IExpr)exp.accept(this);
       	Label label = programBuilder.getOrCreateLabel("END_OF_T" + threadCount);
		if(lockAddress != null) {
			if(!lockAddress.equals(lockAddresses.remove(lockAddresses.size() - 1))) {
	            throw new ParsingException("The lock address of mutexUnlock does not match the one of mutexLock");
			}
			LinkedList<Event> events = new LinkedList<>();
	        events.add(new Load(register, lockAddress, "NA"));
	        events.add(new CondJump(new Atom(register, NEQ, new IConst(1)),label));
	        events.add(new Store(lockAddress, new IConst(0), "NA"));
	        for(Event e : events) {
	        	e.addFilters(EType.LOCK);
	        	e.addFilters(EType.RMW);
				programBuilder.addChild(threadCount, e);
	        }
		}
	}
	
	private void __VERIFIER_atomic_begin() {
		currentBeginAtomic = new BeginAtomic();
		programBuilder.addChild(threadCount, currentBeginAtomic);	
	}
	
	private void __VERIFIER_atomic_end() {
		if(currentBeginAtomic == null) {
            throw new ParsingException("__VERIFIER_atomic_end() does not have a matching __VERIFIER_atomic_begin()");
		}
		programBuilder.addChild(threadCount, new EndAtomic(currentBeginAtomic));	
		currentBeginAtomic = null;
	}
	
	@Override
	public Object visitWhile_cmd(While_cmdContext ctx) {
        ExprInterface expr = (ExprInterface)ctx.guard().expr().accept(this);
        Skip exitEvent = new Skip();
        While whileEvent = new While(expr, exitEvent);
        programBuilder.addChild(threadCount, whileEvent);

        visitChildren(ctx.stmt_list());
        return programBuilder.addChild(threadCount, exitEvent);
	}

	@Override
	public Object visitIf_cmd(If_cmdContext ctx) {
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
	public Object visitAssign_cmd(Assign_cmdContext ctx) {
		// TODO: find a nicer way of dealing with this
		if(ctx.getText().contains("$load.")) {
			Register reg = programBuilder.getOrCreateRegister(threadCount, ctx.Ident(0).getText());
			String tmp = ctx.def_body().exprs().expr(0).getText();
			tmp = tmp.substring(0, tmp.lastIndexOf(')'));
			tmp = tmp.substring(tmp.lastIndexOf(',')+1);
			Register ptr = programBuilder.getOrCreateRegister(threadCount, tmp);
			pool.addRegPtr(reg, ptr);
		}
        ExprsContext exprs = ctx.def_body().exprs();
    	if(exprs.expr().size() != 1 && exprs.expr().size() != ctx.Ident().size()) {
            throw new ParsingException("There should be one expression per variable\nor only one expression for all in " + ctx.getText());
    	}
		for(int i = 0; i < ctx.Ident().size(); i++) {
			ExprInterface value = (ExprInterface)exprs.expr(i).accept(this);
	        if(value == null) {
	        	continue;
	        }		
			String name = ctx.Ident(i).getText();
			if(constants.contains(name)) {
				throw new ParsingException("Constants cannot be assigned: " + ctx.getText());
			}
			if(initMode) {
				programBuilder.initLocEqConst(name, value.reduce());
				continue;
			}
			Register register = programBuilder.getRegister(threadCount, currentScope.getID() + ":" + name);
	        if(register != null){
	            programBuilder.addChild(threadCount, new Local(register, value));
	            continue;
	        }
	        Location location = programBuilder.getLocation(name);
	        if(location != null){
	            programBuilder.addChild(threadCount, new Store(location.getAddress(), value, "NA"));
	            continue;
	        }
	        if(currentReturnName.equals(name)) {
	        	if(!returnRegister.isEmpty()) {
	        		Register ret = returnRegister.remove(returnRegister.size() - 1);
					programBuilder.addChild(threadCount, new Local(ret, value));
	        	}
	        	continue;
	        }
	        throw new ParsingException("Variable " + name + " is not defined");
		}
		return null;
	}

	@Override
	public Object visitReturn_cmd(Return_cmdContext ctx) {
		Label label = programBuilder.getOrCreateLabel("END_OF_" + currentScope.getID());
		programBuilder.addChild(threadCount, new Jump(label));
		return null;
	}

	@Override
	public Object visitAssume_cmd(Assume_cmdContext ctx) {
		// We can get rid of all the "assume true" statements
		if(!ctx.proposition().expr().getText().equals("true")) {
			Label pairingLabel = null;
			if(!pairLabels.keySet().contains(currentLabel)) {
				// If the current label doesn't have a pairing label, we jump to the end of the program
	        	pairingLabel = programBuilder.getOrCreateLabel("END_OF_" + currentScope.getID());
			} else {
				pairingLabel = pairLabels.get(currentLabel);
			}
			BExpr c = (BExpr)ctx.proposition().expr().accept(this);
			if(c != null) {
				programBuilder.addChild(threadCount, new CondJump(new BExprUn(NOT, c), pairingLabel));	
			}
		}
        return null;
	}

	@Override
	public Object visitLabel(LabelContext ctx) {
		// Since we "inline" procedures, label names might clash
		// thus we use currentScope.getID() + ":"
		String labelName = currentScope.getID() + ":" + ctx.children.get(0).getText();
		Label label = programBuilder.getOrCreateLabel(labelName);
        programBuilder.addChild(threadCount, label);
        currentLabel = label;
        return null;
	}

	@Override
	public Object visitGoto_cmd(Goto_cmdContext ctx) {
    	String labelName = currentScope.getID() + ":" + ctx.idents().children.get(0).getText();
		Label l1 = programBuilder.getOrCreateLabel(labelName);
        programBuilder.addChild(threadCount, new Jump(l1));
        // If there is a loop, we return if the loop is not completely unrolled.
        // SMACK will take care of another escape if the loop is completely unrolled.
   		programBuilder.addChild(threadCount, new BoundEvent());
   		Label label = programBuilder.getOrCreateLabel("END_OF_" + currentScope.getID());
   		programBuilder.addChild(threadCount, new Jump(label));        	
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
	public Object visitLogical_expr(Logical_exprContext ctx) {
		if(ctx.getText().contains("forall") || ctx.getText().contains("exists") || ctx.getText().contains("lambda")) {
			return null;
		}
		ExprInterface v1 = (ExprInterface)ctx.rel_expr().accept(this);
		if(ctx.and_expr() != null) {
			ExprInterface v2 = (ExprInterface)ctx.and_expr().accept(this);
			v1 = new BExprBin(v1, ctx.and_op().op, v2);
		}
		if(ctx.or_expr() != null) {
			ExprInterface v2 = (ExprInterface)ctx.or_expr().accept(this);
			v1 = new BExprBin(v1, ctx.or_op().op, v2);
		}
		return v1;
	}

	@Override
	public Object visitMinus_expr(Minus_exprContext ctx) {
		ExprInterface v = (ExprInterface)ctx.unary_expr().accept(this);
		return new IExprUn(IOpUn.MINUS, v);
	}

	@Override
	public Object visitNeg_expr(Neg_exprContext ctx) {
		ExprInterface v = (ExprInterface)ctx.unary_expr().accept(this);
		return new BExprUn(BOpUn.NOT, v);
	}

	@Override
	public Object visitAnd_expr(And_exprContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.rel_expr(0).accept(this);
		ExprInterface v2 = null;
		for(int i = 0; i < ctx.rel_expr().size()-1; i++) {
			v2 = (ExprInterface)ctx.rel_expr(i+1).accept(this);
			v1 = new BExprBin(v1, ctx.and_op(i).op, v2);
		}
		return v1;
	}

	@Override
	public Object visitOr_expr(Or_exprContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.rel_expr(0).accept(this);
		ExprInterface v2 = null;
		for(int i = 0; i < ctx.rel_expr().size()-1; i++) {
			v2 = (ExprInterface)ctx.rel_expr(i+1).accept(this);
			v1 = new BExprBin(v1, ctx.or_op(i).op, v2);
		}
		return v1;
	}

	@Override
	public Object visitRel_expr(Rel_exprContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.bv_term(0).accept(this);
		ExprInterface v2 = null;
		for(int i = 0; i < ctx.bv_term().size()-1; i++) {
			v2 = (ExprInterface)ctx.bv_term(i+1).accept(this);
			v1 = new Atom(v1, ctx.rel_op(i).op, v2);
		}
		return v1;
	}
	
	@Override
	public Object visitTerm(TermContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.factor(0).accept(this);
		ExprInterface v2 = null;
		for(int i = 0; i < ctx.factor().size()-1; i++) {
			v2 = (ExprInterface)ctx.factor(i+1).accept(this);
			v1 = new IExprBin(v1, ctx.add_op(i).op, v2);
		}
		return v1;
	}

	@Override
	public Object visitFactor(FactorContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.power(0).accept(this);
		ExprInterface v2 = null;
		for(int i = 0; i < ctx.power().size()-1; i++) {
			v2 = (ExprInterface)ctx.power(i+1).accept(this);
			v1 = new IExprBin(v1, ctx.mul_op(i).op, v2);
		}
		return v1;
	}

	@Override
	public Object visitVar_expr(Var_exprContext ctx) {
		String name = ctx.getText();
		if(currentCall != null && currentCall.getFunction().getBody() != null) {
			return currentCall.replaceVarsByExprs(ctx);
		}
		if(constantsMap.containsKey(name)) {
			return constantsMap.get(name);
		}
		if(constants.contains(name)) {
			// Dummy register needed to parse axioms
			return new Register(name, -1);
		}
        Register register = programBuilder.getRegister(threadCount, currentScope.getID() + ":" + name);
        if(register != null){
            return register;
        }
        Location location = programBuilder.getLocation(name);
        if(location != null){
        	if(handlePointer) {
        		return location;
        	}
            register = programBuilder.getOrCreateRegister(threadCount, null);
            programBuilder.addChild(threadCount, new Load(register, location.getAddress(), "NA"));
            return register;
        }
        throw new ParsingException("Variable " + name + " is not defined");
	}

	@Override
	public Object visitFun_expr(Fun_exprContext ctx) {
		//TODO: handle pointers. E.g. when name contains store.i32
		String name = ctx.Ident().getText();
		Function function = functions.get(name);
		if(function == null) {
			throw new ParsingException("Function " + name + " is not defined");
		}
		if(name.contains("$load")) {
			handlePointer = true;
			IExpr init = ((Location)ctx.expr(0).accept(this)).getAddress();
			IExpr plus = (IExpr)ctx.expr(1).accept(this);
			IExpr address = new IExprBin(init, PLUS, plus);
			handlePointer = false;
			return address;
		}
		if(name.contains("$store")) {
			handlePointer = true;
			IExpr init = ((Location)ctx.expr(0).accept(this)).getAddress();
			IExpr plus = (IExpr)ctx.expr(1).accept(this);
			IExpr address = new IExprBin(init, PLUS, plus);
			IExpr value = (IExpr)ctx.expr(2).accept(this);
            programBuilder.addChild(threadCount, new Store(address, value, "NA"));
			handlePointer = false;
			return null;
		}
		// push currentCall to the call stack
		List<Object> callParams = ctx.expr().stream().map(e -> e.accept(this)).collect(Collectors.toList());
		currentCall = new FunctionCall(function, callParams, currentCall);
		// Some functions do not have a body
		if(function.getBody() == null) {
			currentCall = currentCall.getParent();
			// TODO: improve this
			if(name.contains("$urem.")) {
				return new IExprBin((ExprInterface)callParams.get(0), MOD, (ExprInterface)callParams.get(1));
			}
			if(name.contains("$xor.")) {
				return new IExprBin((ExprInterface)callParams.get(0), XOR, (ExprInterface)callParams.get(1));
			}
			if(name.contains("$or.")) {
				return new IExprBin((ExprInterface)callParams.get(0), OR, (ExprInterface)callParams.get(1));
			}
			if(name.contains("$and.")) {
				return new IExprBin((ExprInterface)callParams.get(0), AND, (ExprInterface)callParams.get(1));
			}
			return null;
		}
		Object ret = function.getBody().accept(this);
		// pop currentCall from the call stack
		currentCall = currentCall.getParent();
		return ret;
	}

	@Override
	public Object visitIf_then_else_expr(If_then_else_exprContext ctx) {
		BExpr guard = (BExpr)ctx.expr(0).accept(this);
		ExprInterface tbranch = (ExprInterface)ctx.expr(1).accept(this);
		ExprInterface fbranch = (ExprInterface)ctx.expr(2).accept(this);
		return new IfExpr(guard, tbranch, fbranch);
	}

	@Override
	public Object visitParen_expr(Paren_exprContext ctx) {
		return ctx.expr().accept(this);
	}

	@Override
	public Object visitInt_expr(Int_exprContext ctx) {
		try {
			return new IConst(Integer.parseInt(ctx.getText()));
		} catch (Exception e) {
			return new IConst(Integer.MAX_VALUE);
		}
	}
	
	@Override
	public Object visitBool_lit(Bool_litContext ctx) {
		return new BConst(Boolean.parseBoolean(ctx.getText()));
	}

	@Override
	public Object visitDec(DecContext ctx) {
        throw new ParsingException("Floats are not yet supported");
	}
}