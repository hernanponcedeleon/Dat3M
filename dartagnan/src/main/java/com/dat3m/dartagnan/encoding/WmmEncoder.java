package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.local.RelAddrDirect;
import com.dat3m.dartagnan.wmm.relation.base.local.RelIdd;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelCo;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.google.common.base.Preconditions;
import com.google.common.collect.Sets;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.configuration.OptionNames.CO_ANTISYMMETRY;
import static com.dat3m.dartagnan.encoding.ProgramEncoder.execution;
import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;
import static com.google.common.collect.Sets.difference;
import static com.google.common.collect.Sets.intersection;

@Options
public class WmmEncoder {

    private static final Logger logger = LogManager.getLogger(WmmEncoder.class);

    private final VerificationTask task;
    private final Wmm memoryModel;
    private final Context analysisContext;
    private final SolverContext ctx;
    private final Map<Relation, Set<Tuple>> tuples = new HashMap<>();

    // =========================== Configurables ===========================

    @Option(
        name=CO_ANTISYMMETRY,
        description="Encodes the antisymmetry of coherences explicitly.",
        secure=true)
    private boolean antisymmetry = false;

    // =====================================================================

    private WmmEncoder(VerificationTask t, Context context, SolverContext solverContext) {
        task = Preconditions.checkNotNull(t);
        memoryModel = task.getMemoryModel();
        analysisContext = context;
        context.requires(RelationAnalysis.class);
        ctx = solverContext;
    }

    public static WmmEncoder fromConfig(VerificationTask task, Context context, SolverContext ctx) throws InvalidConfigurationException {
        WmmEncoder encoder = new WmmEncoder(task, context, ctx);
        task.getConfig().inject(encoder);
        logger.info("{}: {}", CO_ANTISYMMETRY, encoder.antisymmetry);
        encoder.initializeEncoding();
        return encoder;
    }

    public VerificationTask task() {
        return task;
    }

    public Context analysisContext() {
        return analysisContext;
    }

    public SolverContext solverContext() {
        return ctx;
    }

    public Set<Tuple> tupleSet(Relation relation) {
        return tuples.getOrDefault(relation, Set.of());
    }

    public BooleanFormula edge(Relation relation, Event first, Event second) {
        return edge(relation, new Tuple(first, second));
    }

    public BooleanFormula edge(Relation relation, Tuple tuple) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        if(relation.getMaxTupleSet().contains(tuple)) {
            return bmgr.makeFalse();
        }
        if(relation instanceof RelIdd || relation instanceof RelAddrDirect) {
            return relation.getMinTupleSet().contains(tuple)
                ? execution(tuple.getFirst(), tuple.getSecond(), analysisContext.get(ExecutionAnalysis.class), ctx)
                : task.getProgramEncoder().dependencyEdge(tuple.getFirst(), tuple.getSecond());
        }
        if(antisymmetry && relation instanceof RelCo && tuple.getSecond().getCId() <= tuple.getFirst().getCId()) {
            MemEvent first = (MemEvent) tuple.getFirst();
            MemEvent second = (MemEvent) tuple.getSecond();
            // Doing the check at the java level seems to slightly improve  performance
            ExecutionAnalysis exec = analysisContext.requires(ExecutionAnalysis.class);
            return bmgr.and(
                execution(tuple.getFirst(), tuple.getSecond(), exec, ctx),
                first.getAddress().equals(second.getAddress())
                    ? bmgr.makeTrue()
                    : generalEqual(first.getMemAddressExpr(), second.getMemAddressExpr(), ctx),
                bmgr.not(Utils.edge(relation.getName(), tuple.getSecond(), tuple.getFirst(), ctx)));
        }
        return Utils.edge(relation.getName(), tuple.getFirst(), tuple.getSecond(), ctx);
    }

    /**
     * Instances live during {@link WmmEncoder}'s initialization phase.
     * Pass requests for tuples to be added to the encoding, between relations.
     * To be used in {@link Relation#activate(Set,Buffer) Relation}.
     */
    public static final class Buffer {
        private final VerificationTask task;
        private final Context analysisContext;
        private final Map<Relation, Set<Tuple>> queue = new HashMap<>();
        private Buffer(VerificationTask t, Context a) {
            task = t;
            analysisContext = a;
        }
        public VerificationTask task() {
            return task;
        }
        public Context analysisContext() {
            return analysisContext;
        }
        /**
         * Called whenever a batch of new relationships has been marked.
         * Performs duplicate elimination (i.e. if multiple relations send overlapping tuples)
         * and delays their insertion into the encoder's set to decrease the number of propagations.
         * @param rel    Target relation, will be notified of this batch, eventually.
         * @param tuples Collection of event pairs in {@code rel}, that are requested to be encoded.
         *               Subset of {@code rel}'s may set, and disjoint from its must set.
         */
        public void send(Relation rel, Set<Tuple> tuples) {
            queue.merge(rel, tuples, Sets::union);
        }
    }

    private void initializeEncoding() {
        for(String relName : Wmm.BASE_RELATIONS) {
            memoryModel.getRelationRepository().getRelation(relName);
        }

        for(Relation relation : memoryModel.getRelationRepository().getRelations()){
            relation.initializeEncoding(ctx);
        }

        for (Axiom axiom : memoryModel.getAxioms()) {
            axiom.initializeEncoding(ctx);
        }

        // ====================== Compute encoding information =================
        Buffer buffer = new Buffer(task, analysisContext);
        Map<Relation, Set<Tuple>> queue = buffer.queue;
        RelationAnalysis ra = analysisContext.get(RelationAnalysis.class);
        for (Axiom ax : memoryModel.getAxioms()) {
            ax.activate(buffer);
        }

        while(!queue.isEmpty()) {
            Relation relation = queue.keySet().iterator().next();
            Set<Tuple> set = tuples.computeIfAbsent(relation, k -> new HashSet<>());
            Set<Tuple> delta = new HashSet<>(difference(intersection(queue.remove(relation), relation.getMaxTupleSet()), set));
            if(delta.isEmpty()) {
                continue;
            }
            set.addAll(delta);
            relation.activate(delta, buffer);
        }
    }

    public BooleanFormula encodeFullMemoryModel() {
        return ctx.getFormulaManager().getBooleanFormulaManager().and(
                encodeRelations(), encodeConsistency()
        );
    }

    // This methods initializes all relations and encodes all base relations
    // It does NOT encode the axioms nor any non-base relation yet!
    public BooleanFormula encodeAnarchicSemantics() {
        logger.info("Encoding anarchic semantics");
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
        for(String relName : Wmm.BASE_RELATIONS){
            enc = bmgr.and(enc, encode(memoryModel.getRelationRepository().getRelation(relName)));
        }

        return enc;
    }

    // Initializes everything just like encodeAnarchicSemantics but also encodes all
    // relations that are needed for the axioms (but does NOT encode the axioms themselves yet)
    // NOTE: It avoids encoding relations that do NOT affect the axioms, i.e. unused relations
    public BooleanFormula encodeRelations() {
        logger.info("Encoding relations");
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula enc = encodeAnarchicSemantics();
        for(Relation r : memoryModel.getRelationRepository().getRelations()) {
            if(!r.getIsNamed() || !Wmm.BASE_RELATIONS.contains(r.getName())) {
                enc = bmgr.and(enc, encode(r));
            }
        }
        return enc;
    }

    // Encodes all axioms. This should be called after <encodeRelations>
    public BooleanFormula encodeConsistency() {
        logger.info("Encoding consistency");
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula expr = bmgr.makeTrue();
        for (Axiom ax : memoryModel.getAxioms()) {
        	// Flagged axioms do not act as consistency filter
        	if(ax.isFlagged()) {
        		continue;
        	}
            expr = bmgr.and(expr, ax.consistent(this));
        }
        return expr;
    }

    private BooleanFormula encode(Relation relation) {
        return relation.encode(tuples.getOrDefault(relation, Set.of()), this);
    }
}
