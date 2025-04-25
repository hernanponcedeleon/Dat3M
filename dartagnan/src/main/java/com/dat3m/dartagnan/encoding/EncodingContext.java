package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.encoding.formulas.TupleFormulaManager;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
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
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
    private final FormulaManager formulaManager;
    private final BooleanFormulaManager booleanFormulaManager;
    private final TupleFormulaManager tupleFormulaManager;
    private final EncodingHelper encHelper;
    private final ExpressionEncoderNew exprEncoder;

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
    private final Map<Event, Formula> addresses = new HashMap<>();
    private final Map<Event, Formula> values = new HashMap<>();
    private final Map<Event, Formula> results = new HashMap<>();
    private final Map<MemoryObject, Formula> objAddress = new HashMap<>();
    private final Map<MemoryObject, Formula> objSize = new HashMap<>();

    private EncodingContext(VerificationTask t, Context a, FormulaManager m) {
        verificationTask = checkNotNull(t);
        analysisContext = checkNotNull(a);
        a.requires(BranchEquivalence.class);
        executionAnalysis = a.requires(ExecutionAnalysis.class);
        aliasAnalysis = a.requires(AliasAnalysis.class);
        relationAnalysis = a.requires(RelationAnalysis.class);
        formulaManager = m;
        booleanFormulaManager = m.getBooleanFormulaManager();
        tupleFormulaManager = new TupleFormulaManager(this);
        encHelper = new EncodingHelper(this);
        exprEncoder = new ExpressionEncoderNew(this);
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

    public FormulaManager getFormulaManager() {
        return formulaManager;
    }

    public BooleanFormulaManager getBooleanFormulaManager() {
        return booleanFormulaManager;
    }

    public TupleFormulaManager getTupleFormulaManager() {
        return tupleFormulaManager;
    }

    public Formula encodeFinalExpression(Expression expression) {
        return exprEncoder.encode(expression, null).formula();
    }

    public BooleanFormula encodeFinalExpressionAsBoolean(Expression expression) {
        return exprEncoder.convertToBool(exprEncoder.encode(expression, null)).formula();
    }

    public BooleanFormula encodeExpressionAsBooleanAt(Expression expression, Event event) {
        return exprEncoder.convertToBool(exprEncoder.encode(expression, event)).formula();
    }

    public Formula encodeExpressionAt(Expression expression, Event event) {
        return exprEncoder.encode(expression, event).formula();
    }

    public BooleanFormula controlFlow(Event event) {
        return controlFlowVariables.get(event);
    }

    public BooleanFormula jumpCondition(CondJump event) {
        return encodeExpressionAsBooleanAt(event.getGuard(), event);
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

    public BooleanFormula dependency(Event first, Event second) {
        return booleanFormulaManager.makeVariable("idd " + first.getGlobalId() + " " + second.getGlobalId());
    }

    public Formula lastValue(MemoryObject base, int offset, int size) {
        checkArgument(base.isInRange(offset), "Array index out of bounds");
        final String name = String.format("last_val_at_%s_%d", base, offset);
        if (useIntegers) {
            return formulaManager.getIntegerFormulaManager().makeVariable(name);
        }
        return formulaManager.getBitvectorFormulaManager().makeVariable(size, name);
    }

    public BooleanFormula equal(Formula left, Formula right, EncodingHelper.ConversionMode cMode) {
        return encHelper.equal(left, right, cMode);
    }

    public BooleanFormula equal(Formula left, Formula right) {
        return equal(left, right, EncodingHelper.ConversionMode.NO);
    }

    public BooleanFormula sameAddress(MemoryCoreEvent first, MemoryCoreEvent second) {
        return aliasAnalysis.mustAlias(first, second) ? booleanFormulaManager.makeTrue() : equal(address(first), address(second));
    }

    public BooleanFormula sameResult(RegWriter first, RegWriter second) {
        return equal(result(first), result(second));
    }

    public BooleanFormula sameValue(MemoryCoreEvent first, MemoryCoreEvent second) {
        return equal(value(first), value(second));
    }

    public Formula address(MemoryEvent event) {
        return addresses.get(event);
    }

    public Formula address(MemoryObject memoryObject) { return objAddress.get(memoryObject); }

    public Formula size(MemoryObject memoryObject) { return objSize.get(memoryObject); }

    public Formula value(MemoryEvent event) {
        return values.get(event);
    }

    public Formula result(RegWriter event) {
        return results.get(event);
    }

    public IntegerFormula clockVariable(String name, Event event) {
        return formulaManager.getIntegerFormulaManager().makeVariable(formulaManager.escape(name) + " " + event.getGlobalId());
    }

    // Careful: The semantics of this variable is currently only encoded when doing liveness checking
    //  or verifying litmus code.
    public BooleanFormula lastCoVar(Event write) {
        return booleanFormulaManager.makeVariable("co_last(" + write.getGlobalId() + ")");
    }

    public IntegerFormula memoryOrderClock(Event write) {
        checkArgument(write.hasTag(WRITE), "Cannot get a clock-var for non-writes.");
        if (write.hasTag(INIT)) {
            return formulaManager.getIntegerFormulaManager().makeNumber(0);
        }
        return formulaManager.getIntegerFormulaManager().makeVariable("co " + write.getGlobalId());
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

    public Formula makeLiteral(Type type, BigInteger value) {
        if (type instanceof BooleanType) {
            return booleanFormulaManager.makeBoolean(!value.equals(BigInteger.ZERO));
        }
        if (type instanceof IntegerType integerType) {
            if (useIntegers) {
                return formulaManager.getIntegerFormulaManager().makeNumber(value);
            } else {
                return formulaManager.getBitvectorFormulaManager().makeBitvector(integerType.getBitWidth(), value);
            }
        }
        throw new UnsupportedOperationException(String.format("Encoding variable of type %s.", type));
    }

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
            objAddress.put(memoryObject, makeVariable(String.format("addrof(%s)", memoryObject), memoryObject.getType()));
            objSize.put(memoryObject, makeVariable(String.format("sizeof(%s)", memoryObject), memoryObject.getType()));
        }

        // ------- Event variables  -------
        for (Event e : verificationTask.getProgram().getThreadEvents()) {
            if (e instanceof NamedBarrier b) {
                syncVariables.put(b, booleanFormulaManager.makeVariable("sync " + e.getGlobalId()));
            }
            if (!e.cfImpliesExec()) {
                executionVariables.put(e, booleanFormulaManager.makeVariable("exec " + e.getGlobalId()));
            }
            Formula r;
            if (e instanceof RegWriter rw) {
                Register register = rw.getResultRegister();
                String name = register.getName() + "(" + e.getGlobalId() + "_result)";
                Type type = register.getType();
                r = makeVariable(name, type);
            } else {
                r = null;
            }
            if (e instanceof MemoryCoreEvent memEvent) {
                addresses.put(e, encodeExpressionAt(memEvent.getAddress(), e));
                if (e instanceof Load) {
                    values.put(e, r);
                } else if (e instanceof Store store) {
                    values.put(e, encodeExpressionAt(store.getMemValue(), e));
                }
            }
            if (r != null) {
                results.put(e, r);
            }
        }
    }

    Formula makeVariable(String name, Type type) {
        if (type instanceof BooleanType) {
            return booleanFormulaManager.makeVariable(name);
        }
        if (type instanceof IntegerType integerType) {
            if (useIntegers) {
                return formulaManager.getIntegerFormulaManager().makeVariable(name);
            } else {
                return formulaManager.getBitvectorFormulaManager().makeVariable(integerType.getBitWidth(), name);
            }
        }
        if (type instanceof AggregateType || type instanceof ArrayType) {
            final Map<Integer, Type> primitives = TypeFactory.getInstance().decomposeIntoPrimitives(type);
            if (primitives != null) {
                final List<Formula> elements = new ArrayList<>();
                for (Map.Entry<Integer, Type> entry : primitives.entrySet()) {
                    elements.add(makeVariable(name + "@" + entry.getKey(), entry.getValue()));
                }
                return tupleFormulaManager.makeTuple(elements);
            }
        }
        throw new UnsupportedOperationException(String.format("Cannot encode variable of type %s.", type));
    }
}