package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.program.analysis.AliasAnalysis;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.binary.RelMinus;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;
import java.util.stream.Collectors;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Verify.verify;

public class RelationAnalysis {

    private final VerificationTask task;
    private final Context context;
    private final Map<Relation,Knowledge> knowledgeMap = new HashMap<>();

    private RelationAnalysis(VerificationTask task, Context context, Configuration config) {
        this.task = task;
        this.context = context;
        context.requires(AliasAnalysis.class);
        context.requires(BranchEquivalence.class);
        context.requires(WmmAnalysis.class);
    }

    public static RelationAnalysis fromConfig(VerificationTask task, Context context, Configuration config) throws InvalidConfigurationException {
        RelationAnalysis ra = new RelationAnalysis(task, context, config);
        ra.run();
        return ra;
    }

    /**
     * Fetches results of this analysis.
     * @param relation Some element in the associated task's memory model.
     * @return Event pairs that could participate in {@code relation} in some execution.
     */
    public TupleSet may(Relation relation) {
        return knowledgeMap.get(relation).may;
    }

    /**
     * Fetches results of this analysis.
     * @param relation Some element in the associated task's memory model.
     * @return Event pairs that cannot be missing in {@code relation} in any execution that executes both events.
     */
    public TupleSet must(Relation relation) {
        return knowledgeMap.get(relation).must;
    }

    @FunctionalInterface
    public interface SetListener {
        void notify(TupleSet may, TupleSet must);
    }

    public final class Buffer {
        private final Map<Relation,List<SetListener>> listenerMap = new HashMap<>();
        private final Map<Relation,SetDelta> qGlobal = new HashMap<>();
        private final Map<Relation,SetDelta> qLocal = new HashMap<>();
        private final Set<Relation> stratum = new HashSet<>();
        public VerificationTask task() {
            return task;
        }
        public Context analysisContext() {
            return context;
        }
        public TupleSet may(Relation relation) {
            return knowledgeMap.get(relation).may;
        }
        public TupleSet must(Relation relation) {
            return knowledgeMap.get(relation).must;
        }
        public void send(Relation rel, Set<Tuple> may, Set<Tuple> must) {
            if(may.isEmpty() && must.isEmpty()) {
                return;
            }
            SetDelta d = (stratum.contains(rel) ? qLocal : qGlobal).computeIfAbsent(rel, k -> new SetDelta());
            d.may.addAll(may);
            d.must.addAll(must);
        }
        public void listen(Relation relation, SetListener listener) {
            listenerMap.computeIfAbsent(relation, k->new ArrayList<>()).add(listener);
        }
    }

    private static final class Knowledge {
        final TupleSet may = new TupleSet();
        final TupleSet must = new TupleSet();
    }

    private static final class SetDelta {
        final TupleSet may = new TupleSet();
        final TupleSet must = new TupleSet();
    }

    private void run() {
        // Init data context so that each relation is able to compute its may/must sets.
        Wmm memoryModel = task.getMemoryModel();
        for (Axiom ax : memoryModel.getAxioms()) {
            ax.getRelation().updateRecursiveGroupId(ax.getRelation().getRecursiveGroupId());
        }
        // ------------------------------------------------
        //ensure that the repository contains all base relations
        for(String relName : Wmm.BASE_RELATIONS){
            memoryModel.getRelationRepository().getRelation(relName);
        }

        DependencyGraph<Relation> dep = memoryModel.getRelationDependencyGraph();
        checkArgument(memoryModel.getRelationRepository().getRelations().stream()
                        .filter(RelMinus.class::isInstance)
                        .noneMatch(r -> dep.get(r).getSCC().contains(dep.get(r.getSecond()))),
                "Unstratifiable model.");

        for (Relation rel : memoryModel.getRelationRepository().getRelations()) {
            knowledgeMap.put(rel, new Knowledge());
        }
        Buffer buffer = new Buffer();
        for (Relation rel : memoryModel.getRelationRepository().getRelations()) {
            rel.initializeRelationAnalysis(buffer);
        }
        for (Axiom ax : memoryModel.getAxioms()) {
            ax.initializeRelationAnalysis(task, context);
        }

        // ------------------------------------------------#
        for(Set<DependencyGraph<Relation>.Node> scc : memoryModel.getRelationDependencyGraph().getSCCs()) {
            verify(buffer.qLocal.isEmpty(), "queue for last stratum was not empty");
            buffer.stratum.clear();
            scc.stream().map(DependencyGraph.Node::getContent).forEach(buffer.stratum::add);
            // move from global queue
            for(Relation relation : buffer.stratum) {
                SetDelta delta = buffer.qGlobal.remove(relation);
                if(delta != null) {
                    buffer.qLocal.put(relation,delta);
                }
            }
            while(!buffer.qLocal.isEmpty()) {
                Relation relation = buffer.qLocal.keySet().iterator().next();
                Knowledge knowledge = knowledgeMap.get(relation);
                SetDelta delta = buffer.qLocal.remove(relation);
                TupleSet may = delta.may.stream().filter(knowledge.may::add).collect(Collectors.toCollection(TupleSet::new));
                TupleSet must = delta.must.stream().filter(knowledge.must::add).collect(Collectors.toCollection(TupleSet::new));
                for(SetListener l : buffer.listenerMap.getOrDefault(relation,List.of())) {
                    // this may invoke buffer and thus fill qGlobal and qLocal
                    l.notify(may,must);
                }
            }
        }
        verify(buffer.qGlobal.isEmpty(), "knowledge buildup propagated downwards");
    }
}
