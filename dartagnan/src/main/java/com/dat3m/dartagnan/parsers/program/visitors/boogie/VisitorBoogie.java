package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.processing.ExprSimplifier;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.BoogieBaseVisitor;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.*;
import com.dat3m.dartagnan.parsers.program.boogie.*;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.tree.ParseTree;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.parsers.program.boogie.LlvmFunctions.LLVMFUNCTIONS;
import static com.dat3m.dartagnan.parsers.program.boogie.LlvmFunctions.llvmFunction;
import static com.dat3m.dartagnan.parsers.program.boogie.LlvmPredicates.LLVMPREDICATES;
import static com.dat3m.dartagnan.parsers.program.boogie.LlvmPredicates.llvmPredicate;
import static com.dat3m.dartagnan.parsers.program.boogie.LlvmUnary.LLVMUNARY;
import static com.dat3m.dartagnan.parsers.program.boogie.LlvmUnary.llvmUnary;
import static com.dat3m.dartagnan.parsers.program.boogie.SmackPredicates.SMACKPREDICATES;
import static com.dat3m.dartagnan.parsers.program.boogie.SmackPredicates.smackPredicate;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.DummyProcedures.DUMMYPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.LkmmProcedures.LKMMPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.LkmmProcedures.handleLkmmFunction;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.LlvmProcedures.LLVMPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.LlvmProcedures.handleLlvmFunction;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.PthreadsProcedures.PTHREADPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.PthreadsProcedures.handlePthreadsFunctions;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.StdProcedures.STDPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.StdProcedures.handleStdFunction;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.SvcompProcedures.SVCOMPPROCEDURES;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.SvcompProcedures.handleSvcompFunction;

public class VisitorBoogie extends BoogieBaseVisitor<Object> {

    private static final Logger logger = LogManager.getLogger(VisitorBoogie.class);

    private record VarDeclaration(String varName, Type type) { }

    protected final TypeFactory types = TypeFactory.getInstance();
    protected final ExpressionFactory expressions = ExpressionFactory.getInstance();
    protected ProgramBuilder programBuilder;
    protected int threadCount = 0;
    protected int currentThread = 0;
    private Set<String> threadLocalVariables = new HashSet<String>();

    protected int currentLine = -1;
    protected String sourceCodeFile = "";

    // We use <pairLabels> to connect labels of a "goto l1, l2" statement.
    private Label currentLabel = null;
    private final Map<Label, Label> pairLabels = new HashMap<>();

    private final Map<String, BoogieFunction> boogieFunctions = new HashMap<>();
    private BoogieFunctionCall currentCall = null;

    // Improves performance by initializing Locations rather than creating new write events
    private boolean initMode = false;

    private final Map<String, Proc_declContext> procedures = new HashMap<>();
    protected PthreadPool pool = new PthreadPool();

    private int nextScopeID = 0;
    protected Scope currentScope = new Scope(nextScopeID, null);

    private final List<Register> returnRegister = new ArrayList<>();
    private String currentReturnName = null;

    private final Map<String, Expression> constantsMap = new HashMap<>();
    private final Map<String, IntegerType> constantsTypeMap = new HashMap<>();

    protected final Set<Expression> allocations = new HashSet<>();

    protected Map<Integer, List<Expression>> threadCallingValues = new HashMap<>();

    protected int assertionIndex = 0;

    protected BeginAtomic currentBeginAtomic = null;
    protected Call_cmdContext atomicMode = null;

    private final ExprSimplifier exprSimplifier = new ExprSimplifier();


    // ----- TODO: Test code -----
    private record FunctionDeclaration(String funcName, FunctionType funcType,
                                       List<String> parameterNames, Proc_declContext ctx) { }

    protected List<FunctionDeclaration> functionDeclarations = new ArrayList<>();
    protected List<Function> functions = new ArrayList<>();
    protected boolean inlineMode = true;
    // ----- TODO: Test code end -----


    public VisitorBoogie(ProgramBuilder pb) {
        this.programBuilder = pb;
    }

    private final List<String> smackDummyVariables =
            Arrays.asList("$M.0", "$exn", "$exnv", "$CurrAddr", "$GLOBALS_BOTTOM",
                    "$EXTERNS_BOTTOM", "$MALLOC_TOP", "__SMACK_code", "__SMACK_decls", "__SMACK_top_decl",
                    "$1024.ref", "$0.ref", "$1.ref", "env_value_str", "errno_global", "$CurrAddr");

    private boolean doIgnoreVariable(String varName) {
        // We ignore some smack-generated dummy variables
        if (smackDummyVariables.contains(varName)) {
            return true;
        }
        // We also ignore all kinds of strings for now.
        if (varName.startsWith(".str")) {
            return true;
        }
        // These are special strings containing function names.
        if (varName.startsWith("__PRETTY_FUNCTION")) {
            return true;
        }
        return false;
    }

    // ==================== Utility functions ====================

    protected VarDeclaration parseVarDeclaration(String varDeclString) {
        final String[] decl = varDeclString.split(":");
        return new VarDeclaration(decl[0], Types.parseIntegerType(decl[1], types));
    }

    protected void resetScope() {
        nextScopeID = 0;
        currentScope = new Scope(nextScopeID, null);
    }

    protected void pushScope() {
        currentScope = new Scope(nextScopeID++, currentScope);
    }

    protected void popScope() {
        currentScope = currentScope.getParent();
    }

    protected String getScopedName(String name) {
        if (name == null) {
            return null;
        }
        if (!inlineMode) {
            // We don't need scoping if we do not inline.
            return name;
        }
        return currentScope.getID() + ":" + name;
    }

    protected Event addEvent(Event e) {
        if (currentLine != -1) {
            e.setMetadata(new SourceLocation(sourceCodeFile, currentLine));
        }
        return programBuilder.addChild(threadCount, e);
    }

    protected Label getOrNewLabel(String name) {
        return programBuilder.getOrCreateLabel(threadCount, name);
    }

    protected Label getOrNewScopedLabel(String name) {
        return getOrNewLabel(getScopedName(name));
    }

    protected Register getScopedRegister(String name) {
        return programBuilder.getRegister(threadCount, getScopedName(name));
    }

    protected Register getOrNewScopedRegister(String name) {
        return getOrNewScopedRegister(name, types.getArchType());
    }

    protected Register getOrNewScopedRegister(String name, Type type) {
        return programBuilder.getOrNewRegister(threadCount, getScopedName(name), type);
    }

    protected String getFunctionNameFromCallContext(Call_cmdContext callCtx) {
        return callCtx.call_params().Define() == null ?
                callCtx.call_params().Ident(0).getText() :
                callCtx.call_params().Ident(1).getText();
    }

    // ======================================== ====================

    @Override
    public Object visitMain(MainContext ctx) {
        visitLine_comment(ctx.line_comment(0));
        for (Func_declContext funDecContext : ctx.func_decl()) {
            visitFunc_decl(funDecContext);
        }
        for (Proc_declContext procDecContext : ctx.proc_decl()) {
            preProc_decl(procDecContext);
        }
        for (Const_declContext constDecContext : ctx.const_decl()) {
            visitConst_decl(constDecContext);
        }
        for (Axiom_declContext axiomDecContext : ctx.axiom_decl()) {
            visitAxiom_decl(axiomDecContext);
        }
        for (Var_declContext varDecContext : ctx.var_decl()) {
            visitVar_decl(varDecContext);
        }
        if (!procedures.containsKey("main")) {
            throw new ParsingException("Program shall have a main procedure");
        }
        
        String nextThreadName = "main";
        do {
            resetScope();
            createThreadForProcedure(procedures.get(nextThreadName),  threadCallingValues.get(threadCount));

            if (!pool.canCreate()) {
                break;
            }

            Expression next = pool.next();
            pool.addIntPtr(threadCount + 1, next);
            nextThreadName = pool.getNameFromPtr(next);
        } while (true);

        logger.info("Number of threads (including main): " + threadCount);

        // ----- TODO: Test code -----
        inlineMode = false;
        for (FunctionDeclaration decl : functionDeclarations) {
            functions.add(programBuilder.initFunction(decl.funcName, ++threadCount,decl.funcType, decl.parameterNames));
            visitProc_decl(decl.ctx(),  null);
        }
        resetScope();
        // ----- TODO: Test code end -----

        return programBuilder.build();
    }

    private void preProc_decl(Proc_declContext ctx) {
        String name = ctx.proc_sign().Ident().getText();
        if (procedures.containsKey(name)) {
            throw new ParsingException("Procedure " + name + " is already defined");
        }
        if (name.equals("main") && ctx.proc_sign().proc_sign_in() != null) {
            threadCallingValues.put(threadCount, new ArrayList<>());
            for (Attr_typed_idents_whereContext atiwC : ctx.proc_sign().proc_sign_in().attr_typed_idents_wheres().attr_typed_idents_where()) {
                final VarDeclaration decl = parseVarDeclaration(atiwC.getText());
                threadCallingValues.get(threadCount).add(getOrNewScopedRegister(decl.varName, decl.type));
            }
        }
        procedures.put(name, ctx);

        // ----- TODO: Test code -----
        // ====== Create function declaration ========
        // TODO: We skip some functions for now. Ideally, we skip smack/boogie functions
        //  but still create intrinsic functions for, e.g., pthread, malloc, and __VERIFIER__XYZ etc.
        if (name.startsWith("SMACK") || name.startsWith("$") || name.startsWith("llvm") || name.startsWith("__")
                || name.startsWith("boogie") || name.startsWith("corral") || name.startsWith("pthread")
                || name.startsWith("assert") || name.startsWith("malloc") || name.startsWith("abort")
                || name.startsWith("reach_error") || name.startsWith("printf") || name.startsWith("fopen")) {
            return;
        }
        final List<String> parameterNames = new ArrayList<>();
        final List<Type> parameterTypes = new ArrayList<>();

        if (ctx.proc_sign().proc_sign_in() != null) {
            List<BoogieParser.Attr_typed_idents_whereContext> params =
                    ctx.proc_sign().proc_sign_in().attr_typed_idents_wheres().attr_typed_idents_where();
            for (Attr_typed_idents_whereContext param : params) {
                // Parse input parameters
                final VarDeclaration decl = parseVarDeclaration(param.getText());
                parameterNames.add(decl.varName);
                parameterTypes.add(decl.type);
            }
        }
        final Type returnType;
        if (ctx.proc_sign().proc_sign_out() != null) {
            // Parse output type
            final String typeString = ctx.proc_sign().proc_sign_out().attr_typed_idents_wheres()
                    .attr_typed_idents_where(0).typed_idents_where().typed_idents().type().getText();
            returnType = Types.parseIntegerType(typeString, types);
        } else {
            returnType = types.getVoidType();
        }

        final FunctionType functionType = types.getFunctionType(returnType, parameterTypes);

        //System.out.printf("Added function %s of type %s%n", ctx.proc_sign().getText(), functionType);
        functionDeclarations.add(new FunctionDeclaration(name, functionType, parameterNames, ctx));
        // ----- TODO: Test code end -----
    }

    @Override
    public Object visitAxiom_decl(Axiom_declContext ctx) {
        Expression exp = (Expression) ctx.proposition().accept(this);
        if (exp instanceof Atom atom && atom.getLHS() instanceof Register reg && atom.getOp().equals(EQ)) {
            final String name = reg.getName();
            final Expression def = atom.getRHS();
            constantsMap.put(name, def);
        }
        return null;
    }

    @Override
    public Object visitConst_decl(Const_declContext ctx) {
        for (ParseTree ident : ctx.typed_idents().idents().Ident()) {
            final String name = ident.getText();
            if (ctx.getText().contains(":treadLocal")) {
                threadLocalVariables.add(name);
            }
            final String declText = ctx.getText();
            if (declText.contains("ref;") && !procedures.containsKey(name) && !doIgnoreVariable(name)) {
                int size = declText.contains(":allocSize")
                        ? Integer.parseInt(declText.split(":allocSize")[1].split("}")[0])
                        : 1;
                programBuilder.newObject(name, size);
            } else {
                final String typeString = ctx.typed_idents().type().getText();
                final IntegerType type = Types.parseIntegerType(typeString, types);
                constantsTypeMap.put(name, type);
            }
        }
        return null;
    }

    @Override
    public Object visitFunc_decl(Func_declContext ctx) {
        final String name = ctx.Ident().getText();
        boogieFunctions.put(name, new BoogieFunction(name, ctx.var_or_type(), ctx.expr()));
        return null;
    }

    @Override
    public Object visitVar_decl(Var_declContext ctx) {
        for (Attr_typed_idents_whereContext atiwC : ctx.typed_idents_wheres().attr_typed_idents_where()) {
            for (ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
                final String name = ident.getText();
                if (!doIgnoreVariable(name)) {
                    //TODO: This code never gets reached: it seems all global var declarations are
                    // Smack-specific and get skipped
                    programBuilder.newObject(name, 1);
                }
            }
        }
        return null;
    }

    @Override
    public Object visitLocal_vars(Local_varsContext ctx) {
        final String declString = ctx.typed_idents_wheres().attr_typed_idents_where(0).getText(); // regName:regType
        final VarDeclaration decl = parseVarDeclaration(declString);
        final String regName = decl.varName;
        final Type regType = decl.type;

        if (constantsTypeMap.containsKey(regName)) {
            throw new ParsingException("Register " + regName + " is already defined as a constant");
        }
        if (programBuilder.getObject(regName) != null) {
            throw new ParsingException("Register " + regName + " is already defined globally");
        }
        // Declare new register
        getOrNewScopedRegister(regName, regType);

        return null;
    }

    private void createThreadForProcedure(Proc_declContext ctx, List<Expression> callingValues) {
        threadCount++;
        final String procName = ctx.proc_sign().Ident().getText();
        programBuilder.initThread(procName, threadCount);
        if (threadCount != 1) {
            // Used to allow execution of threads after they have been created (pthread_create)
            final Expression pointer = pool.getPtrFromInt(threadCount);
            final Register reg = getOrNewScopedRegister(null);
            addEvent(EventFactory.Pthread.newStart(reg, pointer, pool.getMatcher(pool.getPtrFromInt(threadCount))));
        }

        // Traverse procedure body
        visitProc_decl(ctx, callingValues);

        if (threadCount != 1) {
            // Used to mark the end of the execution of a thread (used by pthread_join)
            final Expression pointer = pool.getPtrFromInt(threadCount);
            addEvent(EventFactory.Pthread.newEnd(pointer));
        }
    }

    private void visitProc_decl(Proc_declContext ctx, List<Expression> callingValues) {
        final Impl_bodyContext body = ctx.impl_body();
        if (body == null) {
            throw new ParsingException(ctx.proc_sign().Ident().getText() + " cannot be handled");
        }

        if (!inlineMode) {
            pairLabels.clear();
        }

        pushScope();

        // Handle input parameters
        if (ctx.proc_sign().proc_sign_in() != null && inlineMode) {
            final List<Attr_typed_idents_whereContext> inputParameters
                    = ctx.proc_sign().proc_sign_in().attr_typed_idents_wheres().attr_typed_idents_where();
            assert callingValues.size() == inputParameters.size();
            for (int i = 0; i < inputParameters.size(); i++) {
                final VarDeclaration decl = parseVarDeclaration(inputParameters.get(i).getText());
                final Register register = getOrNewScopedRegister(decl.varName, decl.type);
                final Expression argument = callingValues.get(i);
                addEvent(EventFactory.newLocal(register, argument));
            }
        }

        // Handle output parameters
        if (ctx.proc_sign().proc_sign_out() != null) {
            final VarDeclaration decl = parseVarDeclaration(
                    ctx.proc_sign().proc_sign_out().attr_typed_idents_wheres().attr_typed_idents_where(0).getText());
            currentReturnName = decl.varName;
            if (!inlineMode) {
                // When not inlining, we properly handle the return parameter
                getOrNewScopedRegister(currentReturnName, decl.type);
            }
        }

        // Handle procedure-local register declarations
        for (Local_varsContext localVarContext : body.local_vars()) {
            visitLocal_vars(localVarContext);
        }

        // Handle procedure body
        visitChildren(body.stmt_list());

        if (inlineMode) {
            final Label label = getOrNewLabel("END_OF_" + currentScope.getID());
            addEvent(label);
        } else {
            //TODO: Do we even need an end marker for non-inlined functions?
            final String funcName = ctx.proc_sign().Ident().getText();
            final Label label = getOrNewLabel("END_OF_" + funcName);
            addEvent(label);
        }

        popScope();

    }

    @Override
    public Object visitAssert_cmd(Assert_cmdContext ctx) {
        addAssertion((Expression) ctx.proposition().expr().accept(this));
        return null;
    }

    @Override
    public Object visitCall_cmd(Call_cmdContext ctx) {
        if (ctx.getText().contains("boogie_si_record") && !ctx.getText().contains("smack")) {
            Object local = ctx.call_params().exprs().expr(0).accept(this);
            if (local instanceof Register reg) {
                final String txt = ctx.attr(0).getText();// Shape: 'prefix{"cVar"}' or 'prefix{"...arg:cVar"}'
                final String cVarSep = txt.contains("arg:") ? "arg:" : "\"";
                final String cVar = txt.substring(txt.indexOf(cVarSep) + cVarSep.length(), txt.lastIndexOf("\""));
                reg.setCVar(cVar);
            }

        }
        final String funcName = getFunctionNameFromCallContext(ctx);
        if (funcName.equals("$initialize") && inlineMode) {
            initMode = true;
        }

        if (DUMMYPROCEDURES.stream().anyMatch(funcName::startsWith)) {
            return null;
        }
        if (PTHREADPROCEDURES.stream().anyMatch(funcName::contains)) {
            handlePthreadsFunctions(this, ctx);
            return null;
        }
        if (SVCOMPPROCEDURES.stream().anyMatch(funcName::contains)) {
            handleSvcompFunction(this, ctx);
            return null;
        }
        if (STDPROCEDURES.stream().anyMatch(funcName::startsWith)) {
            handleStdFunction(this, ctx);
            return null;
        }
        if (LKMMPROCEDURES.stream().anyMatch(funcName::equals)) {
            handleLkmmFunction(this, ctx);
            return null;
        }
        if (LLVMPROCEDURES.stream().anyMatch(funcName::equals)) {
            handleLlvmFunction(this, ctx);
            return null;
        }
        if (!procedures.containsKey(funcName)) {
            throw new ParsingException("Procedure " + funcName + " is not defined");
        }

        if (funcName.contains("__VERIFIER_atomic_")) {
            atomicMode = ctx;
            SvcompProcedures.__VERIFIER_atomic_begin(this);
        }

        // TODO: double check this
        // Some procedures might have an empty implementation.
        // There will be no return for them.
        if (ctx.call_params().Define() != null && procedures.get(funcName).impl_body() != null) {
            final Register register = getScopedRegister(ctx.call_params().Ident(0).getText());
            if (register != null) {
                returnRegister.add(register);
            }
        }

        final List<Expression> callArguments = new ArrayList<>();
        if (ctx.call_params().exprs() != null) {
            ctx.call_params().exprs().expr().stream()
                    .map(c -> (Expression) c.accept(this)).forEach(callArguments::add);
        }

        if (inlineMode) {
            addEvent(EventFactory.newFunctionCall(funcName));
            visitProc_decl(procedures.get(funcName), callArguments);
            addEvent(EventFactory.newFunctionReturn(funcName));
        } else {
            // ----- TODO: Test code -----
            final Function func = functions.stream().filter(f -> f.getName().equals(funcName))
                    .findFirst().orElse(null);
            if (func != null) {
                final Event funcCall;
                if (func.getFunctionType().getReturnType().equals(types.getVoidType())) {
                    funcCall = EventFactory.newVoidFunctionCall(func, callArguments);
                } else {
                    final Register resultReg = returnRegister.get(returnRegister.size() - 1);
                    funcCall = EventFactory.newValueFunctionCall(resultReg, func, callArguments);
                }
                addEvent(funcCall);
            } else {
                //System.out.println("Warning: skipped call to " + funcName);
            }
            // ----- TODO: Test code end -----
        }
        if (ctx.equals(atomicMode)) {
            atomicMode = null;
            SvcompProcedures.__VERIFIER_atomic_end(this);
        }
        if (funcName.equals("$initialize")) {
            initMode = false;
        }
        return null;
    }

    @Override
    public Object visitAssign_cmd(Assign_cmdContext ctx) {
        ExprsContext exprs = ctx.def_body().exprs();
        if (ctx.Ident().size() != 1 && exprs.expr().size() != ctx.Ident().size()) {
            throw new ParsingException("There should be one expression per variable\nor only one expression for all in " + ctx.getText());
        }
        for (int i = 0; i < ctx.Ident().size(); i++) {
            final String name = ctx.Ident(i).getText();
            final Expression value = (Expression) exprs.expr(i).accept(this);
            if (value == null || doIgnoreVariable(name)) {
                continue;
            }

            if (constantsTypeMap.containsKey(name)) {
                throw new ParsingException("Constants cannot be assigned: " + ctx.getText());
            }
            if (initMode) {
                programBuilder.initLocEqConst(name, value.reduce());
                continue;
            }
            final Register register = getScopedRegister(name);
            if (register != null) {
                final Event child;
                if (!ctx.getText().contains("$load.")) {
                    child = EventFactory.newLocal(register, value.visit(exprSimplifier));
                } else if (allocations.contains(value)) {
                    // These loads corresponding to pthread_joins
                    child = EventFactory.Pthread.newJoin(register, value);
                } else {
                    child = EventFactory.newLoad(register, value);
                }
                addEvent(child);
                continue;
            }

            final MemoryObject object = programBuilder.getObject(name);
            if (object != null) {
                addEvent(EventFactory.newStore(object, value));
                continue;
            }

            if (currentReturnName.equals(name)) {
                if (!returnRegister.isEmpty()) {
                    Register ret = returnRegister.remove(returnRegister.size() - 1);
                    addEvent(EventFactory.newLocal(ret, value));
                }
                continue;
            }
            throw new ParsingException("Variable " + name + " is not defined");
        }
        return null;
    }

    @Override
    public Object visitReturn_cmd(Return_cmdContext ctx) {
        if (inlineMode) {
            final Label label = getOrNewLabel("END_OF_" + currentScope.getID());
            addEvent(EventFactory.newGoto(label));
        } else {
            final Register returnReg = getScopedRegister(currentReturnName);
            addEvent(EventFactory.newFunctionReturn(returnReg));
        }
        return null;
    }

    @Override
    public Object visitAssume_cmd(Assume_cmdContext ctx) {
        if (ctx.getText().contains("sourceloc")) {
            // Smack attaches source information to "assume true" statements
            String line = ctx.getText();
            sourceCodeFile = line.substring(line.indexOf('\"') + 1, line.indexOf(',') - 1);
            currentLine = Integer.parseInt(line.substring(line.indexOf(',') + 1, line.lastIndexOf(',')));
        }

        if (ctx.proposition().expr().getText().equals("true")) {
            // We can get rid of all the "assume true" statements
            return null;
        }

        final Expression cond = (Expression) ctx.proposition().expr().accept(this);
        final Label pairingLabel = pairLabels.get(currentLabel);
        if (pairingLabel != null) {
            // if there is a pairing label, we jump to that (this assume belongs to a conditional jump)
            addEvent(EventFactory.newJumpUnless(cond, pairingLabel));
        } else if (inlineMode) {
            // if there is no pairing label, we terminate the thread (inline mode)
            final Label endOfThread = getOrNewLabel("END_OF_T" + threadCount);
            addEvent(EventFactory.newJumpUnless(cond, endOfThread));
        } else {
            // ... if we are not inlining, we instead create an abort
            addEvent(EventFactory.newAbortIf(expressions.makeNot(cond)));
        }
        return null;
    }

    @Override
    public Object visitLabel(LabelContext ctx) {
        currentLabel = getOrNewScopedLabel(ctx.children.get(0).getText());
        addEvent(currentLabel);
        return null;
    }

    @Override
    public Object visitGoto_cmd(Goto_cmdContext ctx) {
        final List<ParseTree> children = ctx.idents().children;
        final Label l1 = getOrNewScopedLabel(children.get(0).getText());
        addEvent(EventFactory.newGoto(l1));

        if (children.size() > 3) {
            throw new ParsingException("Cannot handle goto with 3 or more targets.");
        } else if (children.size() > 1) {
            // We know there are 2 labels and a comma in the middle
            final Label l2 = getOrNewScopedLabel(children.get(2).getText());
            pairLabels.put(l1, l2);
        }

        return null;
    }

    @Override
    public Object visitLogical_expr(Logical_exprContext ctx) {
        if (ctx.getText().contains("forall") || ctx.getText().contains("exists") || ctx.getText().contains("lambda")) {
            return null;
        }
        Expression v1 = (Expression) ctx.rel_expr().accept(this);
        if (ctx.and_expr() != null) {
            Expression v2 = (Expression) ctx.and_expr().accept(this);
            v1 = expressions.makeAnd(v1, v2);
        }
        if (ctx.or_expr() != null) {
            Expression v2 = (Expression) ctx.or_expr().accept(this);
            v1 = expressions.makeOr(v1, v2);
        }
        return v1;
    }

    @Override
    public Object visitMinus_expr(Minus_exprContext ctx) {
        Expression operand = (Expression) ctx.unary_expr().accept(this);
        if (!(operand.getType() instanceof IntegerType type)) {
            throw new ParsingException(String.format("Non-integer expression -%s", operand));
        }
        return expressions.makeNEG(operand, type);
    }

    @Override
    public Object visitNeg_expr(Neg_exprContext ctx) {
        Expression v = (Expression) ctx.unary_expr().accept(this);
        return expressions.makeNot(v);
    }

    @Override
    public Object visitAnd_expr(And_exprContext ctx) {
        Expression v1 = (Expression) ctx.rel_expr(0).accept(this);
        Expression v2;
        for (int i = 1; i < ctx.rel_expr().size(); i++) {
            v2 = (Expression) ctx.rel_expr(i).accept(this);
            v1 = expressions.makeAnd(v1, v2);
        }
        return v1;
    }

    @Override
    public Object visitOr_expr(Or_exprContext ctx) {
        Expression v1 = (Expression) ctx.rel_expr(0).accept(this);
        Expression v2;
        for (int i = 1; i < ctx.rel_expr().size(); i++) {
            v2 = (Expression) ctx.rel_expr(i).accept(this);
            v1 = expressions.makeOr(v1, v2);
        }
        return v1;
    }

    @Override
    public Object visitRel_expr(Rel_exprContext ctx) {
        Expression v1 = (Expression) ctx.bv_term(0).accept(this);
        Expression v2;
        for (int i = 1 ; i < ctx.bv_term().size(); i++) {
            v2 = (Expression) ctx.bv_term(i).accept(this);
            v1 = switch (ctx.rel_op(i - 1).op) {
                case EQ -> expressions.makeEQ(v1, v2);
                case NEQ -> expressions.makeNEQ(v1, v2);
                case GTE -> expressions.makeGTE(v1, v2, true);
                case LTE -> expressions.makeLTE(v1, v2, true);
                case GT -> expressions.makeGT(v1, v2, true);
                case LT -> expressions.makeLT(v1, v2, true);
                case UGTE -> expressions.makeGTE(v1, v2, false);
                case ULTE -> expressions.makeLTE(v1, v2, false);
                case UGT -> expressions.makeGT(v1, v2, false);
                case ULT -> expressions.makeLT(v1, v2, false);
            };
        }
        return v1;
    }

    @Override
    public Object visitTerm(TermContext ctx) {
        Expression v1 = (Expression) ctx.factor(0).accept(this);
        Expression v2;
        for (int i = 1; i < ctx.factor().size(); i++) {
            v2 = (Expression) ctx.factor(i).accept(this);
            v1 = expressions.makeADD(v1, v2);
        }
        return v1;
    }

    @Override
    public Object visitFactor(FactorContext ctx) {
        Expression v1 = (Expression) ctx.power(0).accept(this);
        Expression v2;
        for (int i = 1; i < ctx.power().size(); i++) {
            v2 = (Expression) ctx.power(i).accept(this);
            v1 = expressions.makeMUL(v1, v2);
        }
        return v1;
    }

    @Override
    public Object visitVar_expr(Var_exprContext ctx) {
        String name = ctx.getText();
        if (currentCall != null && currentCall.getFunction().body() != null) {
            // we encountered a function parameter and replace it by the call argument
            // NOTE: This notion of "function" refers to Boogie functions
            return currentCall.replaceParamByArgument(ctx);
        }
        if (constantsMap.containsKey(name)) {
            return constantsMap.get(name);
        }
        if (constantsTypeMap.containsKey(name)) {
            // Dummy register needed to parse axioms
            IntegerType type = constantsTypeMap.get(name);
            return new Register(name, Register.NO_FUNCTION, type);
        }

        final Register register = programBuilder.functionExists(threadCount) ? getScopedRegister(name) : null;
        if (register != null) {
            return register;
        }

        if (threadLocalVariables.contains(name)) {
            //TODO: We cannot do this for non-inlined functions, because we don't have threads yet
            return programBuilder.getOrNewObject(String.format("%s(%s)", name, threadCount));
        }

        final MemoryObject object = programBuilder.getObject(name);
        if (object != null) {
            return object;
        }
        throw new ParsingException("Variable " + name + " is not defined");
    }

    @Override
    public Object visitFun_expr(Fun_exprContext ctx) {
        //NOTE: This notion of "function" refers to Boogie functions like "add.ref" which are used
        // without the "call" keyword.
        // C-level (user-defined) functions are "procedure" in Boogie and not handled by this function.
        final String funcName = ctx.Ident().getText();
        final BoogieFunction function = boogieFunctions.get(funcName);

        if (function == null) {
            throw new ParsingException("Function " + funcName + " is not defined");
        }

        if (funcName.startsWith("$extractvalue")) {
            final String structName = ctx.expr(0).getText();
            final String idx = ctx.expr(1).getText();
            final Register reg = getScopedRegister(String.format("%s(%s)", structName, idx));
            // It is the responsibility of each LLVM instruction creating a structure to create such registers,
            // thus we use getRegister and fail if the register is not there.
            if (reg == null) {
                throw new ParsingException(String.format("Structure %s at index %s has not been initialized", structName, idx));
            }
            return reg;
        }
        if (funcName.contains("$load.")) {
            return ctx.expr(1).accept(this);
        }
        if (funcName.contains("$store.")) {
            if (doIgnoreVariable(ctx.expr(1).getText())) {
                // Stores to "ignored" variables are skipped
                return null;
            }
            final Expression address = (Expression) ctx.expr(1).accept(this);
            final Expression value = (Expression) ctx.expr(2).accept(this);
            // This improves the blow-up
            if (initMode && !(value instanceof MemoryObject)) {
                Expression lhs = address;
                int rhs = 0;
                while (lhs instanceof IExprBin expr) {
                    rhs += expr.getRHS().reduce().getValueAsInt();
                    lhs = expr.getLHS();
                }
                String text = ctx.expr(1).getText();
                final String[] split = text.split("add.ref");
                if (split.length > 1) {
                    text = split[split.length - 1];
                    text = text.substring(text.indexOf("(") + 1, text.indexOf(","));
                }
                programBuilder.getOrNewObject(text).appendInitialValue(rhs, value.reduce());
                return null;
            }
            addEvent(EventFactory.newStore(address, value));
            return null;
        }
        final List<Expression> callParams = ctx.expr().stream().map(e -> (Expression)e.accept(this)).collect(Collectors.toList());
        if (LLVMFUNCTIONS.stream().anyMatch(funcName::startsWith)) {
            return llvmFunction(funcName, callParams, expressions);
        }
        if (LLVMPREDICATES.stream().anyMatch(funcName::equals)) {
            return llvmPredicate(funcName, callParams, expressions);
        }
        if (LLVMUNARY.stream().anyMatch(funcName::startsWith)) {
            return llvmUnary(funcName, callParams, expressions);
        }
        if (SMACKPREDICATES.stream().anyMatch(funcName::equals)) {
            return smackPredicate(funcName, callParams, expressions);
        }
        // Some functions do not have a body
        if (function.body() == null) {
            throw new ParsingException("Function " + funcName + " has no implementation");
        }
        currentCall = new BoogieFunctionCall(function, callParams, currentCall); // push currentCall to the call stack
        Object ret = function.body().accept(this);
        currentCall = currentCall.getParent();  // pop currentCall from the call stack
        return ret;
    }

    @Override
    public Object visitIf_then_else_expr(If_then_else_exprContext ctx) {
        final Expression guard = (Expression) ctx.expr(0).accept(this);
        final Expression tbranch = (Expression) ctx.expr(1).accept(this);
        final Expression fbranch = (Expression) ctx.expr(2).accept(this);
        return expressions.makeConditional(guard, tbranch, fbranch);
    }

    @Override
    public Object visitParen_expr(Paren_exprContext ctx) {
        return ctx.expr().accept(this);
    }

    @Override
    public Object visitBv_expr(Bv_exprContext ctx) {
        final String value = ctx.getText().split("bv")[0];
        final int bitWidth = Integer.parseInt(ctx.getText().split("bv")[1]);
        return expressions.parseValue(value, types.getIntegerType(bitWidth));
    }

    @Override
    public Object visitInt_expr(Int_exprContext ctx) {
        return expressions.parseValue(ctx.getText(), types.getArchType());
    }

    @Override
    public Object visitBool_lit(Bool_litContext ctx) {
        return expressions.makeValue(Boolean.parseBoolean(ctx.getText()));
    }

    @Override
    public Object visitDec(DecContext ctx) {
        throw new ParsingException("Floats are not yet supported");
    }

    @Override
    public Object visitLine_comment(Line_commentContext ctx) {
        String line = ctx.getText();
        line = line.substring(line.indexOf("version") + 8, line.indexOf("for"));
        logger.info("SMACK version: " + line);
        return null;
    }

    protected void addAssertion(Expression expr) {
        final Register ass = programBuilder.getOrNewRegister(threadCount, "assert_" + assertionIndex, expr.getType());
        assertionIndex++;
        addEvent(EventFactory.newLocal(ass, expr)).addTags(Tag.ASSERTION);
        if (inlineMode) {
            final IValue one = expressions.makeOne(expr.getType());
            final Label end = getOrNewLabel("END_OF_T" + threadCount);
            final CondJump jump = EventFactory.newJump(expressions.makeNEQ(ass, one), end);
            jump.addTags(Tag.EARLYTERMINATION);
            addEvent(jump);
        } else {
            final IValue zero = expressions.makeZero(expr.getType());
            addEvent(EventFactory.newAbortIf(expressions.makeEQ(ass, zero)));
            //TODO: Check if EARLYTERMINATION tag should be added to the abort
        }

    }
}