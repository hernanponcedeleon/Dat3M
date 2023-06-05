package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemEvent;
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

    public Formula encodeFinalIntegerExpression(ExprInterface expression) {
        return new ExpressionEncoder(formulaManager, null).encodeAsInteger(expression);
    }

    public BooleanFormula encodeBooleanExpressionAt(ExprInterface expression, Event event) {
        return new ExpressionEncoder(formulaManager, event).encodeAsBoolean(expression);
    }

    public Formula encodeIntegerExpressionAt(ExprInterface expression, Event event) {
        return new ExpressionEncoder(formulaManager, event).encodeAsInteger(expression);
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
        checkArgument(left instanceof NumeralFormula.IntegerFormula || left instanceof BitvectorFormula,
                "generalEqual inputs must be IntegerFormula or BitvectorFormula");
        if (left instanceof NumeralFormula.IntegerFormula && right instanceof NumeralFormula.IntegerFormula) {
            return formulaManager.getIntegerFormulaManager().equal((NumeralFormula.IntegerFormula) left, (NumeralFormula.IntegerFormula) right);
        }
        if (left instanceof BitvectorFormula && right instanceof BitvectorFormula) {
            return formulaManager.getBitvectorFormulaManager().equal((BitvectorFormula) left, (BitvectorFormula) right);
        }
        // Fallback
        return formulaManager.getIntegerFormulaManager().equal(convertToIntegerFormula(left), convertToIntegerFormula(right));
    }

    public BooleanFormula equalZero(Formula formula) {
        checkArgument(formula instanceof NumeralFormula.IntegerFormula || formula instanceof BitvectorFormula,
                "generalEqualZero input must be IntegerFormula or BitvectorFormula");
        if (formula instanceof NumeralFormula.IntegerFormula) {
            IntegerFormulaManager imgr = formulaManager.getIntegerFormulaManager();
            return imgr.equal((NumeralFormula.IntegerFormula) formula, imgr.makeNumber(0));
        } else {
            BitvectorFormulaManager bvmgr = formulaManager.getBitvectorFormulaManager();
            return bvmgr.equal((BitvectorFormula) formula, bvmgr.makeBitvector(bvmgr.getLength((BitvectorFormula) formula), 0));
        }
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
                if (type instanceof IntegerType integerType) {
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
            if (e instanceof MemEvent) {
                addresses.put(e, encodeIntegerExpressionAt(((MemEvent) e).getAddress(), e));
                values.put(e, e instanceof Load ? r : encodeIntegerExpressionAt(((MemEvent) e).getMemValue(), e));
            }
            if (r != null) {
                results.put(e, r);
            }
        }
    }

    private NumeralFormula.IntegerFormula convertToIntegerFormula(Formula f) {
        return f instanceof BitvectorFormula ?
                formulaManager.getBitvectorFormulaManager().toIntegerFormula((BitvectorFormula) f, false) :
                (NumeralFormula.IntegerFormula) f;
    }
}