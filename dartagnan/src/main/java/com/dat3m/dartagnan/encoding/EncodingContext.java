package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.expression.type.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Acyclic;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.IntegerOption;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;

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

    @Option(name = PRECISION,
            description = "Encode all integer expressions to a certain bit width.  Use 0 for unbounded integers.",
            secure = true)
    @IntegerOption(min = -1)
    private int precision = -1;

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
        logger.info("{}: {}", PRECISION, context.precision);
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

    public Formula encodeFinalIntegerExpression(Expression expression) {
        return new ExpressionEncoder(this, null).encodeAsInteger(expression);
    }

    public BooleanFormula encodeBooleanExpressionAt(Expression expression, Event event) {
        return new ExpressionEncoder(this, event).encodeAsBoolean(expression);
    }

    public Formula encodeIntegerExpressionAt(Expression expression, Event event) {
        return new ExpressionEncoder(this, event).encodeAsInteger(expression);
    }

    public BooleanFormula encodeComparison(COpBin op, Formula lhs, Formula rhs) {
        return ExpressionEncoder.encodeComparison(op, lhs, rhs, formulaManager);
    }

    public BooleanFormula controlFlow(Event event) {
        return controlFlowVariables.get(event);
    }

    public BooleanFormula jumpCondition(CondJump event) {
        return encodeBooleanExpressionAt(event.getGuard(), event);
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
        checkFormulaType(left);
        checkFormulaType(right);
        boolean castLeft;
        if (left instanceof NumeralFormula.IntegerFormula) {
            castLeft = false;
        } else if (right instanceof NumeralFormula.IntegerFormula) {
            castLeft = true;
        } else if (left instanceof BooleanFormula) {
            castLeft = true;
        } else if (right instanceof BooleanFormula) {
            castLeft = false;
        } else {
            assert left instanceof BitvectorFormula && right instanceof BitvectorFormula;
            BitvectorFormulaManager bitvectorFormulaManager = formulaManager.getBitvectorFormulaManager();
            int lLength = bitvectorFormulaManager.getLength((BitvectorFormula) left);
            int rLength = bitvectorFormulaManager.getLength((BitvectorFormula) right);
            castLeft = lLength < rLength;
        }
        FormulaType<?> formulaType = formulaManager.getFormulaType(castLeft ? right : left);
        Formula lhs = castFormula(formulaType, left, false);
        Formula rhs = castFormula(formulaType, right, false);
        if (formulaType.isIntegerType()) {
            IntegerFormulaManager integerFormulaManager = formulaManager.getIntegerFormulaManager();
            return integerFormulaManager.equal((NumeralFormula.IntegerFormula) lhs, (NumeralFormula.IntegerFormula) rhs);
        }
        if (formulaType.isBitvectorType()) {
            BitvectorFormulaManager bitvectorFormulaManager = formulaManager.getBitvectorFormulaManager();
            return bitvectorFormulaManager.equal((BitvectorFormula) lhs, (BitvectorFormula) rhs);
        }
        assert formulaType.isBooleanType();
        return booleanFormulaManager.equivalence((BooleanFormula) lhs, (BooleanFormula) rhs);
    }

    public BooleanFormula equalZero(Formula formula) {
        checkFormulaType(formula);
        return equalZero(formula, false);
    }

    private void checkFormulaType(Formula formula) {
        checkArgument(formula instanceof NumeralFormula.IntegerFormula ||
                formula instanceof BitvectorFormula ||
                formula instanceof BooleanFormula,
                "Unsupported formula type of %s.",
                formula);
    }

    public BooleanFormula sameAddress(MemEvent first, MemEvent second) {
        return aliasAnalysis.mustAlias(first, second) ? booleanFormulaManager.makeTrue() : equal(address(first), address(second));
    }

    public Formula address(MemEvent event) {
        return addresses.get(event);
    }

    public Formula value(MemEvent event) {
        return values.get(event);
    }

    public Formula result(RegWriter event) {
        return results.get(event);
    }

    public NumeralFormula.IntegerFormula clockVariable(String name, Event event) {
        return formulaManager.getIntegerFormulaManager().makeVariable(formulaManager.escape(name) + " " + event.getGlobalId());
    }

    public NumeralFormula.IntegerFormula memoryOrderClock(Event write) {
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

    FormulaType<?> getFormulaType(Type type) {
        if (type instanceof BooleanType || type instanceof BoundedIntegerType bounded && bounded.getBitWidth() == 1) {
            return FormulaType.BooleanType;
        }
        if (precision < 0) {
            if (type instanceof PointerType) {
                int archPrecision = GlobalSettings.getArchPrecision();
                return archPrecision < 0 ? FormulaType.IntegerType : FormulaType.getBitvectorTypeWithSize(archPrecision);
            }
            if (type instanceof BoundedIntegerType boundedType) {
                return FormulaType.getBitvectorTypeWithSize(boundedType.getBitWidth());
            }
            assert type instanceof UnboundedIntegerType;
            return FormulaType.IntegerType;
        }
        if (precision == 0) {
            return FormulaType.IntegerType;
        }
        // 1 -> BooleanType insufficient for addresses.
        return FormulaType.getBitvectorTypeWithSize(precision);
    }

    Formula getLastMemValueExpr(MemoryObject object, int offset) {
        checkArgument(0 <= offset && offset < object.size(), "array index out of bounds");
        String name = String.format("last_val_at_%s_%d", object, offset);
        //TODO Use an analysis to infer which type should be used here.
        int length = precision > -1 ? precision : GlobalSettings.getArchPrecision();
        if (length > -1) {
            return formulaManager.getBitvectorFormulaManager().makeVariable(length, name);
        } else {
            return formulaManager.getIntegerFormulaManager().makeVariable(name);
        }
    }

    Formula castFormula(FormulaType<?> formulaType, Formula inner, boolean signed) {
        if (formulaType.isIntegerType()) {
            if (inner instanceof BooleanFormula condition) {
                IntegerFormulaManager integerFormulaManager = formulaManager.getIntegerFormulaManager();
                NumeralFormula.IntegerFormula one = integerFormulaManager.makeNumber(1);
                NumeralFormula.IntegerFormula zero = integerFormulaManager.makeNumber(0);
                return booleanFormulaManager.ifThenElse(condition, one, zero);
            }
            if (inner instanceof BitvectorFormula number) {
                return formulaManager.getBitvectorFormulaManager().toIntegerFormula(number, signed);
            }
            assert inner instanceof NumeralFormula.IntegerFormula;
            return inner;
        }
        if (formulaType instanceof FormulaType.BitvectorType bitvectorType) {
            int bitWidth = bitvectorType.getSize();
            BitvectorFormulaManager bitvectorFormulaManager = formulaManager.getBitvectorFormulaManager();
            if (inner instanceof BooleanFormula condition) {
                BitvectorFormula one = bitvectorFormulaManager.makeBitvector(bitWidth, 1);
                BitvectorFormula zero = bitvectorFormulaManager.makeBitvector(bitWidth, 0);
                return booleanFormulaManager.ifThenElse(condition, one, zero);
            }
            if (inner instanceof BitvectorFormula bitvector) {
                int innerBitWidth = bitvectorFormulaManager.getLength(bitvector);
                if (innerBitWidth == bitWidth) {
                    return bitvector;
                }
                if (innerBitWidth < bitWidth) {
                    return bitvectorFormulaManager.extend(bitvector, bitWidth - innerBitWidth, signed);
                }
                return bitvectorFormulaManager.extract(bitvector, bitWidth-1, 0);
            }
            assert inner instanceof NumeralFormula.IntegerFormula;
            return bitvectorFormulaManager.makeBitvector(bitWidth, (NumeralFormula.IntegerFormula) inner);
        }
        assert formulaType.isBooleanType();
        return equalZero(inner, true);
    }

    BooleanFormula equalZero(Formula formula, boolean negate) {
        if (formula instanceof NumeralFormula.IntegerFormula integer) {
            IntegerFormulaManager integerFormulaManager = formulaManager.getIntegerFormulaManager();
            NumeralFormula.IntegerFormula zero = integerFormulaManager.makeNumber(0);
            BooleanFormula equality = integerFormulaManager.equal(integer, zero);
            return negate ? booleanFormulaManager.not(equality) : equality;
        }
        if (formula instanceof BitvectorFormula bitvector) {
            BitvectorFormulaManager bitvectorFormulaManager = formulaManager.getBitvectorFormulaManager();
            int length = bitvectorFormulaManager.getLength(bitvector);
            BitvectorFormula zero = bitvectorFormulaManager.makeBitvector(length, 0);
            BooleanFormula equality = bitvectorFormulaManager.equal(bitvector, zero);
            return negate ? booleanFormulaManager.not(equality) : equality;
        }
        assert formula instanceof BooleanFormula;
        BooleanFormula difference = (BooleanFormula) formula;
        return negate ? difference : booleanFormulaManager.not(difference);
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
                FormulaType<?> formulaType = getFormulaType(register.getType());
                r = formulaManager.makeVariable(formulaType, name);
            } else {
                r = null;
            }
            if (e instanceof MemEvent) {
                addresses.put(e, encodeIntegerExpressionAt(((MemEvent) e).getAddress(), e));
                values.put(e, e instanceof Load ? r : encodeIntegerExpressionAt(((MemEvent) e).getMemValue(), e));
            }
            if (r != null) {
                results.put(e, r);
            }
        }
    }
}