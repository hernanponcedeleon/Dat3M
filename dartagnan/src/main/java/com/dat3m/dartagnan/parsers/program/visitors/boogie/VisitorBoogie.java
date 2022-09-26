package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.expression.processing.ExprSimplifier;
import com.dat3m.dartagnan.parsers.BoogieBaseVisitor;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.*;
import com.dat3m.dartagnan.parsers.program.boogie.Function;
import com.dat3m.dartagnan.parsers.program.boogie.FunctionCall;
import com.dat3m.dartagnan.parsers.program.boogie.PthreadPool;
import com.dat3m.dartagnan.parsers.program.boogie.Scope;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.annotations.FunCall;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.tree.ParseTree;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.GlobalSettings.ARCH_PRECISION;
import static com.dat3m.dartagnan.expression.op.BOpUn.NOT;
import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.parsers.program.boogie.LlvmFunctions.LLVMFUNCTIONS;
import static com.dat3m.dartagnan.parsers.program.boogie.LlvmFunctions.llvmFunction;
import static com.dat3m.dartagnan.parsers.program.boogie.LlvmPredicates.LLVMPREDICATES;
import static com.dat3m.dartagnan.parsers.program.boogie.LlvmPredicates.llvmPredicate;
import static com.dat3m.dartagnan.parsers.program.boogie.LlvmUnary.LLVMUNARY;
import static com.dat3m.dartagnan.parsers.program.boogie.LlvmUnary.llvmUnary;
import static com.dat3m.dartagnan.parsers.program.boogie.SmackPredicates.SMACKPREDICATES;
import static com.dat3m.dartagnan.parsers.program.boogie.SmackPredicates.smackPredicate;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.AtomicProcedures.ATOMICPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.AtomicProcedures.handleAtomicFunction;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.DummyProcedures.DUMMYPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.PthreadsProcedures.PTHREADPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.PthreadsProcedures.handlePthreadsFunctions;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.StdProcedures.STDPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.StdProcedures.handleStdFunction;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.SvcompProcedures.SVCOMPPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.LkmmProcedures.*;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.SvcompProcedures.handleSvcompFunction;

public class VisitorBoogie extends BoogieBaseVisitor<Object> {

    private static final Logger logger = LogManager.getLogger(VisitorBoogie.class);
	
	protected ProgramBuilder programBuilder;
	protected int threadCount = 0;
	protected int currentThread = 0;
	private Set<String> threadLocalVariables = new HashSet<String>();

	protected int currentLine= -1;
	protected String sourceCodeFile = "";
	
    private Label currentLabel = null;
    private final Map<Label, Label> pairLabels = new HashMap<>();
    
    private final Map<String, Function> functions = new HashMap<>();
	private FunctionCall currentCall = null;
	
	// Improves performance by initializing Locations rather than creating new write events
	private boolean initMode = false;
	
	private final Map<String, Proc_declContext> procedures = new HashMap<>();
	protected PthreadPool pool = new PthreadPool();
	
	private int nextScopeID = 0;
	protected Scope currentScope = new Scope(nextScopeID, null);
	
	private final List<Register> returnRegister = new ArrayList<>();
	private String currentReturnName = null;
	
	private final Map<String, ExprInterface> constantsMap = new HashMap<>();
	private final Map<String, Integer> constantsTypeMap = new HashMap<>();

	protected Map<Integer, List<ExprInterface>> threadCallingValues = new HashMap<>();
	
	protected int assertionIndex = 0;
	
	protected BeginAtomic currentBeginAtomic = null;
	protected Call_cmdContext atomicMode = null;
	 
	private ExprSimplifier exprSimplifier = new ExprSimplifier();
	
	private final List<String> smackDummyVariables = Arrays.asList("$M.0", "$exn", "$exnv", "$CurrAddr", "$GLOBALS_BOTTOM", "$EXTERNS_BOTTOM", "$MALLOC_TOP", "__SMACK_code", "__SMACK_decls", "__SMACK_top_decl", "$1024.ref", "$0.ref", "$1.ref", ".str.1", "env_value_str", ".str.1.3", ".str.19", "errno_global", "$CurrAddr");

	public VisitorBoogie(ProgramBuilder pb) {
		this.programBuilder = pb;
	}
	
    @Override
    public Object visitMain(MainContext ctx) {
    	visitLine_comment(ctx.line_comment(0));
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

    	Register next = programBuilder.getOrCreateRegister(threadCount, currentScope.getID() + ":" + "ptrMain", ARCH_PRECISION);
    	pool.add(next, "main", -1);
    	while(pool.canCreate()) {
    		next = pool.next();
    		String nextName = pool.getNameFromPtr(next);
    		pool.addIntPtr(threadCount + 1, next);
    		visitProc_decl(procedures.get(nextName), true, threadCallingValues.get(threadCount));	
    	}

    	logger.info("Number of threads (including main): " + threadCount);

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
        			int precision = type.contains("bv") ? Integer.parseInt(type.split("bv")[1]) : ARCH_PRECISION;
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
			int precision = type.contains("bv") ? Integer.parseInt(type.split("bv")[1]) : ARCH_PRECISION;
			if(ctx.getText().contains(":treadLocal")) {
				threadLocalVariables.add(name);
			}
			if(ctx.getText().contains("ref;") && !procedures.containsKey(name) && !smackDummyVariables.contains(name) && ATOMICPROCEDURES.stream().noneMatch(name::startsWith)) {
				int size = ctx.getText().contains(":allocSize")
					? Integer.parseInt(ctx.getText().split(":allocSize")[1].split("}")[0])
					: 1;
				programBuilder.newObject(name,size);
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
                if(!smackDummyVariables.contains(name)) {
                    programBuilder.newObject(name,1);
                }
            }
        }
        return null;
    }
    
	public Object visitLocal_vars(Local_varsContext ctx, int scope) {
		for(Attr_typed_idents_whereContext atiwC : ctx.typed_idents_wheres().attr_typed_idents_where()) {
			for(ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
				String name = ident.getText();
				String type = atiwC.typed_idents_where().typed_idents().type().getText();
				int precision = type.contains("bv") ? Integer.parseInt(type.split("bv")[1]) : ARCH_PRECISION;
				if(constantsTypeMap.containsKey(name)) {
	                throw new ParsingException("Variable " + name + " is already defined as a constant");
				}
				if(programBuilder.getObject(name) != null) {
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
                MemoryObject object = programBuilder.getOrNewObject(String.format("%s(%s)_active", pool.getPtrFromInt(threadCount), pool.getCreatorFromPtr(pool.getPtrFromInt(threadCount))));
                Register reg = programBuilder.getOrCreateRegister(threadCount, null, ARCH_PRECISION);
                programBuilder.addChild(threadCount, EventFactory.Pthread.newStart(reg, object));
            }
    	}

    	currentScope = new Scope(nextScopeID, currentScope);
    	nextScopeID++;
    	
    	Impl_bodyContext body = ctx.impl_body();
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
    					int precision = type.contains("bv") ? Integer.parseInt(type.split("bv")[1]) : ARCH_PRECISION;
        				Register register = programBuilder.getOrCreateRegister(threadCount, currentScope.getID() + ":" + ident.getText(), precision);
        				ExprInterface value = callingValues.get(index);
						programBuilder.addChild(threadCount, EventFactory.newLocal(register, value))
    							.setCLine(currentLine)
    							.setSourceCodeFile(sourceCodeFile);
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
                MemoryObject object = programBuilder.getOrNewObject(String.format("%s(%s)_active", pool.getPtrFromInt(threadCount), pool.getCreatorFromPtr(pool.getPtrFromInt(threadCount))));
                programBuilder.addChild(threadCount, EventFactory.Pthread.newEnd(object));
         	}
    	}
    }
    
    @Override 
    public Object visitAssert_cmd(Assert_cmdContext ctx) {
    	addAssertion((IExpr)ctx.proposition().expr().accept(this));
    	return null;
    }
    
	@Override
	public Object visitCall_cmd(Call_cmdContext ctx) {
		if(ctx.getText().contains("boogie_si_record") && !ctx.getText().contains("smack")) {
			Object local = ctx.call_params().exprs().expr(0).accept(this);
			if(local instanceof Register) {
				String txt = ctx.attr(0).getText();
				String cVar;
				if(ctx.getText().contains("arg:")) {
					cVar = txt.substring(txt.lastIndexOf(":")+1, txt.lastIndexOf("\""));
				} else {					
					cVar = txt.substring(txt.indexOf("\"")+1, txt.lastIndexOf("\""));
				}
				((Register)local).setCVar(cVar);	
			}
			
		}
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		if(name.equals("$initialize")) {
			initMode = true;
		}
		if(name.equals("abort")) {
	       	Label label = programBuilder.getOrCreateLabel("END_OF_T" + threadCount);
			programBuilder.addChild(threadCount, EventFactory.newGoto(label));
	       	return null;
		}
		if(name.equals("reach_error")) {
			addAssertion(IValue.ZERO);
			return null;
		}

		if(DUMMYPROCEDURES.stream().anyMatch(name::startsWith)) {
			return null;
		}
		if(PTHREADPROCEDURES.stream().anyMatch(name::contains)) {
			handlePthreadsFunctions(this, ctx);
			return null;
		}
		if(SVCOMPPROCEDURES.stream().anyMatch(name::contains)) {
			handleSvcompFunction(this, ctx);
			return null;
		}
		if(ATOMICPROCEDURES.stream().anyMatch(name::startsWith)) {
			handleAtomicFunction(this, ctx);
			return null;
		}
		if(STDPROCEDURES.stream().anyMatch(name::startsWith)) {
			handleStdFunction(this, ctx);
			return null;
		}
		if(LKMMPROCEDURES.stream().anyMatch(name::equals)) {
			handleLkmmFunction(this, ctx);
			return null;
		}
		if(name.contains("__VERIFIER_atomic_")) {
			atomicMode = ctx;
			if(GlobalSettings.ATOMIC_AS_LOCK) {
				SvcompProcedures.__VERIFIER_atomic(this, true);	
			} else {
				SvcompProcedures.__VERIFIER_atomic_begin(this);
			}
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
		FunCall call = EventFactory.newFunctionCall(name);
		programBuilder.addChild(threadCount, call)
				.setCLine(currentLine)
				.setSourceCodeFile(sourceCodeFile);	
		visitProc_decl(procedures.get(name), false, callingValues);
		if(ctx.equals(atomicMode)) {
			atomicMode = null;
			if(GlobalSettings.ATOMIC_AS_LOCK) {
				SvcompProcedures.__VERIFIER_atomic(this, false);	
			} else {
				SvcompProcedures.__VERIFIER_atomic_end(this);
			}
			
		}
		programBuilder.addChild(threadCount, EventFactory.newFunctionReturn(name))
				.setCLine(call.getCLine())
				.setSourceCodeFile(sourceCodeFile);
		if(name.equals("$initialize")) {
			initMode = false;
		}
		return null;
	}

	@Override
	public Object visitAssign_cmd(Assign_cmdContext ctx) {
        ExprsContext exprs = ctx.def_body().exprs();
    	if(ctx.Ident().size() != 1 && exprs.expr().size() != ctx.Ident().size()) {
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
				programBuilder.initLocEqConst(name, ((IExpr)value).reduce());
				continue;
			}
			Register register = programBuilder.getRegister(threadCount, currentScope.getID() + ":" + name);
	        if(register != null){
	        	if(ctx.getText().contains("$load.") || value instanceof MemoryObject) {
	        		try {
		    			// This names are global so we don't use currentScope.getID(), but per thread.
		    			Register reg = programBuilder.getOrCreateRegister(threadCount, ctx.Ident(0).getText(), ARCH_PRECISION);
		    			String tmp = ctx.def_body().exprs().expr(0).getText();
		    			tmp = tmp.substring(tmp.indexOf(",") + 1, tmp.indexOf(")"));
		    			// This names are global so we don't use currentScope.getID(), but per thread.
		    			Register ptr = programBuilder.getOrCreateRegister(threadCount, tmp, ARCH_PRECISION);
	        			pool.addRegPtr(reg, ptr);	        				        			
	        		} catch (Exception e) {
	        			// Nothing to be done
	        		}
	        		// These events are eventually compiled and we need to compare its mo, thus it cannot be null
	        		programBuilder.addChild(threadCount, EventFactory.newLoad(register, (IExpr)value, ""))
	        				.setCLine(currentLine)
	        				.setSourceCodeFile(sourceCodeFile);
		            continue;
	        	}
	        	value = value.visit(exprSimplifier);
				programBuilder.addChild(threadCount, EventFactory.newLocal(register, value))
						.setCLine(currentLine)
						.setSourceCodeFile(sourceCodeFile);
	            continue;
	        }
            MemoryObject object = programBuilder.getObject(name);
            if(object != null){
    			// These events are eventually compiled and we need to compare its mo, thus it cannot be null
				programBuilder.addChild(threadCount, EventFactory.newStore(object, value, ""))
						.setCLine(currentLine)
						.setSourceCodeFile(sourceCodeFile);
	            continue;
	        }
	        if(currentReturnName.equals(name)) {
	        	if(!returnRegister.isEmpty()) {
	        		Register ret = returnRegister.remove(returnRegister.size() - 1);
					programBuilder.addChild(threadCount, EventFactory.newLocal(ret, value))
							.setCLine(currentLine)
							.setSourceCodeFile(sourceCodeFile);
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
		programBuilder.addChild(threadCount, EventFactory.newGoto(label));
		return null;
	}

	@Override
	public Object visitAssume_cmd(Assume_cmdContext ctx) {
		if(ctx.getText().contains("sourceloc")) {
			String line = ctx.getText();
			sourceCodeFile = line.substring(line.lastIndexOf('/') + 1, line.indexOf(',') - 1);
			currentLine = Integer.parseInt(line.substring(line.indexOf(',') + 1, line.lastIndexOf(',')));
		}
		// We can get rid of all the "assume true" statements
		if(!ctx.proposition().expr().getText().equals("true")) {
			Label pairingLabel;
			if(!pairLabels.containsKey(currentLabel)) {
				// If the current label doesn't have a pairing label, we jump to the end of the program
				pairingLabel = programBuilder.getOrCreateLabel("END_OF_T" + threadCount);
			} else {
				pairingLabel = pairLabels.get(currentLabel);
			}
			BExpr c = (BExpr)ctx.proposition().expr().accept(this);
			if(c != null) {
				programBuilder.addChild(threadCount, EventFactory.newJumpUnless(c, pairingLabel));
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
		programBuilder.addChild(threadCount, EventFactory.newGoto(l1));
        // If there is a loop, we return if the loop is not completely unrolled.
        // SMACK will take care of another escape if the loop is completely unrolled.
        if(loop) {
            Label label = programBuilder.getOrCreateLabel("END_OF_" + currentScope.getID());
			programBuilder.addChild(threadCount, EventFactory.newGoto(label));
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
		IExpr v = (IExpr)ctx.unary_expr().accept(this);
		return new IExprUn(IOpUn.MINUS, v);
	}

	@Override
	public Object visitNeg_expr(Neg_exprContext ctx) {
		ExprInterface v = (ExprInterface)ctx.unary_expr().accept(this);
		return new BExprUn(NOT, v);
	}

	@Override
	public Object visitAnd_expr(And_exprContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.rel_expr(0).accept(this);
		ExprInterface v2;
		for(int i = 0; i < ctx.rel_expr().size()-1; i++) {
			v2 = (ExprInterface)ctx.rel_expr(i+1).accept(this);
			v1 = new BExprBin(v1, ctx.and_op(i).op, v2);
		}
		return v1;
	}

	@Override
	public Object visitOr_expr(Or_exprContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.rel_expr(0).accept(this);
		ExprInterface v2;
		for(int i = 0; i < ctx.rel_expr().size()-1; i++) {
			v2 = (ExprInterface)ctx.rel_expr(i+1).accept(this);
			v1 = new BExprBin(v1, ctx.or_op(i).op, v2);
		}
		return v1;
	}

	@Override
	public Object visitRel_expr(Rel_exprContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.bv_term(0).accept(this);
		ExprInterface v2;
		for(int i = 0; i < ctx.bv_term().size()-1; i++) {
			v2 = (ExprInterface)ctx.bv_term(i+1).accept(this);
			v1 = new Atom(v1, ctx.rel_op(i).op, v2);
		}
		return v1;
	}
	
	@Override
	public Object visitTerm(TermContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.factor(0).accept(this);
		ExprInterface v2;
		for(int i = 0; i < ctx.factor().size()-1; i++) {
			v2 = (ExprInterface)ctx.factor(i+1).accept(this);
			v1 = new IExprBin((IExpr)v1, ctx.add_op(i).op, (IExpr)v2);
		}
		return v1;
	}

	@Override
	public Object visitFactor(FactorContext ctx) {
		ExprInterface v1 = (ExprInterface)ctx.power(0).accept(this);
		ExprInterface v2 ;
		for(int i = 0; i < ctx.power().size()-1; i++) {
			v2 = (ExprInterface)ctx.power(i+1).accept(this);
			v1 = new IExprBin((IExpr)v1, ctx.mul_op(i).op, (IExpr)v2);
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
			return new Register(name, Register.NO_THREAD, constantsTypeMap.get(name));
		}
        Register register = programBuilder.getRegister(threadCount, currentScope.getID() + ":" + name);
        if(register != null){
            return register;
        }
        if(threadLocalVariables.contains(name)) {
            return programBuilder.getOrNewObject(String.format("%s(%s)", name, threadCount));
        }
        MemoryObject object = programBuilder.getObject(name);
        if(object != null) {
            return object;
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
			return ctx.expr(1).accept(this);
		}
		if(name.contains("$store.")) {
			if(smackDummyVariables.contains(ctx.expr(1).getText())) {
				return null;
			}
			IExpr address = (IExpr)ctx.expr(1).accept(this);
			IExpr value = (IExpr)ctx.expr(2).accept(this);
			// This improves the blow-up
			if(initMode && !(value instanceof MemoryObject)) {
				ExprInterface lhs = address;
				int rhs = 0;
				while(lhs instanceof IExprBin) {
					rhs += ((IExprBin)lhs).getRHS().reduce().getValueAsInt();
					lhs = ((IExprBin)lhs).getLHS();
				}
				String text = ctx.expr(1).getText();				
				String[] split = text.split("add.ref");
				if(split.length > 1) {
					text = split[split.length - 1];
					text = text.substring(text.indexOf("(")+1, text.indexOf(","));
				}
				programBuilder.getOrNewObject(text).appendInitialValue(rhs,value.reduce());
				return null;
			}
			// These events are eventually compiled and we need to compare its mo, thus it cannot be null
			programBuilder.addChild(threadCount, EventFactory.newStore(address, value, ""))
					.setCLine(currentLine)
					.setSourceCodeFile(sourceCodeFile);	
			return null;
		}
		// push currentCall to the call stack
		List<Object> callParams = ctx.expr().stream().map(e -> e.accept(this)).collect(Collectors.toList());
		currentCall = new FunctionCall(function, callParams, currentCall);
		if(LLVMFUNCTIONS.stream().anyMatch(name::startsWith)) {
			currentCall = currentCall.getParent();
			return llvmFunction(name, callParams);
		}
		if(LLVMPREDICATES.stream().anyMatch(name::equals)) {
			currentCall = currentCall.getParent();
			return llvmPredicate(name, callParams);
		}
		if(LLVMUNARY.stream().anyMatch(name::startsWith)) {
			currentCall = currentCall.getParent();
			return llvmUnary(name, callParams);
		}
		if(SMACKPREDICATES.stream().anyMatch(name::equals)) {
			currentCall = currentCall.getParent();
			return smackPredicate(name, callParams);
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
		IExpr tbranch = (IExpr)ctx.expr(1).accept(this);
		IExpr fbranch = (IExpr)ctx.expr(2).accept(this);
		return new IfExpr(guard, tbranch, fbranch);
	}

	@Override
	public Object visitParen_expr(Paren_exprContext ctx) {
		return ctx.expr().accept(this);
	}

	@Override 
	public Object visitBv_expr(Bv_exprContext ctx) {
		String value = ctx.getText().split("bv")[0];
		int precision = Integer.parseInt(ctx.getText().split("bv")[1]);
		return new IValue(new BigInteger(value),precision);
	}

	@Override
	public Object visitInt_expr(Int_exprContext ctx) {
		return new IValue(new BigInteger(ctx.getText()), ARCH_PRECISION);
	}
	
	@Override
	public Object visitBool_lit(Bool_litContext ctx) {
		return new BConst(Boolean.parseBoolean(ctx.getText()));
	}

	@Override
	public Object visitDec(DecContext ctx) {
        throw new ParsingException("Floats are not yet supported");
	}
	
	@Override
	public Object visitLine_comment(BoogieParser.Line_commentContext ctx) {
		String line = ctx.getText();
		line = line.substring(line.indexOf("version") + 8, line.indexOf("for"));
		logger.info("SMACK version: " + line);
		return null;
	}

	protected void addAssertion(IExpr expr) {
		Register ass = programBuilder.getOrCreateRegister(threadCount, "assert_" + assertionIndex, expr.getPrecision());
    	assertionIndex++;
    	programBuilder.addChild(threadCount, EventFactory.newLocal(ass, expr))
				.setCLine(currentLine)
				.setSourceCodeFile(sourceCodeFile)
				.addFilters(Tag.ASSERTION);
       	Label end = programBuilder.getOrCreateLabel("END_OF_T" + threadCount);
		CondJump jump = EventFactory.newJump(new Atom(ass, COpBin.NEQ, IValue.ONE), end);
		jump.addFilters(Tag.EARLYTERMINATION);
		programBuilder.addChild(threadCount, jump);
		
	}
}