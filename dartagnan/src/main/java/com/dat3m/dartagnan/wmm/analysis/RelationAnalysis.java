package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.configuration.RelationAnalysisMethod;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.utils.EventGraph;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;
import static com.google.common.base.Preconditions.checkNotNull;

public interface RelationAnalysis {

    Logger logger = LogManager.getLogger(RelationAnalysis.class);

    /**
     * Performs a static analysis on the relationships that may occur in an execution.
     *
     * @param task    Program, target memory model and property to check.
     * @param context Collection of static analyses already performed on {@code task} with respect to {@code memoryModel}.
     *                Should at least include the following elements:
     *                <ul>
     *                    <li>{@link ExecutionAnalysis}
     *                    <li>{@link Dependency}
     *                    <li>{@link AliasAnalysis}
     *                    <li>{@link WmmAnalysis}
     *                </ul>
     * @param config  User-defined options to further specify the behavior.
     */
    static RelationAnalysis fromConfig(VerificationTask task, Context context, Configuration config) throws InvalidConfigurationException {
        RelationAnalysis.Config c = new RelationAnalysis.Config(config);
        logger.info("Selected relation analysis: {}", c.method);

        RelationAnalysis a = switch (c.method) {
            case NONE -> CoarseRelationAnalysis.fromConfig(task, context, config);
            case NATIVE -> NativeRelationAnalysis.fromConfig(task, context, config);
        };

        final StringBuilder configSummary = new StringBuilder().append("\n");
        configSummary.append("\t").append(RELATION_ANALYSIS).append(": ").append(c.method).append("\n");
        configSummary.append("\t").append(ENABLE_EXTENDED_RELATION_ANALYSIS).append(": ").append(c.enableExtended);
        logger.info(configSummary);

        if (c.enableExtended && c.method == RelationAnalysisMethod.NONE) {
            logger.warn("{} implies {}", ENABLE_EXTENDED_RELATION_ANALYSIS, RELATION_ANALYSIS);
            c.enableExtended = false;
        }

        long t0 = System.currentTimeMillis();
        a.run();
        long t1 = System.currentTimeMillis();
        logger.info("Finished regular analysis in {}", Utils.toTimeString(t1 - t0));

        final StringBuilder summary = new StringBuilder()
                .append("\n======== RelationAnalysis summary ======== \n");
        summary.append("\t#Relations: ").append(task.getMemoryModel().getRelations().size()).append("\n");
        summary.append("\t#Axioms: ").append(task.getMemoryModel().getAxioms().size()).append("\n");
        if (c.enableExtended) {
            long mayCount = a.countMaySet();
            long mustCount = a.countMustSet();
            a.runExtended();
            logger.info("Finished extended analysis in {}", Utils.toTimeString(System.currentTimeMillis() - t1));
            summary.append("\t#may-edges removed (extended): ").append(mayCount - a.countMaySet()).append("\n");
            summary.append("\t#must-edges added (extended): ").append(a.countMustSet() - mustCount).append("\n");
        }
        Knowledge rf = a.getKnowledge(task.getMemoryModel().getRelation(RF));
        Knowledge co = a.getKnowledge(task.getMemoryModel().getRelation(CO));
        summary.append("\ttotal #must|may|exclusive edges: ")
                .append(a.countMustSet()).append("|").append(a.countMaySet()).append("|").append(a.getContradictions().size()).append("\n");
        summary.append("\t#must|may rf edges: ").append(rf.must.size()).append("|").append(rf.may.size()).append("\n");
        summary.append("\t#must|may co edges: ").append(co.must.size()).append("|").append(co.may.size()).append("\n");
        summary.append("===========================================");
        logger.info(summary);
        return a;
    }

    @Options
    final class Config {
        @Option(name = RELATION_ANALYSIS,
                description = "Relation analysis engine.",
                secure = true)
        private RelationAnalysisMethod method = RelationAnalysisMethod.getDefault();

        @Option(name = ENABLE_EXTENDED_RELATION_ANALYSIS,
                description = "Marks relationships as trivially false, if they alone would violate a consistency property of the target memory model.",
                secure = true)
        private boolean enableExtended = true;

        private Config(Configuration config) throws InvalidConfigurationException {
            config.inject(this);
        }
    }

    /**
     * Fetches results of this analysis.
     *
     * @param relation Some element in the associated task's memory model.
     * @return Pairs of events of the program that may be related in some execution or even must be related in all executions.
     */
    Knowledge getKnowledge(Relation relation);

    /**
     * Iterates those event pairs that, if both executed, violate some axiom of the memory model.
     */
    EventGraph getContradictions();

    /*
        Returns a set of edges (e1, e2) (subset of may set) for ordered relations whose
        clock-constraints do not need to get encoded explicitly.
        e.g. for co relation: (e1 = w1, e2 = w2)
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
    EventGraph findTransitivelyImpliedCo(Relation co);

    /**
     * Runs the relation analysis.
     */
    void run();

    /**
     * Runs the extended relation analysis.
     */
    void runExtended();

    /**
     * Returns the may set size.
     */
    long countMaySet();

    /**
     * Returns the must set size.
     */
    long countMustSet();

    void populateQueue(Map<Relation, List<EventGraph>> queue, Set<Relation> relations);

    final class Knowledge {
        private final EventGraph may;
        private final EventGraph must;

        public Knowledge(EventGraph maySet, EventGraph mustSet) {
            may = checkNotNull(maySet);
            must = checkNotNull(mustSet);
        }

        public EventGraph getMaySet() {
            return may;
        }

        public EventGraph getMustSet() {
            return must;
        }

        @Override
        public String toString() {
            return "(may:" + may.size() + ", must:" + must.size() + ")";
        }
    }
}
