package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

import static com.dat3m.dartagnan.configuration.OptionNames.WMM_ELIMINATE_RECURSION;
import static com.dat3m.dartagnan.configuration.OptionNames.WMM_SIMPLIFY_CLOSURES;

@Options
public class WmmProcessingManager implements WmmProcessor {

    @Option(name = WMM_ELIMINATE_RECURSION,
            description = "Replaces recursive relation definitions by equivalent non-recursive ones, if possible.",
            secure = true)
    private boolean eliminateRecursion = true;

    @Option(name = WMM_SIMPLIFY_CLOSURES,
            description = "Removes redundant transitive closures (closures of transitive relations and closures inside acyclicity/irreflexivity axioms).",
            secure = true)
    private boolean simplifyClosures = true;

    private final List<WmmProcessor> processors = new ArrayList<>();

    private WmmProcessingManager(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
        processors.addAll(Arrays.asList(
                eliminateRecursion ? EliminateRecursion.newInstance() : null,
                simplifyClosures ? SimplifyClosures.newInstance() : null,
                RemoveDeadRelations.newInstance(),
                MergeEquivalentRelations.newInstance(),
                FlattenAssociatives.newInstance(),
                MarkFreeRelations.newInstance()
        ));
        processors.removeIf(Objects::isNull);
    }

    public static WmmProcessingManager newInstance() {
        try {
            return fromConfig(Configuration.defaultConfiguration());
        } catch (InvalidConfigurationException e) {
            throw new IllegalStateException(e);
        }
    }

    public static WmmProcessingManager fromConfig(Configuration config) throws InvalidConfigurationException {
        return new WmmProcessingManager(config);
    }

    // ==================================================

    @Override
    public void run(Wmm wmm) {
        processors.forEach(p -> p.run(wmm));
    }


}
