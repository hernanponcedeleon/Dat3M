package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.RecursiveGroup;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.HashSet;
import java.util.Set;

public class RelationAnalysis {

    private RelationAnalysis(VerificationTask task, Context context, Configuration config) {
        context.requires(ExecutionAnalysis.class);
        context.requires(AliasAnalysis.class);
        context.requires(Dependency.class);
        context.requires(WmmAnalysis.class);
    }

    /**
     * Performs a static analysis on the relationships that may occur in an execution.
     * @param task Program, target memory model and property to check.
     * @param context Collection of static analyses already performed on {@code task} with respect to {@code memoryModel}.
     *                Should at least include the following elements:
     *                <ul>
     *                    <li>{@link ExecutionAnalysis}
     *                    <li>{@link Dependency}
     *                    <li>{@link AliasAnalysis}
     *                    <li>{@link WmmAnalysis}
     *                </ul>
     * @param config User-defined options to further specify the behavior.
     */
    public static RelationAnalysis fromConfig(VerificationTask task, Context context, Configuration config) throws InvalidConfigurationException {
        RelationAnalysis a = new RelationAnalysis(task, context, config);
        a.run(task, context);
        return a;
    }

    /*
        Returns a set of co-edges (w1, w2) (subset of maxTupleSet) whose clock-constraints
        do not need to get encoded explicitly.
        The reason is that whenever we have co(w1,w2) then there exists an intermediary
        w3 s.t. co(w1, w3) /\ co(w3, w2). As a result we have c(w1) < c(w3) < c(w2) transitively.
        Reasoning: Let (w1, w2) be a potential co-edge. Suppose there exists a w3 different to w1 and w2,
        whose execution is either implied by either w1 or w2.
        Now, if co(w1, w3) is a must-edge and co(w2, w3) is impossible, then we can reason as follows.
            - Suppose w1 and w2 get executed and their addresses match, then w3 must also get executed.
            - Since co(w1, w3) is a must-edge, we have that w3 accesses the same address as w1 and w2,
              and c(w1) < c(w3).
            - Because addr(w2)==addr(w3), we must also have either co(w2, e3) or co(w3, w2).
              The former is disallowed by assumption, so we have co(w3, w2) and hence c(w3) < c(w2).
            - By transitivity, we have c(w1) < c(w3) < c(w2) as desired.
            - Note that this reasoning has to be done inductively, because co(w1, w3) or co(w3, w2) may
              not involve encoding a clock constraint (due to this optimization).
        There is also a symmetric case where co(w3, w1) is impossible and co(w3, w2) is a must-edge.
     */
    public static Set<Tuple> findTransitivelyImpliedCo(Relation co, ExecutionAnalysis exec) {
        final TupleSet min = co.getMinTupleSet();
        final TupleSet max = co.getMaxTupleSet();
        Set<Tuple> transCo = new HashSet<>();
        for (final Tuple t : max) {
            final MemEvent x = (MemEvent) t.getFirst();
            final MemEvent z = (MemEvent) t.getSecond();
            final boolean hasIntermediary = min.getByFirst(x).stream().map(Tuple::getSecond)
                            .anyMatch(y -> y != x && y != z && (exec.isImplied(x, y) || exec.isImplied(z, y)) && !max.contains(new Tuple(z, y))) ||
                    min.getBySecond(z).stream().map(Tuple::getFirst)
                            .anyMatch(y -> y != x && y != z && (exec.isImplied(x, y) || exec.isImplied(z, y)) && !max.contains(new Tuple(y, x)));
            if (hasIntermediary) {
                transCo.add(t);
            }
        }
        return transCo;
    }

    private void run(VerificationTask task, Context context) {
        // Init data context so that each relation is able to compute its may/must sets.
        final Wmm memoryModel = task.getMemoryModel();
        for(RecursiveGroup recursiveGroup : memoryModel.getRecursiveGroups()){
            recursiveGroup.setDoRecurse();
        }

        // ------------------------------------------------
        for (Relation rel : memoryModel.getRelations()) {
            rel.initializeRelationAnalysis(task, context);
        }
        for (Axiom ax : memoryModel.getAxioms()) {
            ax.initializeRelationAnalysis(task, context);
        }

        // ------------------------------------------------
        for (String baseRel : Wmm.BASE_RELATIONS) {
            memoryModel.getRelation(baseRel).getMinTupleSet();
            memoryModel.getRelation(baseRel).getMaxTupleSet();
        }
        for (RecursiveGroup recursiveGroup : memoryModel.getRecursiveGroups()) {
            recursiveGroup.initMaxTupleSets();
            recursiveGroup.initMinTupleSets();
        }
        for (Axiom ax : memoryModel.getAxioms()) {
            ax.getRelation().getMaxTupleSet();
            ax.getRelation().getMinTupleSet();
        }
    }
}
