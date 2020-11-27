package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import static com.dat3m.dartagnan.expression.op.BOpUn.NOT;
import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.AtomicProcedures.ATOMICPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.AtomicProcedures.handleAtomicFunction;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.DummyProcedures.DUMMYPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.PthreadsProcedures.PTHREADPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.PthreadsProcedures.handlePthreadsFunctions;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.StdProcedures.I32_BYTES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.StdProcedures.STDPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.StdProcedures.handleStdFunction;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.SvcompProcedures.SVCOMPPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.SvcompProcedures.handleSvcompFunction;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;
import static com.dat3m.dartagnan.program.llvm.utils.LlvmFunctions.LLVMFUNCTIONS;
import static com.dat3m.dartagnan.program.llvm.utils.LlvmFunctions.llvmFunction;
import static com.dat3m.dartagnan.program.llvm.utils.LlvmPredicates.LLVMPREDICATES;
import static com.dat3m.dartagnan.program.llvm.utils.LlvmPredicates.llvmPredicate;
import static com.dat3m.dartagnan.program.llvm.utils.LlvmUnary.LLVMUNARY;
import static com.dat3m.dartagnan.program.llvm.utils.LlvmUnary.llvmUnary;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.antlr.v4.runtime.tree.ParseTree;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.expression.BExprBin;
import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.IExprUn;
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
import com.dat3m.dartagnan.parsers.BoogieParser.Bv_exprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Const_declContext;
import com.dat3m.dartagnan.parsers.BoogieParser.DecContext;
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
import com.dat3m.dartagnan.program.atomic.event.AtomicLoad;
import com.dat3m.dartagnan.program.atomic.event.AtomicStore;
import com.dat3m.dartagnan.program.event.Assume;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.FunCall;
import com.dat3m.dartagnan.program.event.FunRet;
import com.dat3m.dartagnan.program.event.If;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.Skip;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.While;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.program.svcomp.event.BeginAtomic;
import com.dat3m.dartagnan.program.svcomp.event.EndAtomic;

public class VisitorBoogie extends BoogieBaseVisitor<Object> implements BoogieVisitor<Object> {

	protected ProgramBuilder programBuilder;
	protected int threadCount = 0;
	protected int currentThread = 0;
    
	protected int currentLine= -1;
	
    private Label currentLabel = null;
    private Map<Label, Label> pairLabels = new HashMap<>();
    
    private Map<String, Function> functions = new HashMap<>();
	private FunctionCall currentCall = null;
	
	// Improves performance by initializing Locations rather than creating new write events
	private boolean initMode = false;
	
	private Map<String, Proc_declContext> procedures = new HashMap<>();
	protected PthreadPool pool = new PthreadPool();
	protected List<Register> allocationRegs = new ArrayList<Register>();
	
	private int nextScopeID = 0;
	protected Scope currentScope = new Scope(nextScopeID, null);
	
	private List<Register> returnRegister = new ArrayList<>();
	private String currentReturnName = null;
	
	private Map<String, ExprInterface> constantsMap = new HashMap<>();
	private Map<String, Integer> constantsTypeMap = new HashMap<>();

	protected Map<Integer, List<ExprInterface>> threadCallingValues = new HashMap<>();
	
	protected int assertionIndex = 0;
	
	protected BeginAtomic currentBeginAtomic = null;
	private Call_cmdContext atomicMode = null;
	 
	private List<String> smackDummyVariables = Arrays.asList("$GLOBALS_BOTTOM", "$EXTERNS_BOTTOM", "$MALLOC_TOP", "__SMACK_code", "__SMACK_decls", "__SMACK_top_decl", "$1024.ref", "$0.ref", "$1.ref", ".str.1", "env_value_str", ".str.1.3", ".str.19", "errno_global", "$CurrAddr");

	public VisitorBoogie(ProgramBuilder pb) {
		this.programBuilder = pb;
	}
	
    @Override
    public Object visitMain(MainContext ctx) {
    	for(Func_declContext funDecContext : ctx.func_decl()) {
    		visitFunc_decl(funDecContext);
    	}
    	for(Proc_declContext procDecContext : ctx.proc_decl()) {
    		preProc_decl(procDecContext);
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
    	if(!procedures.containsKey("main")) {
    		throw new ParsingException("Program shall have a main procedure");
    	}

    	Register next = programBuilder.getOrCreateRegister(threadCount, currentScope.getID() + ":" + "ptrMain", -1);
    	pool.add(next, "main");
    	while(pool.canCreate()) {
    		next = pool.next();
    		String nextName = pool.getNameFromPtr(next);
    		pool.addIntPtr(threadCount + 1, next);
    		visitProc_decl(procedures.get(nextName), true, threadCallingValues.get(threadCount));	
    	}
    	return programBuilder.build();
    }

	private void preProc_decl(Proc_declContext ctx) {
		String name = ctx.proc_sign().Ident().getText();
    	if(procedures.containsKey(name)) {
    		throw new ParsingException("Procedure " + name + " is already defined");
    	}
    	if(name.equals("main") && ctx.proc_sign().proc_sign_in() != null) {
    		threadCallingValues.put(threadCount, new ArrayList<>());
        	for(Attr_typed_idents_whereContext atiwC : ctx.proc_sign().proc_sign_in().attr_typed_idents_wheres().attr_typed_idents_where()) {
        		for(ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
        			String type = atiwC.typed_idents_where().typed_idents().type().getText();
        			int precision = type.contains("bv") ? Integer.parseInt(type.split("bv")[1]) : -1;
            		threadCallingValues.get(threadCount).add(programBuilder.getOrCreateRegister(threadCount, currentScope.getID() + ":" + ident.getText(), precision));
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
			String name = ident.getText();
			String type = ctx.typed_idents().type().getText();
			int precision = type.contains("bv") ? Integer.parseInt(type.split("bv")[1]) : -1;
			if(ctx.getText().contains("{:count")) {
				int size = Integer.parseInt((ctx.getText().substring(0, ctx.getText().lastIndexOf("}")).split("count")[1]))*I32_BYTES;
				programBuilder.addDeclarationArray(name, Collections.nCopies(size, new IConst(0, precision)), precision);
			} else if(ctx.getText().contains("ref;") && !procedures.containsKey(name) && !smackDummyVariables.contains(name)) {
				programBuilder.getOrCreateLocation(name, precision);
			} else {
				constantsTypeMap.put(name, precision);
			}
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
    		 for(ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
    			 String name = ident.getText();
    			 String type = atiwC.typed_idents_where().typed_idents().type().getText();
    			 int precision = type.contains("bv") && !name.equals("$M.0") ? Integer.parseInt(type.split("bv")[1]) : -1;
    			 programBuilder.getOrCreateLocation(name, precision);
    		 }
    	 }
    	 return null;
    }
    
	public Object visitLocal_vars(Local_varsContext ctx, int scope) {
		for(Attr_typed_idents_whereContext atiwC : ctx.typed_idents_wheres().attr_typed_idents_where()) {
			for(ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
				String name = ident.getText();
				String type = atiwC.typed_idents_where().typed_idents().type().getText();
				int precision = type.contains("bv") ? Integer.parseInt(type.split("bv")[1]) : -1;
				if(constantsTypeMap.containsKey(name)) {
	                throw new ParsingException("Variable " + name + " is already defined as a constant");
				}
				if(programBuilder.getLocation(name) != null) {
	                throw new ParsingException("Variable " + name + " is already defined globally");
				}
				programBuilder.getOrCreateRegister(scope, currentScope.getID() + ":" + name, precision);
			}			
		}
   	 	return null;
   	 }

    private void visitProc_decl(Proc_declContext ctx, boolean create, List<ExprInterface> callingValues) {
    	currentLine = -1;
    	if(ctx.proc_sign().proc_sign_out() != null) {
    		for(Attr_typed_idents_whereContext atiwC : ctx.proc_sign().proc_sign_out().attr_typed_idents_wheres().attr_typed_idents_where()) {
    			for(ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
    				currentReturnName = ident.getText();
    			}
    		}    		
    	}

    	if(create) {
         	threadCount ++;
    		String name = ctx.proc_sign().Ident().getText();
            programBuilder.initThread(name, threadCount);
            if(threadCount != 1) {
            	// Used to allow execution of threads after they have been created (pthread_create)
        		Location loc = programBuilder.getOrCreateLocation(pool.getPtrFromInt(threadCount) + "_active", -1);
        		Register reg = programBuilder.getOrCreateRegister(threadCount, null, -1);
               	Label label = programBuilder.getOrCreateLabel("END_OF_T" + threadCount);
        		programBuilder.addChild(threadCount, new AtomicLoad(reg, loc.getAddress(), SC));
        		programBuilder.addChild(threadCount, new Assume(new Atom(reg, EQ, new IConst(1, -1)), label));
            }
    	}

    	currentScope = new Scope(nextScopeID, currentScope);
    	nextScopeID++;
    	
    	Impl_bodyContext body = ctx.impl_body();;
    	if(body == null) {
			throw new ParsingException(ctx.proc_sign().Ident().getText() + " cannot be handled");
    	}

    	if(ctx.proc_sign().proc_sign_in() != null) {
			int index = 0;
    		for(Attr_typed_idents_whereContext atiwC : ctx.proc_sign().proc_sign_in().attr_typed_idents_wheres().attr_typed_idents_where()) {
    			for(ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
    				// To deal with references passed to created threads
    				if(index < callingValues.size()) {
    					String type = atiwC.typed_idents_where().typed_idents().type().getText();
    					int precision = type.contains("bv") ? Integer.parseInt(type.split("bv")[1]) : -1;
        				Register register = programBuilder.getOrCreateRegister(threadCount, currentScope.getID() + ":" + ident.getText(), precision);
        				ExprInterface value = callingValues.get(index);
        				Local child = new Local(register, value);
        				child.setCLine(currentLine);
						programBuilder.addChild(threadCount, child);
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
         		// Used to mark the end of the execution of a thread (used by pthread_join)
        		Location loc = programBuilder.getOrCreateLocation(pool.getPtrFromInt(threadCount) + "_active", -1);
        		programBuilder.addChild(threadCount, new AtomicStore(loc.getAddress(), new IConst(0, -1), SC));
         	}
        	label = programBuilder.getOrCreateLabel("END_OF_T" + threadCount);
         	programBuilder.addChild(threadCount, label);
    	}
    	currentLine = -1;
    }
    
    @Override 
    public Object visitAssert_cmd(Assert_cmdContext ctx) {
    	// In boogie transformation, assertions result in "assert false".
    	// The control flow checks the corresponding expression, thus
    	// we cannot just add the expression to the AbstractAssertion.
    	// We need to create an event carrying the value of the expression 
    	// and see if this event can be executed.
    	ExprInterface expr = (ExprInterface)ctx.proposition().expr().accept(this);
    	Register ass = programBuilder.getOrCreateRegister(threadCount, "assert_" + assertionIndex, expr.getPrecision());
    	assertionIndex++;
    	Local event = new Local(ass, expr);
		event.addFilters(EType.ASSERTION);
		event.setCLine(currentLine);
		programBuilder.addChild(threadCount, event);
    	return null;
    }
    
	@Override
	public Object visitCall_cmd(Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		if(name.equals("$initialize")) {
			initMode = true;;
		}
		if(name.equals("abort")) {
	       	Label label = programBuilder.getOrCreateLabel("END_OF_T" + threadCount);
			programBuilder.addChild(threadCount, new CondJump(new BConst(true), label));
	       	return null;
		}
		if(name.equals("reach_error")) {
	    	Register ass = programBuilder.getOrCreateRegister(threadCount, "assert_" + assertionIndex, -1);
	    	assertionIndex++;
	    	Local event = new Local(ass, new BConst(false));
			event.addFilters(EType.ASSERTION);
			event.setCLine(currentLine);
			programBuilder.addChild(threadCount, event);
			return null;
		}

		if(DUMMYPROCEDURES.stream().anyMatch(e -> name.startsWith(e))) {
			return null;
		}
		if(PTHREADPROCEDURES.stream().anyMatch(e -> name.contains(e))) {
			handlePthreadsFunctions(this, ctx);
			return null;
		}
		if(SVCOMPPROCEDURES.stream().anyMatch(e -> name.contains(e))) {
			handleSvcompFunction(this, ctx);
			return null;
		}
		if(ATOMICPROCEDURES.stream().anyMatch(e -> name.startsWith(e))) {
			handleAtomicFunction(this, ctx);
			return null;
		}
		if(STDPROCEDURES.stream().anyMatch(e -> name.startsWith(e))) {
			handleStdFunction(this, ctx);
			return null;
		}
		if(name.contains("__VERIFIER_atomic_")) {
			atomicMode = ctx;
			currentBeginAtomic = new BeginAtomic();
			programBuilder.addChild(threadCount, currentBeginAtomic);	
			// No return, the body still needs to be parsed.
		}
		// TODO: double check this 
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
		programBuilder.addChild(threadCount, new FunCall(name));	
		visitProc_decl(procedures.get(name), false, callingValues);
		if(ctx.equals(atomicMode)) {
			if(currentBeginAtomic == null) {
	            throw new ParsingException("__VERIFIER_atomic_end() does not have a matching __VERIFIER_atomic_begin()");
			}
			programBuilder.addChild(threadCount, new EndAtomic(currentBeginAtomic));	
			currentBeginAtomic = null;
			atomicMode = null;
		}
		programBuilder.addChild(threadCount, new FunRet(name));
		if(name.equals("$initialize")) {
			initMode = false;
		}
		return null;
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
	        if(smackDummyVariables.contains(name)) {
	        	continue;
	        }
			if(constantsTypeMap.containsKey(name)) {
				throw new ParsingException("Constants cannot be assigned: " + ctx.getText());
			}
			if(initMode) {
				programBuilder.initLocEqConst(name, value.reduce());
				continue;
			}
			Register register = programBuilder.getRegister(threadCount, currentScope.getID() + ":" + name);
	        if(register != null){
	        	if(ctx.getText().contains("$load.") || value instanceof Address) {
	        		try {
		    			// This names are global so we don't use currentScope.getID(), but per thread.
		    			Register reg = programBuilder.getOrCreateRegister(threadCount, ctx.Ident(0).getText(), -1);
		    			String tmp = ctx.def_body().exprs().expr(0).getText();
		    			tmp = tmp.substring(tmp.indexOf(",") + 1, tmp.indexOf(")"));
		    			// This names are global so we don't use currentScope.getID(), but per thread.
		    			Register ptr = programBuilder.getOrCreateRegister(threadCount, tmp, -1);
	        			pool.addRegPtr(reg, ptr);	        				        			
	        		} catch (Exception e) {
	        			// Nothing to be done
	        		}
	        		Load child = new Load(register, (IExpr)value, null);
	        		if(!allocationRegs.contains(value)) {
		        		child.setCLine(currentLine);
	        		}
					programBuilder.addChild(threadCount, child);	        			
		            continue;
	        	}
	            Local child = new Local(register, value);
	            child.setCLine(currentLine);
				programBuilder.addChild(threadCount, child);	        		
	            continue;
	        }
	        Location location = programBuilder.getLocation(name);
	        if(location != null){
	            Store child = new Store(location.getAddress(), value, null);
	            child.setCLine(currentLine);
				programBuilder.addChild(threadCount, child);
	            continue;
	        }
	        if(currentReturnName.equals(name)) {
	        	if(!returnRegister.isEmpty()) {
	        		Register ret = returnRegister.remove(returnRegister.size() - 1);
					Local child = new Local(ret, value);
					child.setCLine(currentLine);
					programBuilder.addChild(threadCount, child);
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
		programBuilder.addChild(threadCount, new CondJump(new BConst(true), label));
		return null;
	}

	@Override
	public Object visitAssume_cmd(Assume_cmdContext ctx) {
		if(ctx.getText().contains("sourceloc")) {
			String line = ctx.getText();
			currentLine = Integer.parseInt(line.substring(line.indexOf(',') + 1, line.lastIndexOf(',')));
		} else if(!ctx.proposition().expr().getText().equals("true")) {
			currentLine = -1;
		}
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
    	boolean loop = programBuilder.hasLabel(labelName);
    	Label l1 = programBuilder.getOrCreateLabel(labelName);
		programBuilder.addChild(threadCount, new CondJump(new BConst(true), l1));
        // If there is a loop, we return if the loop is not completely unrolled.
        // SMACK will take care of another escape if the loop is completely unrolled.
        if(loop) {
            Label label = programBuilder.getOrCreateLabel("END_OF_" + currentScope.getID());
			programBuilder.addChild(threadCount, new CondJump(new BConst(true), label));        	
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
		if(constantsTypeMap.containsKey(name)) {
			// Dummy register needed to parse axioms
			return new Register(name, -1, constantsTypeMap.get(name));
		}
        Register register = programBuilder.getRegister(threadCount, currentScope.getID() + ":" + name);
        if(register != null){
            return register;
        }
        Location location = programBuilder.getLocation(name);
        if(location != null){
       		return location.getAddress();
        }
        // It might be the start of an array
        location = programBuilder.getLocation(name+"[0]");
        if(location != null){
       		return location.getAddress();
        }
        throw new ParsingException("Variable " + name + " is not defined");
	}

	@Override
	public Object visitFun_expr(Fun_exprContext ctx) {
		String name = ctx.Ident().getText();
		Function function = functions.get(name);
		if(function == null) {
			throw new ParsingException("Function " + name + " is not defined");
		}
		if(name.contains("$load.")) {
			return (IExpr)ctx.expr(1).accept(this);
		}
		if(name.contains("$store.")) {
			if(smackDummyVariables.contains(ctx.expr(1).getText())) {
				return null;
			}
			IExpr address = (IExpr)ctx.expr(1).accept(this);
			IExpr value = (IExpr)ctx.expr(2).accept(this);
			// This improves the blow-up
			if(initMode && value instanceof IConst && ((IConst)value).getValue() == 0) {
				return null;
			}
			Store child = new Store(address, value, null);
			child.setCLine(currentLine);
			programBuilder.addChild(threadCount, child);	
			return null;
		}
		// push currentCall to the call stack
		List<Object> callParams = ctx.expr().stream().map(e -> e.accept(this)).collect(Collectors.toList());
		currentCall = new FunctionCall(function, callParams, currentCall);
		if(LLVMFUNCTIONS.stream().anyMatch(f -> name.startsWith(f))) {
			currentCall = currentCall.getParent();
			return llvmFunction(name, callParams);
		}
		if(LLVMPREDICATES.stream().anyMatch(f -> name.equals(f))) {
			currentCall = currentCall.getParent();
			return llvmPredicate(name, callParams);
		}
		if(LLVMUNARY.stream().anyMatch(f -> name.startsWith(f))) {
			currentCall = currentCall.getParent();
			return llvmUnary(name, callParams);
		}
		// Some functions do not have a body
		if(function.getBody() == null) {
			throw new ParsingException("Function " + name + " has no implementation");
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
	public Object visitBv_expr(Bv_exprContext ctx) {
		int value;
		int precision = Integer.parseInt(ctx.getText().split("bv")[1]);
		try {
			value = Integer.parseInt(ctx.getText().split("bv")[0]);
		} catch (Exception e) {
			//TODO: this can be longer for unsigned int
			value = Integer.MAX_VALUE;
		}
		return new IConst(value, precision);
	}

	@Override
	public Object visitInt_expr(Int_exprContext ctx) {
		int value;
		try {
			value = Integer.parseInt(ctx.getText());
		} catch (Exception e) {
			value = Integer.MAX_VALUE;
		}
		return new IConst(value, -1);
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