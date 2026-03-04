package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.configuration.RelationAnalysisMethod;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.List;
import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.configuration.OptionNames.ENABLE_EXTENDED_RELATION_ANALYSIS;
import static com.dat3m.dartagnan.configuration.OptionNames.RELATION_ANALYSIS;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;
import static com.google.common.base.Preconditions.checkNotNull;

public interface RelationAnalysis {

    Logger logger = LoggerFactory.getLogger(RelationAnalysis.class);

    /**
     * Performs a static analysis on the relationships that may occur in an execution.
     *
     * @param task    Program, target memory model and property to check.
     * @param context Collection of static analyses already performed on {@code task} with respect to {@code memoryModel}.
     *                Should at least include the following elements:
     *                <ul>
     *                    <li>{@link ExecutionAnalysis}
     *                    <li>{@link ReachingDefinitionsAnalysis}
     *                    <li>{@link AliasAnalysis}
     *                    <li>{@link WmmAnalysis}
     *                </ul>
     * @param config  User-defined options to further specify the behavior.
     */
    static RelationAnalysis fromConfig(VerificationTask task, Context context, Configuration config) throws InvalidConfigurationException {
        RelationAnalysis.Config c = new RelationAnalysis.Config(config);
        RelationAnalysis a = switch (c.method) {
            case NONE -> CoarseRelationAnalysis.fromConfig(task, context, config);
            case NATIVE -> NativeRelationAnalysis.fromConfig(task, context, config);
            case LAZY -> LazyRelationAnalysis.fromConfig(task, context, config);
        };

        if (c.enableExtended && (c.method == RelationAnalysisMethod.NONE || c.method == RelationAnalysisMethod.LAZY)) {
            logger.info("{}=true can only be combined with {}={}. Setting {}=false.",
                    ENABLE_EXTENDED_RELATION_ANALYSIS, RELATION_ANALYSIS, RelationAnalysisMethod.NATIVE,
                    ENABLE_EXTENDED_RELATION_ANALYSIS);
            c.enableExtended = false;
        }

        if (logger.isInfoEnabled()) {
            logger.info("Selected relation analysis: {}", c.method);
            final StringBuilder configSummary = new StringBuilder().append("\n");
            configSummary.append("\t").append(RELATION_ANALYSIS).append(": ").append(c.method).append("\n");
            configSummary.append("\t").append(ENABLE_EXTENDED_RELATION_ANALYSIS).append(": ").append(c.enableExtended);
            logger.info(configSummary.toString());
        }

        final Wmm wmm = task.getMemoryModel();
        long t0 = System.currentTimeMillis();
        a.run();
        long t1 = System.currentTimeMillis();
        final StringBuilder summary = new StringBuilder();
        if (logger.isInfoEnabled()) {
            logger.info("Finished regular analysis in {}", Utils.toTimeString(t1 - t0));
            summary.append("\n======== RelationAnalysis summary ======== \n");
            summary.append("\t#Relations: ").append(wmm.getRelations().size()).append("\n");
            summary.append("\t#Axioms: ").append(wmm.getAxioms().size()).append("\n");
        }
        if (c.enableExtended) {
            long mayCount = -1;
            long mustCount = -1;
            if (logger.isInfoEnabled()) {
                mayCount = countMaySet(wmm, a);
                mustCount = countMustSet(wmm, a);
            }
            a.runExtended();
            if (logger.isInfoEnabled()) {
                logger.info("Finished extended analysis in {}", Utils.toTimeString(System.currentTimeMillis() - t1));
                summary.append("\t#may-edges removed (extended): ").append(mayCount - countMaySet(wmm, a)).append("\n");
                summary.append("\t#must-edges added (extended): ").append(countMustSet(wmm, a) - mustCount).append("\n");
            }
        }
        if (logger.isInfoEnabled()) {
            Knowledge rf = a.getKnowledge(wmm.getRelation(RF));
            Knowledge co = a.getKnowledge(wmm.getRelation(CO));
            summary.append("\ttotal #must|may|exclusive edges: ")
                    .append(countMustSet(wmm, a)).append("|").append(countMaySet(wmm, a)).append("|").append(a.getContradictions().size()).append("\n");
            summary.append("\t#must|may rf edges: ").append(rf.must.size()).append("|").append(rf.may.size()).append("\n");
            summary.append("\t#must|may co edges: ").append(co.must.size()).append("|").append(co.may.size()).append("\n");
            summary.append("===========================================");
            logger.info(summary.toString());
        }
        return a;
    }

    /*
        Consider a relation definition "let c = a op b".
        A "discrepancy" is an element c(x,y) that is statically known but not implied
        by the static information we have about "a" and "b".
        This can only happen if we obtain information about "c(x,y)" from other constraints
        besides its definition, e.g., when we perform XRA.
     */
    void collectDiscrepancies(Set<Relation> relations, Map<Relation, List<EventGraph>> discrepancyCollector);
    
    private static long countMaySet(Wmm memoryModel, RelationAnalysis ra) {
        return memoryModel.getRelations().stream()
                .mapToLong(rel -> ra.getKnowledge(rel).getMaySet().size())
                .sum();
    }

    private static long countMustSet(Wmm memoryModel, RelationAnalysis ra) {
        return memoryModel.getRelations().stream()
                .mapToLong(rel -> ra.getKnowledge(rel).getMustSet().size())
                .sum();
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

    /**
     * Runs the relation analysis.
     */
    void run();

    /**
     * Runs the extended relation analysis.
     */
    void runExtended();

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

    class Knowledge {
        protected final EventGraph may;
        protected final EventGraph must;

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
