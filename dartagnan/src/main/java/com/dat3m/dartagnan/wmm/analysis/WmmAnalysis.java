package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.exception.MalformedMemoryModelException;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.definition.Difference;
import com.dat3m.dartagnan.wmm.definition.DomainIdentity;
import com.dat3m.dartagnan.wmm.definition.Inverse;
import com.dat3m.dartagnan.wmm.definition.RangeIdentity;
import com.dat3m.dartagnan.wmm.definition.TransitiveClosure;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.Set;

import static com.dat3m.dartagnan.configuration.OptionNames.LOCALLY_CONSISTENT;

@Options
public class WmmAnalysis {

    // =========================== Configurables ===========================

    @Option(
            name= LOCALLY_CONSISTENT,
            description="Assumes local consistency for all created wmms.",
            secure=true)
    private boolean assumeLocalConsistency = true;

    @Option(
            description="Assumes the WMM respects atomic blocks for optimization (only the case for SVCOMP right now).",
            secure=true)
    private boolean respectsAtomicBlocks = true;

    // =====================================================================

    public boolean isLocallyConsistent() {
        // For now, we return a configured value. Ideally, we would like to
        // find this property automatically.
        return assumeLocalConsistency;
    }

    public boolean doesRespectAtomicBlocks() {
        // For now, we return a configured value. Ideally, we would like to
        // find this property automatically. This is currently only relevant for SVCOMP
        return respectsAtomicBlocks;
    }

    private WmmAnalysis(Wmm memoryModel, Configuration config) throws InvalidConfigurationException {
        config.inject(this);
        checkWellformedness(memoryModel);
    }

    public static WmmAnalysis fromConfig(Wmm memoryModel, Configuration config) throws InvalidConfigurationException {
        return new WmmAnalysis(memoryModel, config);
    }

    private void checkWellformedness(Wmm memoryModel) {
        final DependencyGraph<Relation> depGraph = DependencyGraph.from(memoryModel.getRelations());
        for (Set<DependencyGraph<Relation>.Node> scc : depGraph.getSCCs()) {
            for (DependencyGraph<Relation>.Node node : scc) {
                final Definition d = node.getContent().getDefinition();
                if ((d instanceof Inverse || d instanceof DomainIdentity || d instanceof RangeIdentity || d instanceof TransitiveClosure) && scc.size() > 1) {
                    // Unary relations are not implemented in recursions right now
                    throw new UnsupportedOperationException(String.format(
                            "Unary relation %s not supported in recursive definitions.", node.getContent()
                    ));
                } else if (d instanceof Difference && scc.contains(depGraph.get(((Difference) d).complement))) {
                    // Non-monotonic recursion gives ill-defined memory models.
                    throw new MalformedMemoryModelException(String.format(
                            "Non-monotonic recursion is not supported: %s", node.getContent()
                    ));
                }
            }
        }
    }
}
