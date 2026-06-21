package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.smt.FormulaManagerExt;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.definition.DirectAddressDependency;
import com.dat3m.dartagnan.wmm.definition.DirectDataDependency;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.collect.Iterables;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.MERGE_CF_VARS;
import static com.dat3m.dartagnan.encoding.ExpressionEncoder.ConversionMode.MEMORY_ROUND_TRIP_RELAXED;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

@Options
public final class EncodingContext {

    private static final Logger logger = LoggerFactory.getLogger(EncodingContext.class);

    private final VerificationTask verificationTask;
    private final Context analysisContext;
    private final ExecutionAnalysis executionAnalysis;
    private final AliasAnalysis aliasAnalysis;
    private final RelationAnalysis relationAnalysis;
    private final FormulaManagerExt fmgr;
    private final BooleanFormulaManager bmgr;
    final Collection<Constraint> constraintsToEncode;
    private final ExpressionEncoder exprEncoder;

    private final ExpressionFactory exprs = ExpressionFactory.getInstance();

    @Option(name = MERGE_CF_VARS,
            description = "Merges control flow variables of events with identical control-flow behaviour.",
            secure = true)
    private boolean shouldMergeCFVars = true;

    private final Map<Event, BooleanFormula> controlFlowVariables = new HashMap<>();
    private final Map<Event, BooleanFormula> executionVariables = new HashMap<>();
    private final Map<NamedBarrier, BooleanFormula> syncVariables = new HashMap<>();

    private final Map<Event, TypedFormula<?, ?>> values = new HashMap<>();
    private final Map<Event, TypedFormula<?, ?>> results = new HashMap<>();

    // TODO: Once we have a PointerType, this needs to get updated.
    private final Map<Event, TypedFormula<?, ?>> addresses = new HashMap<>();
    private final Map<MemoryObject, TypedFormula<?, ?>> objAddress = new HashMap<>();
    private final Map<MemoryObject, TypedFormula<IntegerType, ?>> objSize = new HashMap<>();

    private EncodingContext(VerificationTask t, Context a, FormulaManager m, Collection<? extends Constraint> c) {
        verificationTask = checkNotNull(t);
        analysisContext = checkNotNull(a);
        a.requires(BranchEquivalence.class);
        executionAnalysis = a.requires(ExecutionAnalysis.class);
        aliasAnalysis = a.requires(AliasAnalysis.class);
        relationAnalysis = a.requires(RelationAnalysis.class);
        fmgr = new FormulaManagerExt(m);
        bmgr = fmgr.getBooleanFormulaManager();
        exprEncoder = new ExpressionEncoder(this);

        // All anarchic relations have to be encoded.
        final Iterable<? extends Constraint> anarchicConstraints = Wmm.ANARCHIC_CORE_RELATIONS.stream()
                .map(n -> t.getMemoryModel().getRelation(n).getDefinition())
                .toList();
        final Iterable<? extends Constraint> toEncode = Iterables.concat(c, anarchicConstraints);
        constraintsToEncode = new LinkedHashSet<>(
                DependencyGraph.from(toEncode, EncodingContext::computeConstraintDependencies).getNodeContents()
        );
    }

    public static EncodingContext of(VerificationTask task, Context analysisContext, FormulaManager formulaManager) throws InvalidConfigurationException {
        return of(task, analysisContext, formulaManager, task.getMemoryModel().getAxioms());
    }

    public static EncodingContext of(VerificationTask task, Context analysisContext, FormulaManager formulaManager,
            Collection<? extends Constraint> constraintsToEncode) throws InvalidConfigurationException {
        EncodingContext context = new EncodingContext(task, analysisContext, formulaManager, constraintsToEncode);
        task.getConfig().inject(context);
        logger.info("{}: {}", MERGE_CF_VARS, context.shouldMergeCFVars);
        context.initialize();

        return context;
    }

    public VerificationTask getTask() {
        return verificationTask;
    }

    public Context getAnalysisContext() {
        return analysisContext;
    }

    public FormulaManagerExt getFormulaManager() {
        return fmgr;
    }

    public BooleanFormulaManager getBooleanFormulaManager() {
        return bmgr;
    }

    public boolean isEncoded(Constraint c) { return constraintsToEncode.contains(c); }

    public ExpressionEncoder getExpressionEncoder() { return exprEncoder; }

    public ExpressionFactory getExpressionFactory() { return exprs; }

    // ====================================================================================
    // Control flow

    public BooleanFormula controlFlow(Event event) {
        return controlFlowVariables.get(event);
    }

    public BooleanFormula jumpTaken(CondJump jump) {
        return bmgr.and(execution(jump), exprEncoder.encodeBooleanAt(jump.getGuard(), jump).formula());
    }

    public BooleanFormula blocked(BlockingEvent barrier) {
        return bmgr.and(controlFlow(barrier), bmgr.not(execution(barrier)));
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
        return bmgr.and(execution(x), execution(y));
    }

    // ====================================================================================
    // Data flow

    public BooleanFormula sameAddress(MemoryCoreEvent first, MemoryCoreEvent second) {
        return aliasAnalysis.mustAlias(first, second)
                ? bmgr.makeTrue()
                : exprEncoder.equal(address(first), address(second));
    }

    public BooleanFormula sameResult(RegWriter first, RegWriter second) {
        return exprEncoder.equal(result(first), result(second));
    }

    public BooleanFormula sameValue(MemoryCoreEvent first, MemoryCoreEvent second) {
        return exprEncoder.equal(value(first), value(second));
    }

    public BooleanFormula assignValue(MemoryCoreEvent left, MemoryCoreEvent right) {
        return exprEncoder.assignEqual(value(left), value(right), MEMORY_ROUND_TRIP_RELAXED);
    }

    public TypedFormula<?, ?> address(MemoryCoreEvent event) {
        return addresses.get(event);
    }

    public TypedFormula<?, ?> address(MemoryObject memoryObject) { return objAddress.get(memoryObject); }

    // NOTE: This formula represents the size of successfully allocated memory objects.
    // For non-allocated memory objects, the size may be any non-negative value.
    public TypedFormula<IntegerType, ?> size(MemoryObject memoryObject) {
        return objSize.get(memoryObject);
    }

    /// Describes that {@code object} has been allocated, but has not been deallocated during the execution.
    public BooleanFormula leakVariable(MemoryObject object) {
        final int allocationSiteId = object.getAllocationSite().getGlobalId();
        return bmgr.makeVariable(fmgr.escape("leak%d".formatted(allocationSiteId)));
    }

    /// Describes that {@code object} is reachable from static memory at the end of the execution.
    public BooleanFormula trackVariable(MemoryObject object) {
        final int allocationSiteId = object.getAllocationSite().getGlobalId();
        return bmgr.makeVariable(fmgr.escape("track%d".formatted(allocationSiteId)));
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
        return bmgr.makeVariable("idd " + first.getGlobalId() + " " + second.getGlobalId());
    }

    public IntegerFormula clockVariable(String name, Event event) {
        return fmgr.getIntegerFormulaManager().makeVariable(fmgr.escape(name) + " " + event.getGlobalId());
    }

    // Careful: The semantics of this variable is currently only encoded when doing liveness checking
    //  or verifying litmus code.
    public BooleanFormula lastCoVar(Event write) {
        return bmgr.makeVariable("co_last(" + write.getGlobalId() + ")");
    }

    public BooleanFormula edgeVariable(String name, Event first, Event second) {
        return bmgr.makeVariable(fmgr.escape(name) + " " + first.getGlobalId() + " " + second.getGlobalId());
    }

    @FunctionalInterface
    public interface EdgeEncoder {
        BooleanFormula encode(Event e1, Event e2);

        default EdgeEncoder withCache() {
            final Map<Event, Map<Event, BooleanFormula>> cache = new HashMap<>();
            return (x, y) -> cache.computeIfAbsent(x, k -> new HashMap<>()).computeIfAbsent(y, k2 -> encode(x, y));
        }
    }

    public EdgeEncoder edge(Relation relation) {
        RelationAnalysis.Knowledge k = relationAnalysis.getKnowledge(relation);
        EventGraph may = k.getMaySet();
        EventGraph must = k.getMustSet();
        EdgeEncoder variable = getEdgeVariableEncoder(relation.getDefinition());
        return (e1, e2) -> {
            checkArgument(!relation.isSet() || e1.equals(e2), "Cannot encode pairs of events in an event set");
            return !may.contains(e1, e2)
                    ? bmgr.makeFalse()
                    : must.contains(e1, e2)
                    ? execution(e1, e2)
                    : variable.encode(e1, e2);
        };
    }

    public BooleanFormula edge(Relation relation, Event first, Event second) {
        return edge(relation).encode(first, second);
    }

    private EdgeEncoder getEdgeVariableEncoder(Definition def) {
        if (def instanceof DirectAddressDependency || def instanceof DirectDataDependency) {
            return this::dependency;
        } else {
            final String name = def.getDefinedRelation().getNameOrTerm();
            return (e1, e2) -> edgeVariable(name, e1, e2);
        }
    }

    // ====================================================================================
    // Model Evaluation

    // The return value must be closed by the caller, usually with a try-with-resources statement.
    public IREvaluator newEvaluator(ProverEnvironment prover) throws SolverException {
        return new IREvaluator(this, prover.getEvaluator());
    }

    // ====================================================================================
    // Private implementation

    private static Collection<? extends Constraint> computeConstraintDependencies(Constraint c) {
        final List<? extends Relation> rels = c.getConstrainedRelations();
        final List<? extends Relation> deps = c instanceof Definition ? rels.subList(1, rels.size()) : rels;
        return deps.stream().map(Relation::getDefinition).toList();
    }

    private void initialize() {
        // ------- Control flow variables -------
        // Only for the standard fair progress model we can merge CF variables.
        // TODO: It would also be possible for OBE/HSA in some cases if we refine the cf-equivalence classes
        //  to classes per thread.
        final boolean mergeCFVars = shouldMergeCFVars && verificationTask.getProgressModel().isFair();
        if (mergeCFVars) {
            for (BranchEquivalence.Class cls : analysisContext.get(BranchEquivalence.class).getAllEquivalenceClasses()) {
                BooleanFormula v = bmgr.makeVariable("cf " + cls.getRepresentative().getGlobalId());
                for (Event e : cls) {
                    controlFlowVariables.put(e, v);
                }
            }
        } else {
            for (Event e : verificationTask.getProgram().getThreadEvents()) {
                controlFlowVariables.put(e, bmgr.makeVariable("cf " + e.getGlobalId()));
            }
        }

        // ------- Memory object variables -------
        for (MemoryObject memoryObject : verificationTask.getProgram().getMemory().getObjects()) {
            objAddress.put(memoryObject, exprEncoder.encodeFinal(memoryObject));
            objSize.put(memoryObject, exprEncoder.makeVariable(String.format("sizeof(%s)", memoryObject),
                    TypeFactory.getInstance().getArchType())
            );
        }

        // ------- Event variables  -------
        for (Event e : verificationTask.getProgram().getThreadEvents()) {
            if (e instanceof NamedBarrier b) {
                syncVariables.put(b, bmgr.makeVariable("sync " + e.getGlobalId()));
            }
            if (!e.cfImpliesExec()) {
                executionVariables.put(e, bmgr.makeVariable("exec " + e.getGlobalId()));
            }
            if (e instanceof RegWriter rw) {
                final Register register = rw.getResultRegister();
                final String name = register.getName() + "(" + e.getGlobalId() + "_result)";
                results.put(e, exprEncoder.makeVariable(name, register.getType()));
            }
            if (e instanceof MemoryCoreEvent memEvent) {
                addresses.put(e, exprEncoder.encodeAt(memEvent.getAddress(), memEvent));
                if (e instanceof Load) {
                    values.put(e, results.get(e));
                } else if (e instanceof Store store) {
                    values.put(e, exprEncoder.encodeAt(store.getMemValue(), e));
                }
            }
        }
    }
}