package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.List;
import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;
import static java.util.stream.Collectors.toSet;

public class CoarseRelationAnalysis extends NativeRelationAnalysis {

    private CoarseRelationAnalysis(VerificationTask t, Context context, Configuration config) {
        super(t, context, config);
    }

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
    public static CoarseRelationAnalysis fromConfig(VerificationTask task, Context context, Configuration config) throws InvalidConfigurationException {
        return new CoarseRelationAnalysis(task, context, config);
    }

    @Override
    protected void processSCC(Propagator propagator, Set<DependencyGraph<Relation>.Node> scc, Map<Relation, List<Delta>> qGlobal, Map<Relation, List<Definition>> dependents) {
        final Wmm wmm = task.getMemoryModel();
        if (scc.stream().map(DependencyGraph.Node::getContent).noneMatch(wmm::isInternal)) {
            return;
        }
        super.processSCC(propagator, scc, qGlobal, dependents);
    }

    @Override
    protected void checkAfterRun(Map<Relation, List<Delta>> qGlobal) {
    }

    @Override
    public void runExtended() {
        run();
    }

    @Override
    protected Initializer getInitializer() {
        return new EmptyInitializer();
    }

    private final class EmptyInitializer extends NativeRelationAnalysis.Initializer {
        final MutableKnowledge defaultBinaryKnowledge;
        final MutableKnowledge defaultUnaryKnowledge;

        EmptyInitializer() {
            MutableEventGraph mayBin = new MapEventGraph();
            MutableEventGraph mayUn = new MapEventGraph();
            Set<Event> events = program.getThreadEvents().stream().filter(e -> e.hasTag(VISIBLE)).collect(toSet());
            events.forEach(x -> mayBin.addRange(x, events));
            events.forEach(x -> mayUn.add(x, x));
            defaultBinaryKnowledge = new MutableKnowledge(mayBin, new MapEventGraph());
            defaultUnaryKnowledge = new MutableKnowledge(mayUn, new MapEventGraph());
        }

        @Override
        public MutableKnowledge visitDefinition(Definition def) {
            return !task.getMemoryModel().isInternal(def.getDefinedRelation())
                    ? (def.getDefinedRelation().isSet() ? defaultUnaryKnowledge : defaultBinaryKnowledge)
                    : new MutableKnowledge(new MapEventGraph(), new MapEventGraph());
        }
    }
}
