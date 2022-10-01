package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;

import static com.dat3m.dartagnan.configuration.OptionNames.IDL_TO_SAT;
import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.expression.utils.Utils.generalEqualZero;
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
    private final SolverContext solverContext;
    private final FormulaManager formulaManager;
    private final BooleanFormulaManager booleanFormulaManager;

    @Option(
            name=IDL_TO_SAT,
            description = "Use SAT-based encoding for totality and acyclicity.",
            secure = true)
    boolean useSATEncoding = false;

    private EncodingContext(VerificationTask t, Context a, SolverContext s) {
        verificationTask = checkNotNull(t);
        analysisContext = a;
        executionAnalysis = a.requires(ExecutionAnalysis.class);
        aliasAnalysis = a.requires(AliasAnalysis.class);
        solverContext = s;
        formulaManager = s.getFormulaManager();
        booleanFormulaManager = formulaManager.getBooleanFormulaManager();
    }

    public static EncodingContext of(VerificationTask task, Context analysisContext, SolverContext solverContext) throws InvalidConfigurationException {
        EncodingContext context = new EncodingContext(task, analysisContext, solverContext);
        task.getConfig().inject(context);
        logger.info("{}: {}", IDL_TO_SAT, context.useSATEncoding);
        return context;
    }

    public boolean usesSATEncoding() {
        return useSATEncoding;
    }

    public VerificationTask task() {
        return verificationTask;
    }

    public Context analysisContext() {
        return analysisContext;
    }

    public SolverContext solverContext() {
        return solverContext;
    }

    public FormulaManager getFormulaManager() {
        return formulaManager;
    }

    public BooleanFormula controlFlow(Event event) {
        return event.cf();
    }

    public BooleanFormula jumpCondition(Event event) {
        return ((CondJump) event).getGuard().toBoolFormula(event, solverContext);
    }

    public BooleanFormula execution(Event event) {
        return event.exec();
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
        boolean b = first.getCId() < second.getCId();
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
        return booleanFormulaManager.makeVariable("idd " + first.getCId() + " " + second.getCId());
    }

    public BooleanFormula equal(Formula left, Formula right) {
        return generalEqual(left, right, solverContext);
    }

    public BooleanFormula equalZero(Formula formula) {
        return generalEqualZero(formula, solverContext);
    }

    public BooleanFormula sameAddress(MemEvent first, MemEvent second) {
        return aliasAnalysis.mustAlias(first, second) ? booleanFormulaManager.makeTrue() : equal(address(first), address(second));
    }

    public Formula address(MemEvent event) {
        return ((MemEvent) event).getAddress().toIntFormula(event, solverContext);
    }

    public Formula value(MemEvent event) {
        return event instanceof Load ? result(event) : ((MemEvent) event).getMemValue().toIntFormula(event, solverContext);
    }

    public Formula result(RegWriter event) {
        return ((RegWriter) event).getResultRegister().toIntFormulaResult(event, solverContext);
    }

    public NumeralFormula.IntegerFormula clockVariable(String name, Event event) {
        return formulaManager.getIntegerFormulaManager().makeVariable(formulaManager.escape(name) + " " + event.getCId());
    }

    public NumeralFormula.IntegerFormula memoryOrderClock(Event write) {
        checkArgument(write.is(WRITE), "Cannot get a clock-var for non-writes.");
        if (write.is(INIT)) {
            return formulaManager.getIntegerFormulaManager().makeNumber(0);
        }
        return formulaManager.getIntegerFormulaManager().makeVariable("co " + write.getCId());
    }

    public BooleanFormula edgeVariable(String name, Event first, Event second) {
        return booleanFormulaManager.makeVariable(formulaManager.escape(name) + " " + first.getCId() + " " + second.getCId());
    }

    public BooleanFormula edge(Relation relation, Tuple tuple) {
        if (!relation.getMaxTupleSet().contains(tuple)) {
            return booleanFormulaManager.makeFalse();
        }
        if (relation.getMinTupleSet().contains(tuple)) {
            return execution(tuple.getFirst(), tuple.getSecond());
        }
        return relation.getSMTVar(tuple, this);
    }

    public BooleanFormula edge(Relation relation, Event first, Event second) {
        return edge(relation, new Tuple(first, second));
    }
}