package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.encoding.formulas.TupleFormula;
import com.dat3m.dartagnan.encoding.formulas.TupleFormulaManager;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.Store;
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
        return new ExpressionEncoder(this, null).encode(expression);
    }

    public BooleanFormula encodeFinalExpressionAsBoolean(Expression expression) {
        return new ExpressionEncoder(this, null).encodeAsBoolean(expression);
    }

    public BooleanFormula encodeExpressionAsBooleanAt(Expression expression, Event event) {
        return new ExpressionEncoder(this, event).encodeAsBoolean(expression);
    }

    public Formula encodeExpressionAt(Expression expression, Event event) {
        return new ExpressionEncoder(this, event).encode(expression);
    }

    public BooleanFormula encodeComparison(IntCmpOp op, Formula lhs, Formula rhs) {
        if (lhs instanceof BooleanFormula l && rhs instanceof BooleanFormula r) {
            BooleanFormulaManager bmgr = booleanFormulaManager;
            return switch (op) {
                case EQ -> bmgr.equivalence(l, r);
                case NEQ -> bmgr.not(bmgr.equivalence(l, r));
                default -> throw new UnsupportedOperationException(
                        String.format("Encoding of IntCmpOp operation %s not supported on boolean formulas.", op));
            };
        }
        if (lhs instanceof IntegerFormula l && rhs instanceof IntegerFormula r) {
            IntegerFormulaManager imgr = formulaManager.getIntegerFormulaManager();
            return switch (op) {
                case EQ -> imgr.equal(l, r);
                case NEQ -> booleanFormulaManager.not(imgr.equal(l, r));
                case LT, ULT -> imgr.lessThan(l, r);
                case LTE, ULTE -> imgr.lessOrEquals(l, r);
                case GT, UGT -> imgr.greaterThan(l, r);
                case GTE, UGTE -> imgr.greaterOrEquals(l, r);
            };
        }
        if (lhs instanceof BitvectorFormula l && rhs instanceof BitvectorFormula r) {
            BitvectorFormulaManager bvmgr = formulaManager.getBitvectorFormulaManager();
            return switch (op) {
                case EQ -> bvmgr.equal(l, r);
                case NEQ -> booleanFormulaManager.not(bvmgr.equal(l, r));
                case LT, ULT -> bvmgr.lessThan(l, r, op.equals(IntCmpOp.LT));
                case LTE, ULTE -> bvmgr.lessOrEquals(l, r, op.equals(IntCmpOp.LTE));
                case GT, UGT -> bvmgr.greaterThan(l, r, op.equals(IntCmpOp.GT));
                case GTE, UGTE -> bvmgr.greaterOrEquals(l, r, op.equals(IntCmpOp.GTE));
            };
        }
        throw new UnsupportedOperationException("Encoding not supported for IntCmpOp: " + lhs + " " + op + " " + rhs);
    }

    public BooleanFormula controlFlow(Event event) {
        return controlFlowVariables.get(event);
    }

    public BooleanFormula jumpCondition(CondJump event) {
        return encodeExpressionAsBooleanAt(event.getGuard(), event);
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

    public BooleanFormula equal(Formula left, Formula right) {
        //FIXME: We should avoid the automatic conversion, or standardize what conversion we expect.
        // For example, when encoding rf(w, r), we always want to convert the store value type to the read value type
        // for otherwise, we might get an under-constrained value for val(r) (e.g., its upper bits might be unconstrained,
        // if we truncate it to smaller size of the store value).
        if (left instanceof IntegerFormula l) {
            IntegerFormulaManager imgr = formulaManager.getIntegerFormulaManager();
            return imgr.equal(l, toInteger(right));
        }
        if (right instanceof IntegerFormula r) {
            IntegerFormulaManager imgr = formulaManager.getIntegerFormulaManager();
            return imgr.equal(toInteger(left), r);
        }
        if (left instanceof BitvectorFormula l) {
            BitvectorFormulaManager bvmgr = formulaManager.getBitvectorFormulaManager();
            return bvmgr.equal(l, toBitvector(right, bvmgr.getLength(l)));
        }
        if (right instanceof BitvectorFormula r) {
            BitvectorFormulaManager bvmgr = formulaManager.getBitvectorFormulaManager();
            return bvmgr.equal(toBitvector(left, bvmgr.getLength(r)), r);
        }
        if (left instanceof BooleanFormula l && right instanceof BooleanFormula r) {
            return booleanFormulaManager.equivalence(l, r);
        }
        if (left instanceof TupleFormula l && right instanceof TupleFormula r) {
            return tupleFormulaManager.equal(l, r);
        }
        throw new UnsupportedOperationException(String.format("Unknown types for equal(%s,%s)", left, right));
    }

    private IntegerFormula toInteger(Formula formula) {
        if (formula instanceof IntegerFormula f) {
            return f;
        }
        if (formula instanceof BooleanFormula f) {
            IntegerFormulaManager imgr = formulaManager.getIntegerFormulaManager();
            IntegerFormula zero = imgr.makeNumber(0);
            IntegerFormula one = imgr.makeNumber(1);
            return booleanFormulaManager.ifThenElse(f, one, zero);
        }
        if (formula instanceof BitvectorFormula f) {
            return formulaManager.getBitvectorFormulaManager().toIntegerFormula(f, false);
        }
        throw new UnsupportedOperationException(String.format("Unknown type for toInteger(%s).", formula));
    }

    private BitvectorFormula toBitvector(Formula formula, int length) {
        BitvectorFormulaManager bvmgr = formulaManager.getBitvectorFormulaManager();
        if (formula instanceof BitvectorFormula f) {
            int formulaLength = bvmgr.getLength(f);
            // FIXME: Signedness may be wrong here.
            return formulaLength >= length ?
                    bvmgr.extract(f, length - 1, 0)
                    : bvmgr.extend(f, length - formulaLength, false);
        }
        if (formula instanceof BooleanFormula f) {
            BitvectorFormula zero = bvmgr.makeBitvector(length, 0);
            BitvectorFormula one = bvmgr.makeBitvector(length, 1);
            return booleanFormulaManager.ifThenElse(f, one, zero);
        }
        throw new UnsupportedOperationException(String.format("Unknown type for toBitvector(%s,%s).", formula, length));
    }

    public BooleanFormula equalZero(Formula formula) {
        if (formula instanceof BooleanFormula f) {
            return booleanFormulaManager.not(f);
        }
        if (formula instanceof IntegerFormula f) {
            IntegerFormulaManager imgr = formulaManager.getIntegerFormulaManager();
            return imgr.equal(f, imgr.makeNumber(0));
        }
        if (formula instanceof BitvectorFormula f) {
            BitvectorFormulaManager bvmgr = formulaManager.getBitvectorFormulaManager();
            return bvmgr.equal(f, bvmgr.makeBitvector(bvmgr.getLength(f), 0));
        }
        throw new UnsupportedOperationException(String.format("Unknown type for equalZero(%s).", formula));
    }

    public BooleanFormula sameAddress(MemoryCoreEvent first, MemoryCoreEvent second) {
        return aliasAnalysis.mustAlias(first, second) ? booleanFormulaManager.makeTrue() : equal(address(first), address(second));
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
        final boolean mergeCFVars = shouldMergeCFVars && verificationTask.getProgressModel() == ProgressModel.FAIR;
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
        if (type instanceof AggregateType) {
            final Map<Integer, Type> primitives = TypeFactory.getInstance().decomposeIntoPrimitives(type);
            final List<Formula> elements = new ArrayList<>();
            for (Type eleType : primitives.values()) {
                elements.add(makeVariable(name + "@" + elements.size(), eleType));
            }
            return tupleFormulaManager.makeTuple(elements);
        }
        throw new UnsupportedOperationException(String.format("Cannot encode variable of type %s.", type));
    }
}