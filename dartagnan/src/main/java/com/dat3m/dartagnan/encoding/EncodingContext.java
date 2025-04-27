package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.encoding.formulas.FormulaManagerExt;
import com.dat3m.dartagnan.encoding.formulas.TypedFormula;
import com.dat3m.dartagnan.encoding.formulas.TypedValue;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.util.HashMap;
import java.util.Map;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.program.event.Tag.INIT;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

@Options
public final class EncodingContext {

    private static final Logger logger = LogManager.getLogger(EncodingContext.class);

    private final VerificationTask verificationTask;
    private final Context analysisContext;
    private final ExecutionAnalysis executionAnalysis;
    private final AliasAnalysis aliasAnalysis;
    private final RelationAnalysis relationAnalysis;
    private final FormulaManagerExt formulaManager;
    private final BooleanFormulaManager booleanFormulaManager;
    private final ExpressionEncoder exprEncoder;

    private final ExpressionFactory exprs = ExpressionFactory.getInstance();

    @Option(
            name=IDL_TO_SAT,
            description = "Use SAT-based encoding for totality and acyclicity.",
            secure = true)
    boolean useSATEncoding = false;

    @Option(name = MERGE_CF_VARS,
            description = "Merges control flow variables of events with identical control-flow behaviour.",
            secure = true)
    private boolean shouldMergeCFVars = true;

    @Option(name = USE_INTEGERS,
            description = "Data is encoded with mathematical integers instead of bitvectors.  Default: false.",
            secure = true)
    boolean useIntegers = false;

    private final Map<Event, BooleanFormula> controlFlowVariables = new HashMap<>();
    private final Map<Event, BooleanFormula> executionVariables = new HashMap<>();
    private final Map<NamedBarrier, BooleanFormula> syncVariables = new HashMap<>();

    private final Map<Event, TypedFormula<?, ?>> values = new HashMap<>();
    private final Map<Event, TypedFormula<?, ?>> results = new HashMap<>();

    // TODO: Once we have a PointerType, this needs to get updated.
    private final Map<Event, TypedFormula<?, ?>> addresses = new HashMap<>();
    private final Map<MemoryObject, TypedFormula<?, ?>> objAddress = new HashMap<>();
    private final Map<MemoryObject, TypedFormula<?, ?>> objSize = new HashMap<>();

    private EncodingContext(VerificationTask t, Context a, FormulaManager m) {
        verificationTask = checkNotNull(t);
        analysisContext = checkNotNull(a);
        a.requires(BranchEquivalence.class);
        executionAnalysis = a.requires(ExecutionAnalysis.class);
        aliasAnalysis = a.requires(AliasAnalysis.class);
        relationAnalysis = a.requires(RelationAnalysis.class);
        formulaManager = new FormulaManagerExt(m);
        booleanFormulaManager = formulaManager.getBooleanFormulaManager();
        exprEncoder = new ExpressionEncoder(this);
    }

    public static EncodingContext of(VerificationTask task, Context analysisContext, FormulaManager formulaManager) throws InvalidConfigurationException {
        EncodingContext context = new EncodingContext(task, analysisContext, formulaManager);
        task.getConfig().inject(context);
        logger.info("{}: {}", IDL_TO_SAT, context.useSATEncoding);
        logger.info("{}: {}", MERGE_CF_VARS, context.shouldMergeCFVars);
        context.initialize();
        if (logger.isInfoEnabled()) {
            logger.info("Number of encoded edges for acyclicity: {}",
                    task.getMemoryModel().getAxioms().stream()
                            .filter(Acyclicity.class::isInstance)
                            .mapToInt(a -> ((Acyclicity) a).getEncodeGraphSize(analysisContext))
                            .sum());
        }
        return context;
    }

    public boolean usesSATEncoding() {
        return useSATEncoding;
    }

    public VerificationTask getTask() {
        return verificationTask;
    }

    public Context getAnalysisContext() {
        return analysisContext;
    }

    public FormulaManagerExt getFormulaManager() {
        return formulaManager;
    }

    public BooleanFormulaManager getBooleanFormulaManager() {
        return booleanFormulaManager;
    }

    public ExpressionEncoder getExpressionEncoder() { return exprEncoder; }

    public ExpressionFactory getExpressionFactory() { return exprs; }

    // ====================================================================================
    // Utility

    // TODO: Unclear if these convenience functions are necessary.

    public Object evaluate(Formula formula, Model model) {
        return formulaManager.evaluate(formula, model);
    }

    public <TType extends Type> TypedValue<TType, ?> evaluate(TypedFormula<TType, ?> formula, Model model) {
        return exprEncoder.evaluate(formula, model);
    }

    public TypedValue<?, ?> evaluateAt(Expression expr, Event at, Model model) {
        return exprEncoder.evaluateAt(expr, at, model);
    }

    // ====================================================================================
    // Control flow

    public BooleanFormula controlFlow(Event event) {
        return controlFlowVariables.get(event);
    }

    public BooleanFormula jumpCondition(CondJump event) {
        return exprEncoder.encodeBooleanAt(event.getGuard(), event).formula();
    }

    public BooleanFormula jumpTaken(CondJump jump) {
        return booleanFormulaManager.and(execution(jump), jumpCondition(jump));
    }

    public BooleanFormula blocked(BlockingEvent barrier) {
        return booleanFormulaManager.and(controlFlow(barrier), booleanFormulaManager.not(execution(barrier)));
    }

    public BooleanFormula unblocked(BlockingEvent barrier) {
        return execution(barrier);
    }

    public BooleanFormula sync(NamedBarrier event) {
        return syncVariables.get(event);
    }

    public BooleanFormula execution(Event event) {
        return (event.cfImpliesExec() ? controlFlowVariables : executionVariables).get(event);
    }

    /**
     * Simple formula proposing the execution of two events.
     * Does not test for mutual exclusion.
     * @param first
     * Some event of a program to be encoded.
     * @param second
     * Another event of the same program.
     * @return
     * Proposition that both {@code first} and {@code second} are included in the modelled execution.
     */
    public BooleanFormula execution(Event first, Event second) {
        boolean b = first.getGlobalId() < second.getGlobalId();
        Event x = b ? first : second;
        Event y = b ? second : first;
        if (executionAnalysis.isImplied(x, y)) {
            return execution(x);
        }
        if (executionAnalysis.isImplied(y, x)) {
            return execution(y);
        }
        return booleanFormulaManager.and(execution(x), execution(y));
    }

    // ====================================================================================
    // Data flow

    public BooleanFormula sameAddress(MemoryCoreEvent first, MemoryCoreEvent second) {
        return aliasAnalysis.mustAlias(first, second)
                ? booleanFormulaManager.makeTrue()
                : exprEncoder.equals(address(first), address(second));
    }

    public BooleanFormula sameResult(RegWriter first, RegWriter second) {
        return exprEncoder.equals(result(first), result(second));
    }

    public BooleanFormula sameValue(MemoryCoreEvent first, MemoryCoreEvent second, ExpressionEncoder.ConversionMode cmode) {
        return exprEncoder.equals(value(first), value(second), cmode);
    }

    public BooleanFormula sameValue(MemoryCoreEvent first, MemoryCoreEvent second) {
        return sameValue(first, second, ExpressionEncoder.ConversionMode.NO);
    }

    public TypedFormula<?, ?> address(MemoryCoreEvent event) {
        return addresses.get(event);
    }

    public TypedFormula<?, ?> address(MemoryObject memoryObject) { return objAddress.get(memoryObject); }

    public TypedFormula<?, ?> size(MemoryObject memoryObject) {
        return objSize.get(memoryObject);
    }

    public TypedFormula<?, ?> value(MemoryCoreEvent event) {
        return values.get(event);
    }

    public TypedFormula<?, ?> result(RegWriter event) {
        return results.get(event);
    }

    // ====================================================================================
    // Relations

    public BooleanFormula dependency(Event first, Event second) {
        return booleanFormulaManager.makeVariable("idd " + first.getGlobalId() + " " + second.getGlobalId());
    }

    public IntegerFormula memoryOrderClock(Event write) {
        checkArgument(write.hasTag(WRITE), "Cannot get a clock-var for non-writes.");
        if (write.hasTag(INIT)) {
            return formulaManager.getIntegerFormulaManager().makeNumber(0);
        }
        return formulaManager.getIntegerFormulaManager().makeVariable("co " + write.getGlobalId());
    }

    public IntegerFormula clockVariable(String name, Event event) {
        return formulaManager.getIntegerFormulaManager().makeVariable(formulaManager.escape(name) + " " + event.getGlobalId());
    }

    // Careful: The semantics of this variable is currently only encoded when doing liveness checking
    //  or verifying litmus code.
    public BooleanFormula lastCoVar(Event write) {
        return booleanFormulaManager.makeVariable("co_last(" + write.getGlobalId() + ")");
    }

    public BooleanFormula edgeVariable(String name, Event first, Event second) {
        return booleanFormulaManager.makeVariable(formulaManager.escape(name) + " " + first.getGlobalId() + " " + second.getGlobalId());
    }

    @FunctionalInterface
    public interface EdgeEncoder {
        BooleanFormula encode(Event e1, Event e2);
    }

    public EdgeEncoder edge(Relation relation) {
        RelationAnalysis.Knowledge k = relationAnalysis.getKnowledge(relation);
        EventGraph may = k.getMaySet();
        EventGraph must = k.getMustSet();
        EdgeEncoder variable = relation.getDefinition().getEdgeVariableEncoder(this);
        return (e1, e2) -> {
            if (!may.contains(e1, e2)) {
                return booleanFormulaManager.makeFalse();
            }
            if (must.contains(e1, e2)) {
                return execution(e1, e2);
            }
            return variable.encode(e1, e2);
        };
    }

    public BooleanFormula edge(Relation relation, Event first, Event second) {
        return edge(relation).encode(first, second);
    }

    // ====================================================================================
    // Private implementation

    private void initialize() {
        // ------- Control flow variables -------
        // Only for the standard fair progress model we can merge CF variables.
        // TODO: It would also be possible for OBE/HSA in some cases if we refine the cf-equivalence classes
        //  to classes per thread.
        final boolean mergeCFVars = shouldMergeCFVars && verificationTask.getProgressModel().isFair();
        if (mergeCFVars) {
            for (BranchEquivalence.Class cls : analysisContext.get(BranchEquivalence.class).getAllEquivalenceClasses()) {
                BooleanFormula v = booleanFormulaManager.makeVariable("cf " + cls.getRepresentative().getGlobalId());
                for (Event e : cls) {
                    controlFlowVariables.put(e, v);
                }
            }
        } else {
            for (Event e : verificationTask.getProgram().getThreadEvents()) {
                controlFlowVariables.put(e, booleanFormulaManager.makeVariable("cf " + e.getGlobalId()));
            }
        }

        // ------- Memory object variables -------
        for (MemoryObject memoryObject : verificationTask.getProgram().getMemory().getObjects()) {
            objAddress.put(memoryObject, exprEncoder.makeVariable(String.format("addrof(%s)", memoryObject), memoryObject.getType()));
            objSize.put(memoryObject, exprEncoder.makeVariable(String.format("sizeof(%s)", memoryObject), memoryObject.getType()));
        }

        // ------- Event variables  -------
        for (Event e : verificationTask.getProgram().getThreadEvents()) {
            if (e instanceof NamedBarrier b) {
                syncVariables.put(b, booleanFormulaManager.makeVariable("sync " + e.getGlobalId()));
            }
            if (!e.cfImpliesExec()) {
                executionVariables.put(e, booleanFormulaManager.makeVariable("exec " + e.getGlobalId()));
            }
            TypedFormula<?, ?> r;
            if (e instanceof RegWriter rw) {
                Register register = rw.getResultRegister();
                String name = register.getName() + "(" + e.getGlobalId() + "_result)";
                Type type = register.getType();
                r = exprEncoder.makeVariable(name, type);
            } else {
                r = null;
            }
            if (e instanceof MemoryCoreEvent memEvent) {
                addresses.put(e, exprEncoder.encodeAt(memEvent.getAddress(), memEvent));
                if (e instanceof Load) {
                    values.put(e, r);
                } else if (e instanceof Store store) {
                    values.put(e, exprEncoder.encodeAt(store.getMemValue(), e));
                }
            }
            if (r != null) {
                results.put(e, r);
            }
        }
    }
}