package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.parsers.BoogieBaseVisitor;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.*;
import com.dat3m.dartagnan.parsers.program.boogie.Function;
import com.dat3m.dartagnan.parsers.program.boogie.FunctionCall;
import com.dat3m.dartagnan.parsers.program.boogie.PthreadPool;
import com.dat3m.dartagnan.parsers.program.boogie.Scope;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.EventIdReassignment;
import org.antlr.v4.runtime.tree.ParseTree;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.*;
import java.util.stream.Collectors;

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

    protected final Program program = new Program(Program.SourceLanguage.BOOGIE);
    protected final TypeFactory types = TypeFactory.getInstance();
    protected final ExpressionFactory expressions = ExpressionFactory.getInstance();
    protected Thread thread = program.newThread("0");
    protected final Map<String, Label> labelMap = new HashMap<>();
    protected int threadCount = 0;
    protected int currentThread = 0;
    private final Set<String> threadLocalVariables = new HashSet<>();

    protected int currentLine = -1;
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

    private final Map<String, Expression> constantsMap = new HashMap<>();
    private final Map<String, Type> constantsTypeMap = new HashMap<>();

    protected final Set<IExpr> allocations = new HashSet<>();

    protected Map<Integer, List<Expression>> threadCallingValues = new HashMap<>();

    protected int assertionIndex = 0;

    protected BeginAtomic currentBeginAtomic = null;
    protected Call_cmdContext atomicMode = null;


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

        IExpr next = thread.getOrNewRegister(currentScope.getID() + ":" + "ptrMain", types.getPointerType());
        pool.add(next, "main", -1);
        while (pool.canCreate()) {
            next = pool.next();
            String nextName = pool.getNameFromPtr(next);
            // TODO fetch id of the next thread created in the following call
            pool.addIntPtr(threadCount + 1, next);
            visitProc_decl(procedures.get(nextName), true, threadCallingValues.get(threadCount));
        }
        thread.append(labelMap.computeIfAbsent(thread.getEndLabelName(), EventFactory::newLabel));
        EventIdReassignment.newInstance().run(program);
        program.getEvents().forEach(e -> e.setOId(e.getGlobalId()));
        logger.info("Number of threads (including main): " + threadCount);

        return program;
    }

    private void preProc_decl(Proc_declContext ctx) {
        String name = ctx.proc_sign().Ident().getText();
        if (procedures.containsKey(name)) {
            throw new ParsingException("Procedure " + name + " is already defined");
        }
        if (name.equals("main") && ctx.proc_sign().proc_sign_in() != null) {
            threadCallingValues.put(threadCount, new ArrayList<>());
            for (Attr_typed_idents_whereContext atiwC : ctx.proc_sign().proc_sign_in().attr_typed_idents_wheres().attr_typed_idents_where()) {
                Type type = (Type) atiwC.typed_idents_where().typed_idents().type().accept(this);
                for (ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
                    Register register = thread.getOrNewRegister(currentScope.getID() + ":" + ident.getText(), type);
                    threadCallingValues.get(threadCount).add(register);
                }
            }
        }
        procedures.put(name, ctx);
    }

    @Override
    public Object visitAxiom_decl(Axiom_declContext ctx) {
        Expression exp = (Expression) ctx.proposition().accept(this);
        if (exp instanceof Atom && ((Atom) exp).getLHS() instanceof Register && ((Atom) exp).getOp().equals(EQ)) {
            String name = ((Register) ((Atom) exp).getLHS()).getName();
            Expression def = ((Atom) exp).getRHS();
            constantsMap.put(name, def);
        }
        return null;
    }

    @Override
    public Object visitConst_decl(Const_declContext ctx) {
        Type type = (Type) ctx.typed_idents().type().accept(this);
        for (ParseTree ident : ctx.typed_idents().idents().Ident()) {
            String name = ident.getText();
            if (ctx.getText().contains(":treadLocal")) {
                threadLocalVariables.add(name);
            }
            if (ctx.getText().contains("ref;") && !procedures.containsKey(name) && !doIgnoreVariable(name)) {
                int size = ctx.getText().contains(":allocSize")
                        ? Integer.parseInt(ctx.getText().split(":allocSize")[1].split("}")[0])
                        : 1;
                program.getMemory().newObject(name, size);
            } else {
                constantsTypeMap.put(name, type);
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
        for (Attr_typed_idents_whereContext atiwC : ctx.typed_idents_wheres().attr_typed_idents_where()) {
            for (ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
                String name = ident.getText();
                if (!doIgnoreVariable(name)) {
                    program.getMemory().newObject(name, 1);
                }
            }
        }
        return null;
    }

    public Object visitLocal_vars(Local_varsContext ctx, int scope) {
        for (Attr_typed_idents_whereContext atiwC : ctx.typed_idents_wheres().attr_typed_idents_where()) {
            Type type = (Type) atiwC.typed_idents_where().typed_idents().type().accept(this);
            for (ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
                String name = ident.getText();
                if (constantsTypeMap.containsKey(name)) {
                    throw new ParsingException("Variable " + name + " is already defined as a constant");
                }
                if (program.getMemory().getObject(name).isPresent()) {
                    throw new ParsingException("Variable " + name + " is already defined globally");
                }
                thread.getOrNewRegister(currentScope.getID() + ":" + name, type);
            }
        }
        return null;
    }

    private void visitProc_decl(Proc_declContext ctx, boolean create, List<Expression> callingValues) {
        currentLine = -1;
        if (ctx.proc_sign().proc_sign_out() != null) {
            for (Attr_typed_idents_whereContext atiwC : ctx.proc_sign().proc_sign_out().attr_typed_idents_wheres().attr_typed_idents_where()) {
                for (ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
                    currentReturnName = ident.getText();
                }
            }
        }

        if (create) {
            // finish the current thread
            thread.append(labelMap.computeIfAbsent(thread.getEndLabelName(), EventFactory::newLabel));
            labelMap.clear();
            // create the new thread
            threadCount++;
            // TODO mangle a unique thread name
            String name = ctx.proc_sign().Ident().getText();
            thread = program.newThread(name);
            if (threadCount != 1) {
                // Used to allow execution of threads after they have been created (pthread_create)
                IExpr pointer = pool.getPtrFromInt(threadCount);
                Register reg = thread.newRegister(types.getPointerType());
                thread.append(EventFactory.Pthread.newStart(reg, pointer, pool.getMatcher(pool.getPtrFromInt(threadCount))));
            }
        }

        currentScope = new Scope(nextScopeID, currentScope);
        nextScopeID++;

        Impl_bodyContext body = ctx.impl_body();
        if (body == null) {
            throw new ParsingException(ctx.proc_sign().Ident().getText() + " cannot be handled");
        }

        if (ctx.proc_sign().proc_sign_in() != null) {
            int index = 0;
            for (Attr_typed_idents_whereContext atiwC : ctx.proc_sign().proc_sign_in().attr_typed_idents_wheres().attr_typed_idents_where()) {
                Type type = (Type) atiwC.typed_idents_where().typed_idents().type().accept(this);
                for (ParseTree ident : atiwC.typed_idents_where().typed_idents().idents().Ident()) {
                    // To deal with references passed to created threads
                    if (index < callingValues.size()) {
                        Register register = thread.getOrNewRegister(currentScope.getID() + ":" + ident.getText(), type);
                        Expression value = callingValues.get(index);
                        append(EventFactory.newLocal(register, value));
                        index++;
                    }
                }
            }
        }

        for (Local_varsContext localVarContext : body.local_vars()) {
            visitLocal_vars(localVarContext, threadCount);
        }

        visitChildren(body.stmt_list());

        Label label = labelMap.computeIfAbsent("END_OF_" + currentScope.getID(), EventFactory::newLabel);
        thread.append(label);

        currentScope = currentScope.getParent();

        if (create) {
            if (threadCount != 1) {
                // Used to mark the end of the execution of a thread (used by pthread_join)
                IExpr pointer = pool.getPtrFromInt(threadCount);
                thread.append(EventFactory.Pthread.newEnd(pointer));
            }
        }
    }

    @Override
    public Object visitAssert_cmd(Assert_cmdContext ctx) {
        addAssertion((IExpr) ctx.proposition().expr().accept(this));
        return null;
    }

    @Override
    public Object visitCall_cmd(Call_cmdContext ctx) {
        if (ctx.getText().contains("boogie_si_record") && !ctx.getText().contains("smack")) {
            Object local = ctx.call_params().exprs().expr(0).accept(this);
            if (local instanceof Register) {
                String txt = ctx.attr(0).getText();
                String cVar;
                if (ctx.getText().contains("arg:")) {
                    cVar = txt.substring(txt.lastIndexOf(":") + 1, txt.lastIndexOf("\""));
                } else {
                    cVar = txt.substring(txt.indexOf("\"") + 1, txt.lastIndexOf("\""));
                }
                ((Register) local).setCVar(cVar);
            }

        }
        String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
        if (name.equals("$initialize")) {
            initMode = true;
        }
        if (name.equals("abort")) {
            Label label = labelMap.computeIfAbsent(thread.getEndLabelName(), EventFactory::newLabel);
            thread.append(EventFactory.newGoto(label));
            return null;
        }
        if (name.equals("reach_error")) {
            addAssertion(IValue.ZERO);
            return null;
        }

        if (DUMMYPROCEDURES.stream().anyMatch(name::startsWith)) {
            return null;
        }
        if (PTHREADPROCEDURES.stream().anyMatch(name::contains)) {
            handlePthreadsFunctions(this, ctx);
            return null;
        }
        if (SVCOMPPROCEDURES.stream().anyMatch(name::contains)) {
            handleSvcompFunction(this, ctx);
            return null;
        }
        if (STDPROCEDURES.stream().anyMatch(name::startsWith)) {
            handleStdFunction(this, ctx);
            return null;
        }
        if (LKMMPROCEDURES.stream().anyMatch(name::equals)) {
            handleLkmmFunction(this, ctx);
            return null;
        }
        if (LLVMPROCEDURES.stream().anyMatch(name::equals)) {
            handleLlvmFunction(this, ctx);
            return null;
        }
        if (name.contains("__VERIFIER_atomic_")) {
            atomicMode = ctx;
            SvcompProcedures.__VERIFIER_atomic_begin(this);
        }
        // TODO: double check this
        // Some procedures might have an empty implementation.
        // There will be no return for them.
        if (ctx.call_params().Define() != null && procedures.get(name).impl_body() != null) {
            thread.getRegister(currentScope.getID() + ":" + ctx.call_params().Ident(0).getText())
                    .ifPresent(returnRegister::add);
        }
        List<Expression> callingValues = new ArrayList<>();
        if (ctx.call_params().exprs() != null) {
            callingValues = ctx.call_params().exprs().expr().stream().map(c -> (Expression) c.accept(this)).collect(Collectors.toList());
        }
        if (!procedures.containsKey(name)) {
            throw new ParsingException("Procedure " + name + " is not defined");
        }
        append(EventFactory.newFunctionCall(name));

		visitProc_decl(procedures.get(name), false, callingValues);
		if(ctx.equals(atomicMode)) {
			atomicMode = null;
			SvcompProcedures.__VERIFIER_atomic_end(this);
		}
		append(EventFactory.newFunctionReturn(name));
        if (name.equals("$initialize")) {
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
            Expression value = (Expression) exprs.expr(i).accept(this);
            if (value == null) {
                continue;
            }
            String name = ctx.Ident(i).getText();
            if (doIgnoreVariable(name)) {
                continue;
            }
            if (constantsTypeMap.containsKey(name)) {
                throw new ParsingException("Constants cannot be assigned: " + ctx.getText());
            }
            if (initMode) {
                MemoryObject object = program.getMemory().getOrNewObject(name);
                object.setInitialValue(0, ((IExpr) value).reduce());
                continue;
            }
            Optional<Register> register = thread.getRegister(currentScope.getID() + ":" + name);
            if (register.isPresent()) {
                if (ctx.getText().contains("$load.")) {
                    Event child;
                    if (allocations.contains(value)) {
                        // These loads corresponding to pthread_joins
                        child = EventFactory.Pthread.newJoin(register.get(), (IExpr) value);
                    } else {
                        child = EventFactory.newLoad(register.get(), (IExpr) value, "");
                    }
                    append(child);
                    continue;
                }
                append(EventFactory.newLocal(register.get(), value));
                continue;
            }
            Optional<MemoryObject> object = program.getMemory().getObject(name);
            if (object.isPresent()) {
                // These events are eventually compiled and we need to compare its mo, thus it cannot be null
                append(EventFactory.newStore(object.get(), value, ""));
                continue;
            }
            if (currentReturnName.equals(name)) {
                if (!returnRegister.isEmpty()) {
                    Register ret = returnRegister.remove(returnRegister.size() - 1);
                    append(EventFactory.newLocal(ret, value));
                }
                continue;
            }
            throw new ParsingException("Variable " + name + " is not defined");
        }
        return null;
    }

    @Override
    public Object visitReturn_cmd(Return_cmdContext ctx) {
        Label label = labelMap.computeIfAbsent("END_OF_" + currentScope.getID(), EventFactory::newLabel);
        thread.append(EventFactory.newGoto(label));
        return null;
    }

    @Override
    public Object visitAssume_cmd(Assume_cmdContext ctx) {
        if (ctx.getText().contains("sourceloc")) {
            String line = ctx.getText();
            sourceCodeFile = line.substring(line.indexOf('\"') + 1, line.indexOf(',') - 1);
            currentLine = Integer.parseInt(line.substring(line.indexOf(',') + 1, line.lastIndexOf(',')));
        }
        // We can get rid of all the "assume true" statements
        if (!ctx.proposition().expr().getText().equals("true")) {
            Label pairingLabel;
            if (!pairLabels.containsKey(currentLabel)) {
                // If the current label doesn't have a pairing label, we jump to the end of the program
                pairingLabel = labelMap.computeIfAbsent(thread.getEndLabelName(), EventFactory::newLabel);
            } else {
                pairingLabel = pairLabels.get(currentLabel);
            }
            // Smack converts any unreachable instruction into an "assume(false)".
            // 		https://github.com/smackers/smack/blob/main/lib/smack/SmackInstGenerator.cpp#L329-L333
            // There a mismatch between this and our Assume event semantics, thus we cannot use Assume.
            // pairingLabel is guaranteed to be "END_OF_T"
            if (ctx.proposition().expr().getText().equals("false")) {
                thread.append(EventFactory.newGoto(pairingLabel));
            }
            Expression c = (Expression) ctx.proposition().expr().accept(this);
            if (c != null) {
                thread.append(EventFactory.newJump(expressions.makeUnary(NOT, c), pairingLabel));
            }
        }
        return null;
    }

    @Override
    public Object visitLabel(LabelContext ctx) {
        // Since we "inline" procedures, label names might clash
        // thus we use currentScope.getID() + ":"
        String labelName = currentScope.getID() + ":" + ctx.children.get(0).getText();
        Label label = labelMap.computeIfAbsent(labelName, EventFactory::newLabel);
        append(label);
        currentLabel = label;
        return null;
    }

    @Override
    public Object visitGoto_cmd(Goto_cmdContext ctx) {
        String labelName = currentScope.getID() + ":" + ctx.idents().children.get(0).getText();
        boolean loop = labelMap.containsKey(labelName);
        Label l1 = labelMap.computeIfAbsent(labelName, EventFactory::newLabel);
        thread.append(EventFactory.newGoto(l1));
        // If there is a loop, we return if the loop is not completely unrolled.
        // SMACK will take care of another escape if the loop is completely unrolled.
        if (loop) {
            Label label = labelMap.computeIfAbsent("END_OF_" + currentScope.getID(), EventFactory::newLabel);
            thread.append(EventFactory.newGoto(label));
        }
        if (ctx.idents().children.size() > 1) {
            for (int index = 2; index < ctx.idents().children.size(); index = index + 2) {
                labelName = currentScope.getID() + ":" + ctx.idents().children.get(index - 2).getText();
                l1 = labelMap.computeIfAbsent(labelName, EventFactory::newLabel);
                // We know there are 2 labels and a comma in the middle
                labelName = currentScope.getID() + ":" + ctx.idents().children.get(index).getText();
                Label l2 = labelMap.computeIfAbsent(labelName, EventFactory::newLabel);
                pairLabels.put(l1, l2);
            }
        }
        return null;
    }

    @Override
    public Type visitType(TypeContext ctx) {
        String typeString = ctx.getText();
        return typeString.contains("bv") ?
                types.getIntegerType(Integer.parseInt(typeString.split("bv")[1])) :
                types.getPointerType();
    }

    @Override
    public Object visitLogical_expr(Logical_exprContext ctx) {
        if (ctx.getText().contains("forall") || ctx.getText().contains("exists") || ctx.getText().contains("lambda")) {
            return null;
        }
        Expression v1 = (Expression) ctx.rel_expr().accept(this);
        if (ctx.and_expr() != null) {
            Expression v2 = (Expression) ctx.and_expr().accept(this);
            v1 = expressions.makeBinary(v1, ctx.and_op().op, v2);
        }
        if (ctx.or_expr() != null) {
            Expression v2 = (Expression) ctx.or_expr().accept(this);
            v1 = expressions.makeBinary(v1, ctx.or_op().op, v2);
        }
        return v1;
    }

    @Override
    public Object visitMinus_expr(Minus_exprContext ctx) {
        IExpr v = (IExpr) ctx.unary_expr().accept(this);
        return expressions.makeUnary(IOpUn.MINUS, v);
    }

    @Override
    public Object visitNeg_expr(Neg_exprContext ctx) {
        Expression v = (Expression) ctx.unary_expr().accept(this);
        return expressions.makeUnary(NOT, v);
    }

    @Override
    public Object visitAnd_expr(And_exprContext ctx) {
        Expression v1 = (Expression) ctx.rel_expr(0).accept(this);
        Expression v2;
        for (int i = 0; i < ctx.rel_expr().size() - 1; i++) {
            v2 = (Expression) ctx.rel_expr(i + 1).accept(this);
            v1 = expressions.makeBinary(v1, ctx.and_op(i).op, v2);
        }
        return v1;
    }

    @Override
    public Object visitOr_expr(Or_exprContext ctx) {
        Expression v1 = (Expression) ctx.rel_expr(0).accept(this);
        Expression v2;
        for (int i = 0; i < ctx.rel_expr().size() - 1; i++) {
            v2 = (Expression) ctx.rel_expr(i + 1).accept(this);
            v1 = expressions.makeBinary(v1, ctx.or_op(i).op, v2);
        }
        return v1;
    }

    @Override
    public Object visitRel_expr(Rel_exprContext ctx) {
        Expression v1 = (Expression) ctx.bv_term(0).accept(this);
        Expression v2;
        for (int i = 0; i < ctx.bv_term().size() - 1; i++) {
            v2 = (Expression) ctx.bv_term(i + 1).accept(this);
            v1 = expressions.makeBinary(v1, ctx.rel_op(i).op, v2);
        }
        return v1;
    }

    @Override
    public Object visitTerm(TermContext ctx) {
        Expression v1 = (Expression) ctx.factor(0).accept(this);
        Expression v2;
        for (int i = 0; i < ctx.factor().size() - 1; i++) {
            v2 = (Expression) ctx.factor(i + 1).accept(this);
            v1 = expressions.makeBinary((IExpr) v1, ctx.add_op(i).op, (IExpr) v2);
        }
        return v1;
    }

    @Override
    public Object visitFactor(FactorContext ctx) {
        Expression v1 = (Expression) ctx.power(0).accept(this);
        Expression v2;
        for (int i = 0; i < ctx.power().size() - 1; i++) {
            v2 = (Expression) ctx.power(i + 1).accept(this);
            v1 = expressions.makeBinary((IExpr) v1, ctx.mul_op(i).op, (IExpr) v2);
        }
        return v1;
    }

    @Override
    public Object visitVar_expr(Var_exprContext ctx) {
        String name = ctx.getText();
        if (currentCall != null && currentCall.getFunction().getBody() != null) {
            return currentCall.replaceVarsByExprs(ctx);
        }
        if (constantsMap.containsKey(name)) {
            return constantsMap.get(name);
        }
        if (constantsTypeMap.containsKey(name)) {
            // Dummy register needed to parse axioms
            return new Register(name, Register.NO_THREAD, constantsTypeMap.get(name));
        }
        Optional<Register> register = thread.getRegister(currentScope.getID() + ":" + name);
        if (register.isPresent()) {
            return register.get();
        }
        if (threadLocalVariables.contains(name)) {
            return program.getMemory().getOrNewObject(String.format("%s(%s)", name, threadCount));
        }
        return program.getMemory().getObject(name).orElseThrow();
    }

    @Override
    public Object visitFun_expr(Fun_exprContext ctx) {
        String name = ctx.Ident().getText();
        Function function = functions.get(name);
        if (function == null) {
            throw new ParsingException("Function " + name + " is not defined");
        }
        if (name.startsWith("$extractvalue")) {
            String structName = ctx.expr(0).getText();
            String idx = ctx.expr(1).getText();
            // It is the responsibility of each LLVM instruction creating a structure to create such registers,
            // thus we use getRegister and fail if the register is not there.
            return thread.getRegister(String.format("%s:%s(%s)", currentScope.getID(), structName, idx)).orElseThrow();
        }
        if (name.contains("$load.")) {
            return ctx.expr(1).accept(this);
        }
        if (name.contains("$store.")) {
            if (doIgnoreVariable(ctx.expr(1).getText())) {
                return null;
            }
            IExpr address = (IExpr) ctx.expr(1).accept(this);
            IExpr value = (IExpr) ctx.expr(2).accept(this);
            // This improves the blow-up
            if (initMode && !(value instanceof MemoryObject)) {
                Expression lhs = address;
                int rhs = 0;
                while (lhs instanceof IExprBin) {
                    rhs += ((IExprBin) lhs).getRHS().reduce().getValueAsInt();
                    lhs = ((IExprBin) lhs).getLHS();
                }
                String text = ctx.expr(1).getText();
                String[] split = text.split("add.ref");
                if (split.length > 1) {
                    text = split[split.length - 1];
                    text = text.substring(text.indexOf("(") + 1, text.indexOf(","));
                }
                program.getMemory().getOrNewObject(text).appendInitialValue(rhs, value.reduce());
                return null;
            }
            append(EventFactory.newStore(address, value, ""));
            return null;
        }
        // push currentCall to the call stack
        List<Object> callParams = ctx.expr().stream().map(e -> e.accept(this)).collect(Collectors.toList());
        currentCall = new FunctionCall(function, callParams, currentCall);
        if (LLVMFUNCTIONS.stream().anyMatch(name::startsWith)) {
            currentCall = currentCall.getParent();
            return llvmFunction(name, callParams, expressions);
        }
        if (LLVMPREDICATES.stream().anyMatch(name::equals)) {
            currentCall = currentCall.getParent();
            return llvmPredicate(name, callParams, expressions);
        }
        if (LLVMUNARY.stream().anyMatch(name::startsWith)) {
            currentCall = currentCall.getParent();
            return llvmUnary(name, callParams, expressions);
        }
        if (SMACKPREDICATES.stream().anyMatch(name::equals)) {
            currentCall = currentCall.getParent();
            return smackPredicate(name, callParams, expressions);
        }
        // Some functions do not have a body
        if (function.getBody() == null) {
            throw new ParsingException("Function " + name + " has no implementation");
        }
        Object ret = function.getBody().accept(this);
        // pop currentCall from the call stack
        currentCall = currentCall.getParent();
        return ret;
    }

    @Override
    public Object visitIf_then_else_expr(If_then_else_exprContext ctx) {
        Expression guard = (Expression) ctx.expr(0).accept(this);
        IExpr tbranch = (IExpr) ctx.expr(1).accept(this);
        IExpr fbranch = (IExpr) ctx.expr(2).accept(this);
        return expressions.makeConditional(guard, tbranch, fbranch);
    }

    @Override
    public Object visitParen_expr(Paren_exprContext ctx) {
        return ctx.expr().accept(this);
    }

    @Override
    public Object visitBv_expr(Bv_exprContext ctx) {
        String value = ctx.getText().split("bv")[0];
        int bitWidth = Integer.parseInt(ctx.getText().split("bv")[1]);
        Type type = types.getIntegerType(bitWidth);
        return expressions.parseValue(value, type);
    }

    @Override
    public Object visitInt_expr(Int_exprContext ctx) {
        return expressions.parseValue(ctx.getText(), types.getPointerType());
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
    public Object visitLine_comment(BoogieParser.Line_commentContext ctx) {
        String line = ctx.getText();
        line = line.substring(line.indexOf("version") + 8, line.indexOf("for"));
        logger.info("SMACK version: " + line);
        return null;
    }

    protected void addAssertion(IExpr expr) {
        Register ass = thread.getOrNewRegister("assert_" + assertionIndex, expr.getType());
        IValue one = expressions.makeOne(expr.getType());
        assertionIndex++;
        Event local = EventFactory.newLocal(ass, expr);
        append(local);
        local.addFilters(Tag.ASSERTION);
        Label end = labelMap.computeIfAbsent(thread.getEndLabelName(), EventFactory::newLabel);
        CondJump jump = EventFactory.newJump(expressions.makeBinary(ass, COpBin.NEQ, one), end);
        jump.addFilters(Tag.EARLYTERMINATION);
        thread.append(jump);

    }

    protected void append(Event event) {
        thread.append(event);
        event.setCFileInformation(currentLine, sourceCodeFile);
    }
}