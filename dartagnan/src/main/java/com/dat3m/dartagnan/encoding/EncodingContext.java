package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Acyclic;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.util.HashMap;
import java.util.Map;

import static com.dat3m.dartagnan.configuration.OptionNames.IDL_TO_SAT;
import static com.dat3m.dartagnan.configuration.OptionNames.MERGE_CF_VARS;
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

    @Option(
            name=IDL_TO_SAT,
            description = "Use SAT-based encoding for totality and acyclicity.",
            secure = true)
    boolean useSATEncoding = false;

    @Option(name = MERGE_CF_VARS,
            description = "Merges control flow variables of events with identical control-flow behaviour.",
            secure = true)
    private boolean shouldMergeCFVars = true;

    private final Map<Event, BooleanFormula> controlFlowVariables = new HashMap<>();
    private final Map<Event, BooleanFormula> executionVariables = new HashMap<>();
    private final Map<Event, Formula> addresses = new HashMap<>();
    private final Map<Event, Formula> values = new HashMap<>();
    private final Map<Event, Formula> results = new HashMap<>();

    private EncodingContext(VerificationTask t, Context a, FormulaManager m) {
        verificationTask = checkNotNull(t);
        analysisContext = checkNotNull(a);
        a.requires(BranchEquivalence.class);
        executionAnalysis = a.requires(ExecutionAnalysis.class);
        aliasAnalysis = a.requires(AliasAnalysis.class);
        relationAnalysis = a.requires(RelationAnalysis.class);
        formulaManager = m;
        booleanFormulaManager = m.getBooleanFormulaManager();
    }

    public static EncodingContext of(VerificationTask task, Context analysisContext, FormulaManager formulaManager) throws InvalidConfigurationException {
        EncodingContext context = new EncodingContext(task, analysisContext, formulaManager);
        task.getConfig().inject(context);
        logger.info("{}: {}", IDL_TO_SAT, context.useSATEncoding);
        logger.info("{}: {}", MERGE_CF_VARS, context.shouldMergeCFVars);
        context.initialize();
        if (logger.isInfoEnabled()) {
            logger.info("Number of encoded tuples for acyclicity: {}",
                    task.getMemoryModel().getAxioms().stream()
                            .filter(Acyclic.class::isInstance)
                            .mapToInt(a -> ((Acyclic) a).getEncodeTupleSetSize(analysisContext))
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

    public Formula encodeFinalExpression(Expression expression) {
        return new ExpressionEncoder(this, null).encode(expression);
    }

    public BooleanFormula encodeExpressionAsBooleanAt(Expression expression, Event event) {
        return new ExpressionEncoder(this, event).encodeAsBoolean(expression);
    }

    public Formula encodeExpressionAt(Expression expression, Event event) {
        return new ExpressionEncoder(this, event).encode(expression);
    }

    public BooleanFormula encodeComparison(COpBin op, Formula lhs, Formula rhs) {
        if (lhs instanceof BooleanFormula l && rhs instanceof BooleanFormula r) {
            return switch (op) {
                case EQ -> booleanFormulaManager.equivalence(l, r);
                case NEQ -> booleanFormulaManager.not(booleanFormulaManager.equivalence(l, r));
                default -> throw new UnsupportedOperationException(
                        String.format("Encoding of COpBin operation %s not supported on boolean formulas.", op));
            };
        }
        if (lhs instanceof IntegerFormula l && rhs instanceof IntegerFormula r) {
            IntegerFormulaManager integerFormulaManager = formulaManager.getIntegerFormulaManager();
            return switch (op) {
                case EQ -> integerFormulaManager.equal(l, r);
                case NEQ -> booleanFormulaManager.not(integerFormulaManager.equal(l, r));
                case LT, ULT -> integerFormulaManager.lessThan(l, r);
                case LTE, ULTE -> integerFormulaManager.lessOrEquals(l, r);
                case GT, UGT -> integerFormulaManager.greaterThan(l, r);
                case GTE, UGTE -> integerFormulaManager.greaterOrEquals(l, r);
            };
        }
        if (lhs instanceof BitvectorFormula l && rhs instanceof BitvectorFormula r) {
            BitvectorFormulaManager bitvectorFormulaManager = formulaManager.getBitvectorFormulaManager();
            return switch (op) {
                case EQ -> bitvectorFormulaManager.equal(l, r);
                case NEQ -> booleanFormulaManager.not(bitvectorFormulaManager.equal(l, r));
                case LT, ULT -> bitvectorFormulaManager.lessThan(l, r, op.equals(COpBin.LT));
                case LTE, ULTE -> bitvectorFormulaManager.lessOrEquals(l, r, op.equals(COpBin.LTE));
                case GT, UGT -> bitvectorFormulaManager.greaterThan(l, r, op.equals(COpBin.GT));
                case GTE, UGTE -> bitvectorFormulaManager.greaterOrEquals(l, r, op.equals(COpBin.GTE));
            };
        }
        throw new UnsupportedOperationException("Encoding not supported for COpBin: " + lhs + " " + op + " " + rhs);
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

    public BooleanFormula equal(Formula left, Formula right) {
        if (left instanceof IntegerFormula l) {
            IntegerFormulaManager integerFormulaManager = formulaManager.getIntegerFormulaManager();
            return integerFormulaManager.equal(l, toInteger(right));
        }
        if (right instanceof IntegerFormula r) {
            IntegerFormulaManager integerFormulaManager = formulaManager.getIntegerFormulaManager();
            return integerFormulaManager.equal(toInteger(left), r);
        }
        if (left instanceof BitvectorFormula l) {
            BitvectorFormulaManager bitvectorFormulaManager = formulaManager.getBitvectorFormulaManager();
            int length = bitvectorFormulaManager.getLength(l);
            return bitvectorFormulaManager.equal(l, toBitvector(right, length));
        }
        if (right instanceof BitvectorFormula r) {
            BitvectorFormulaManager bitvectorFormulaManager = formulaManager.getBitvectorFormulaManager();
            int length = bitvectorFormulaManager.getLength(r);
            return bitvectorFormulaManager.equal(toBitvector(left, length), r);
        }
        if (left instanceof BooleanFormula l && right instanceof BooleanFormula r) {
            return booleanFormulaManager.equivalence(l, r);
        }
        throw new UnsupportedOperationException(String.format("Unknown types for equal(%s,%s)", left, right));
    }

    private IntegerFormula toInteger(Formula formula) {
        if (formula instanceof IntegerFormula f) {
            return f;
        }
        if (formula instanceof BooleanFormula f) {
            IntegerFormulaManager integerFormulaManager = formulaManager.getIntegerFormulaManager();
            IntegerFormula zero = integerFormulaManager.makeNumber(0);
            IntegerFormula one = integerFormulaManager.makeNumber(1);
            return booleanFormulaManager.ifThenElse(f, one, zero);
        }
        if (formula instanceof BitvectorFormula f) {
            BitvectorFormulaManager bitvectorFormulaManager = formulaManager.getBitvectorFormulaManager();
            return bitvectorFormulaManager.toIntegerFormula(f, false);
        }
        throw new UnsupportedOperationException(String.format("Unkown type for toInteger(%s).", formula));
    }

    private BitvectorFormula toBitvector(Formula formula, int length) {
        BitvectorFormulaManager bitvectorFormulaManager = formulaManager.getBitvectorFormulaManager();
        if (formula instanceof BitvectorFormula f) {
            int formulaLength = bitvectorFormulaManager.getLength(f);
            // Signedness may be wrong here:
            return formulaLength >= length ? f : bitvectorFormulaManager.extend(f, length - formulaLength, false);
        }
        if (formula instanceof BooleanFormula f) {
            BitvectorFormula zero = bitvectorFormulaManager.makeBitvector(length, 0);
            BitvectorFormula one = bitvectorFormulaManager.makeBitvector(length, 1);
            return booleanFormulaManager.ifThenElse(f, one, zero);
        }
        throw new UnsupportedOperationException(String.format("Unknown type for toBitvector(%s,%s).", formula, length));
    }

    public BooleanFormula equalZero(Formula formula) {
        if (formula instanceof BooleanFormula f) {
            return booleanFormulaManager.not(f);
        }
        if (formula instanceof IntegerFormula f) {
            IntegerFormulaManager integerFormulaManager = formulaManager.getIntegerFormulaManager();
            return integerFormulaManager.equal(f, integerFormulaManager.makeNumber(0));
        }
        if (formula instanceof BitvectorFormula f) {
            BitvectorFormulaManager bitvectorFormulaManager = formulaManager.getBitvectorFormulaManager();
            int length = bitvectorFormulaManager.getLength(f);
            return bitvectorFormulaManager.equal(f, bitvectorFormulaManager.makeBitvector(length, 0));
        }
        throw new UnsupportedOperationException(String.format("Unknown type for equalZero(%s).", formula));
    }

    public BooleanFormula sameAddress(MemoryCoreEvent first, MemoryCoreEvent second) {
        return aliasAnalysis.mustAlias(first, second) ? booleanFormulaManager.makeTrue() : equal(address(first), address(second));
    }

    public Formula address(MemoryEvent event) {
        return addresses.get(event);
    }

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

        BooleanFormula encode(Tuple tuple);

        default BooleanFormula encode(Event first, Event second) {
            return encode(new Tuple(first, second));
        }
    }

    public EdgeEncoder edge(Relation relation) {
        RelationAnalysis.Knowledge k = relationAnalysis.getKnowledge(relation);
        EdgeEncoder variable = relation.getDefinition().getEdgeVariableEncoder(this);
        return tuple -> {
            if (!k.containsMay(tuple)) {
                return booleanFormulaManager.makeFalse();
            }
            if (k.containsMust(tuple)) {
                return execution(tuple.getFirst(), tuple.getSecond());
            }
            return variable.encode(tuple);
        };
    }

    public BooleanFormula edge(Relation relation, Tuple tuple) {
        return edge(relation).encode(tuple);
    }

    public BooleanFormula edge(Relation relation, Event first, Event second) {
        return edge(relation).encode(first, second);
    }

    private void initialize() {
        if (shouldMergeCFVars) {
            for (BranchEquivalence.Class cls : analysisContext.get(BranchEquivalence.class).getAllEquivalenceClasses()) {
                BooleanFormula v = booleanFormulaManager.makeVariable("cf " + cls.getRepresentative().getGlobalId());
                for (Event e : cls) {
                    controlFlowVariables.put(e, v);
                }
            }
        } else {
            for (Event e : verificationTask.getProgram().getEvents()) {
                controlFlowVariables.put(e, booleanFormulaManager.makeVariable("cf " + e.getGlobalId()));
            }
        }
        for (Event e : verificationTask.getProgram().getEvents()) {
            if (!e.cfImpliesExec()) {
                executionVariables.put(e, booleanFormulaManager.makeVariable("exec " + e.getGlobalId()));
            }
            Formula r;
            if (e instanceof RegWriter) {
                Register register = ((RegWriter) e).getResultRegister();
                String name = register.getName() + "(" + e.getGlobalId() + "_result)";
                Type type = register.getType();
                if (type instanceof BooleanType) {
                    r = booleanFormulaManager.makeVariable(name);
                } else if (type instanceof IntegerType integerType) {
                    if (integerType.isMathematical()) {
                        r = formulaManager.getIntegerFormulaManager().makeVariable(name);
                    } else {
                        int bitWidth = integerType.getBitWidth();
                        r = formulaManager.getBitvectorFormulaManager().makeVariable(bitWidth, name);
                    }
                } else {
                    throw new UnsupportedOperationException(String.format("Encoding result of type %s.", type));
                }
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
}