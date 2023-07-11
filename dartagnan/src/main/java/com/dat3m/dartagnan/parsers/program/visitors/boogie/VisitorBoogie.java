package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.processing.ExprSimplifier;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.BoogieBaseVisitor;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.*;
import com.dat3m.dartagnan.parsers.program.boogie.Types;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.Lists;
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
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.DummyProcedures.handleDummyProcedures;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.LkmmProcedures.handleLkmmFunction;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.LlvmProcedures.handleLlvmFunction;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.PthreadsProcedures.handlePthreadsFunctions;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.StdProcedures.handleStdFunction;
import static com.dat3m.dartagnan.parsers.program.visitors.boogie.SvcompProcedures.handleSvcompFunction;

public class VisitorBoogie extends BoogieBaseVisitor<Object> {

    private static final Logger logger = LogManager.getLogger(VisitorBoogie.class);

    protected final ProgramBuilder programBuilder = ProgramBuilder.forLanguage(Program.SourceLanguage.BOOGIE);
    protected final TypeFactory types = programBuilder.getTypeFactory();
    protected final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    protected final ExprSimplifier exprSimplifier = new ExprSimplifier();

    private final Map<String, Proc_declContext> procDeclarations = new HashMap<>();
    private final Map<String, BoogieFunction> boogieFunctions = new HashMap<>();
    private final Map<String, Expression> constantsValueMap = new HashMap<>();
    private final Map<String, ConstantSymbol> constantSymbolMap = new HashMap<>();
    private final List<Function> functions = new ArrayList<>();

    private int currentFunction = 0;
    private BoogieFunctionCall currentCall = null;
    protected BeginAtomic currentBeginAtomic = null;
    private String currentReturnRegName = null;

    // We use <pairLabels> to connect labels of a "goto l1, l2" statement.
    private Label currentLabel = null;
    private final Map<Label, Label> pairLabels = new HashMap<>();

    protected Call_cmdContext atomicMode = null;

    private int assertionCounter = 0;

    private int currentLine = -1;
    private String sourceCodeFile = "";

    public VisitorBoogie() {
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

    protected Event addEvent(Event e) {
        if (currentLine != -1) {
            //TODO: We should probably make sure to reset currentLine to avoid attaching outdated information
            e.setMetadata(new SourceLocation(sourceCodeFile, currentLine));
        }
        return programBuilder.addChild(currentFunction, e);
    }

    protected Label getOrNewLabel(String name) {
        return programBuilder.getOrCreateLabel(currentFunction, name);
    }

    protected Register getRegister(String name) {
        return programBuilder.getRegister(currentFunction, name);
    }

    protected Register getOrNewRegister(String name) {
        return getOrNewRegister(name, types.getArchType());
    }

    protected Register getOrNewRegister(String name, Type type) {
        return programBuilder.getOrNewRegister(currentFunction, name, type);
    }

    protected String getFunctionNameFromCallContext(Call_cmdContext callCtx) {
        return callCtx.call_params().Define() == null ?
                callCtx.call_params().Ident(0).getText() :
                callCtx.call_params().Ident(1).getText();
    }

    // ============================================================

    @Override
    public Object visitMain(MainContext ctx) {
        visitLine_comment(ctx.line_comment(0));
        visitDeclarations(ctx);

        if (!procDeclarations.containsKey("main") || procDeclarations.get("main").impl_body() == null) {
            throw new ParsingException("Program shall have a non-empty main procedure");
        }

        for (Function func : functions) {
            currentFunction = func.getId();
            // Skip intrinsics, regardless of being user-defined
            if (func.getName().startsWith("__VERIFIER_nondet_")) {
                continue;
            }
            BoogieParser.Proc_declContext funcCtx = procDeclarations.get(func.getName());
            if (funcCtx.impl_body() != null) {
                visitProc_decl(funcCtx);
            }
        }

        return programBuilder.build();
    }

    // =========================== Declarations =================================

    private void visitDeclarations(MainContext ctx) {
        for (Func_declContext funDecContext : ctx.func_decl()) {
            registerBoogieFunction(funDecContext);
        }
        for (Const_declContext constDecContext : ctx.const_decl()) {
            registerConstants(constDecContext);
        }
        for (Axiom_declContext axiomDecContext : ctx.axiom_decl()) {
            assignConstants(axiomDecContext);
        }
        for (Var_declContext varDecContext : ctx.var_decl()) {
            visitVar_decl(varDecContext);
        }
        for (Proc_declContext procDecContext : ctx.proc_decl()) {
            registerProcedure(procDecContext);
        }

        //FIXME: Some Svcomp loop benchmarks reference declared but unassigned constants!?
        // Those should probably be non-deterministic, but we set them to zero here to match our previous semantics.
        final Expression zero = expressions.makeZero(types.getArchType());
        for (String constName : constantSymbolMap.keySet()) {
            constantsValueMap.putIfAbsent(constName, zero);
        }
    }

    public void registerBoogieFunction(Func_declContext ctx) {
        final String funcName = ctx.Ident().getText();
        boogieFunctions.put(funcName, new BoogieFunction(funcName, ctx.var_or_type(), ctx.expr()));
    }

    private boolean doIgnoreProcedure(String procName) {
        if (procName.equals("__SMACK_static_init")) {
            // This is a special function that contains static initialization code.
            // A pass will detect this function and initialize the static memory.
            return false;
        }
        // These procedures do not get declared in the program, and the body of these procedures is never parsed.
        // Calls to any of these procedures must get resolved somehow by the parser (e.g., by removing or replacing the call)
        if (procName.startsWith("SMACK") || procName.startsWith("__SMACK") || procName.startsWith("$") || procName.startsWith("llvm")
                || (procName.startsWith("__VERIFIER") && !procName.contains("__VERIFIER_atomic") && !procName.startsWith("__VERIFIER_nondet_"))
                || procName.startsWith("boogie") || procName.startsWith("corral")
                || procName.startsWith("assert") || procName.startsWith("malloc") || procName.startsWith("abort")
                || procName.startsWith("reach_error") || procName.startsWith("printf") || procName.startsWith("fopen")) {
            return true;
        }
        return false;
    }

    private void registerProcedure(Proc_declContext ctx) {
        final String procName = ctx.proc_sign().Ident().getText();
        if (procDeclarations.put(procName, ctx) != null) {
            throw new ParsingException("Procedure " + procName + " is already defined");
        }

        // ====== Create function declaration ========
        // TODO: We skip some functions for now. Ideally, we skip smack/boogie functions
        //  but still create intrinsic functions for, e.g., pthread, malloc, and __VERIFIER__XYZ etc.
        if (doIgnoreProcedure(procName)) {
            return;
        }

        final List<String> parameterNames = new ArrayList<>();
        final List<Type> parameterTypes = new ArrayList<>();

        if (ctx.proc_sign().proc_sign_in() != null) {
            final List<BoogieParser.Attr_typed_idents_whereContext> params =
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
        final Function func = programBuilder.newFunction(procName, currentFunction++, functionType, parameterNames);
        functions.add(func);
        constantsValueMap.put(func.getName(), func);
    }

    public void registerConstants(Const_declContext ctx) {
        for (ParseTree ident : ctx.typed_idents().idents().Ident()) {
            final String name = ident.getText();
            final boolean isThreadLocal = ctx.getText().contains(":treadLocal");
            final String declText = ctx.getText();
            if (declText.contains("ref;") && !procDeclarations.containsKey(name) && !doIgnoreVariable(name)) {
                int size = declText.contains(":allocSize")
                        ? Integer.parseInt(declText.split(":allocSize")[1].split("}")[0])
                        : 1;
                programBuilder.newMemoryObject(name, size).setIsThreadLocal(isThreadLocal);
            } else {
                final String typeString = ctx.typed_idents().type().getText();
                final IntegerType type = Types.parseIntegerType(typeString, types);
                constantSymbolMap.put(name, new ConstantSymbol(type, name));
            }
        }
    }

    public void assignConstants(Axiom_declContext ctx) {
        final Expression exp = (Expression) ctx.proposition().accept(this);
        if (exp instanceof Atom atom && atom.getLHS() instanceof ConstantSymbol c && atom.getOp().equals(EQ)) {
            constantsValueMap.put(c.name, atom.getRHS());
        }
    }

    @Override
    public Object visitVar_decl(Var_declContext ctx) {
        for (Attr_typed_idents_whereContext atiwC : ctx.typed_idents_wheres().attr_typed_idents_where()) {
            for (ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
                final String name = ident.getText();
                if (!doIgnoreVariable(name)) {
                    //TODO: This code never gets reached: it seems all global var declarations are
                    // Smack-specific and get skipped
                    programBuilder.newMemoryObject(name, 1);
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

        if (constantSymbolMap.containsKey(regName)) {
            throw new ParsingException("Register name" + regName + " conflicts with a global constant.");
        }
        if (programBuilder.getMemoryObject(regName) != null) {
            throw new ParsingException("Register name " + regName + " conflicts with a global variable.");
        }
        // Declare new register
        getOrNewRegister(regName, regType);

        return null;
    }

    @Override
    public Object visitProc_decl(Proc_declContext ctx) {
        final Impl_bodyContext body = ctx.impl_body();
        if (body == null) {
            throw new ParsingException(ctx.proc_sign().Ident().getText() + " cannot be handled");
        }

        pairLabels.clear();
        // Handle output parameters
        if (ctx.proc_sign().proc_sign_out() != null) {
            final VarDeclaration decl = parseVarDeclaration(
                    ctx.proc_sign().proc_sign_out().attr_typed_idents_wheres().attr_typed_idents_where(0).getText());
            currentReturnRegName = decl.varName;
            getOrNewRegister(currentReturnRegName, decl.type);
        }

        // Handle procedure-local register declarations
        for (Local_varsContext localVarContext : body.local_vars()) {
            visitLocal_vars(localVarContext);
        }
        // Handle procedure body
        visitChildren(body.stmt_list());

        return null;
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

        // Check if the function is a special one.
        if (handleDummyProcedures(this, ctx) || handlePthreadsFunctions(this, ctx) ||
                handleSvcompFunction(this, ctx) || handleStdFunction(this, ctx)
                || handleLkmmFunction(this, ctx) || handleLlvmFunction(this, ctx)) {
            return null;
        }

        final String funcName = getFunctionNameFromCallContext(ctx);
        if (!procDeclarations.containsKey(funcName)) {
            throw new ParsingException("Procedure " + funcName + " is not defined");
        }

        if (funcName.equals("$initialize")) {
            return null;
        }

        if (funcName.contains("__VERIFIER_atomic_")) {
            atomicMode = ctx;
            SvcompProcedures.__VERIFIER_atomic_begin(this);
        }

        // TODO: double check this
        // Some procedures might have an empty implementation.
        // There will be no return for them.
        final List<Expression> callArguments = new ArrayList<>();
        if (ctx.call_params().exprs() != null) {
            ctx.call_params().exprs().expr().stream()
                    .map(c -> (Expression) c.accept(this)).forEach(callArguments::add);
        }

        final Function func = functions.stream().filter(f -> f.getName().equals(funcName))
                .findFirst().orElse(null);
        if (func != null) {
            final Event funcCall;
            if (func.hasReturnValue()) {
                final Register resultReg = getRegister(ctx.call_params().Ident(0).getText());;
                funcCall = EventFactory.newValueFunctionCall(resultReg, func, callArguments);
            } else {
                funcCall = EventFactory.newVoidFunctionCall(func, callArguments);
            }
            addEvent(funcCall);
        }

        if (ctx.equals(atomicMode)) {
            atomicMode = null;
            SvcompProcedures.__VERIFIER_atomic_end(this);
        }
        return null;
    }

    @Override
    public Object visitAssign_cmd(Assign_cmdContext ctx) {
        final ExprsContext exprs = ctx.def_body().exprs();
        if (ctx.Ident().size() != 1 && exprs.expr().size() != ctx.Ident().size()) {
            throw new ParsingException("There should be one expression per variable\nor only one expression for all in " + ctx.getText());
        }

        for (int i = 0; i < ctx.Ident().size(); i++) {
            final String name = ctx.Ident(i).getText();
            final Expression value = (Expression) exprs.expr(i).accept(this);
            if (value == null || doIgnoreVariable(name)) {
                continue;
            }
            if (constantSymbolMap.containsKey(name)) {
                throw new ParsingException("Constants cannot be assigned: " + ctx.getText());
            }

            final Register register = getRegister(name);
            if (register != null) {
                final Event child;
                if (!ctx.getText().contains("$load.")) {
                    final Expression simplified = value.visit(exprSimplifier);
                    final Expression cast = expressions.makeCast(simplified, register.getType());
                    child = EventFactory.newLocal(register, cast);
                } else {
                    child = EventFactory.newLoad(register, value);
                }
                addEvent(child);
                continue;
            }

            final MemoryObject object = programBuilder.getMemoryObject(name);
            if (object != null) {
                addEvent(EventFactory.newStore(object, value));
                continue;
            }

            throw new ParsingException("Variable " + name + " is not defined");
        }
        return null;
    }

    @Override
    public Object visitReturn_cmd(Return_cmdContext ctx) {
        addEvent(EventFactory.newFunctionReturn(getRegister(currentReturnRegName)));
        return null;
    }

    @Override
    public Object visitAssume_cmd(Assume_cmdContext ctx) {
        if (ctx.getText().contains("sourceloc")) {
            // Smack attaches source information to "assume true" statements
            final String line = ctx.getText();
            sourceCodeFile = line.substring(line.indexOf('\"') + 1, line.indexOf(',') - 1);
            currentLine = Integer.parseInt(line.substring(line.indexOf(',') + 1, line.lastIndexOf(',')));
        }

        if (ctx.proposition().expr().getText().equals("true")) {
            // We can get rid of all the "assume true" statements
            return null;
        }

        final Expression cond = (Expression) ctx.proposition().expr().accept(this);
        final Expression terminationCond = expressions.makeNot(cond).visit(exprSimplifier);
        final Label pairingLabel = pairLabels.get(currentLabel);
        if (pairingLabel != null) {
            // if there is a pairing label, we jump to that (this assume belongs to a conditional jump)
            addEvent(EventFactory.newJump(terminationCond, pairingLabel));
        } else {
            // ... else, we terminate the function
            addEvent(EventFactory.newAbortIf(terminationCond));
        }
        return null;
    }

    @Override
    public Object visitLabel(LabelContext ctx) {
        currentLabel = getOrNewLabel(ctx.children.get(0).getText());
        addEvent(currentLabel);
        return null;
    }

    @Override
    public Object visitGoto_cmd(Goto_cmdContext ctx) {
        final List<ParseTree> children = ctx.idents().children;
        final Label l1 = getOrNewLabel(children.get(0).getText());
        addEvent(EventFactory.newGoto(l1));

        if (children.size() > 3) {
            throw new ParsingException("Cannot handle goto with 3 or more targets.");
        } else if (children.size() > 1) {
            // We know there are 2 labels and a comma in the middle
            final Label l2 = getOrNewLabel(children.get(2).getText());
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
        final String varName = ctx.getText();
        if (currentCall != null && currentCall.function().body() != null) {
            // we encountered a function parameter and replace it by the call argument
            // NOTE: This notion of "function" refers to Boogie functions
            return currentCall.getArgumentForParameter(ctx);
        }
        if (constantsValueMap.containsKey(varName)) {
            return constantsValueMap.get(varName);
        }
        if (constantSymbolMap.containsKey(varName)) {
            return constantSymbolMap.get(varName);
        }

        final Register register = programBuilder.functionExists(currentFunction) ? getRegister(varName) : null;
        if (register != null) {
            return register;
        }

        final MemoryObject object = programBuilder.getMemoryObject(varName);
        if (object != null) {
            return object;
        }
        throw new ParsingException("Variable " + varName + " is not defined");
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
            final Register reg = getRegister(String.format("%s(%s)", structName, idx));
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
        currentCall = currentCall.parent();  // pop currentCall from the call stack
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
        final Expression condition = expressions.makeBooleanCast(expr);
        final Register ass = programBuilder.getOrNewRegister(currentFunction, "assert_" + assertionCounter, condition.getType());
        assertionCounter++;
        final Event terminator = EventFactory.newAbortIf(expressions.makeNot(ass).visit(exprSimplifier));
        addEvent(EventFactory.newLocal(ass, condition)).addTags(Tag.ASSERTION);
        addEvent(terminator).addTags(Tag.EARLYTERMINATION);

    }

    // ========================================================================================
    // ------------------------------- Internal data structures -------------------------------
    // ========================================================================================
    private record VarDeclaration(String varName, Type type) { }

    public record BoogieFunction(String name, List<Var_or_typeContext> signature, ExprContext body) {  }

    private record BoogieFunctionCall(BoogieFunction function, List<Expression> callArguments, BoogieFunctionCall parent) {

        public BoogieFunctionCall {
            if (!(function.signature().size() == callArguments.size())) {
                throw new ParsingException("The number of arguments in the function call does not match " + function.name() + "'s signature");
            }
        }

        public Expression getArgumentForParameter(Var_exprContext paramCtx) {
            final List<String> signature = Lists.transform(function.signature(), s -> s.Ident().getText());
            final String paramName = paramCtx.getText();
            final int index = signature.indexOf(paramName);
            if (index == -1) {
                throw new ParsingException("Input " + paramName + " is not part of " + function.name() + " signature");
            }

            //TODO: I don't understand why we can go the topmost caller like this without updating the index in any way
            // I guess it is wrong and only works because functions are either not nested or just pass their arguments
            //  forward?
            BoogieFunctionCall caller = this;
            while (caller.parent != null) {
                caller = caller.parent;
            }
            return caller.callArguments.get(index);
        }
    }

    private record ConstantSymbol(Type type, String name) implements Expression {
        @Override
        public Type getType() { return type; }

        @Override
        public <T> T visit(ExpressionVisitor<T> visitor) {
            throw new ParsingException("Visiting ConstantSymbols should not happen.");
        }
    }

}