package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

@Options
public class WmmProcessingManager implements WmmProcessor {

    private final List<WmmProcessor> processors = new ArrayList<>();

    // =========================== Configurables ===========================


    // =========================== Debugging options =======================


    // =====================================================================

    private WmmProcessingManager(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
        processors.addAll(Arrays.asList(
                RemoveDeadRelations.newInstance(),
                MergeEquivalentRelations.newInstance(),
                FlattenAssociatives.newInstance()
        ));
        processors.removeIf(Objects::isNull);
    }

    public static WmmProcessingManager fromConfig(Configuration config) throws InvalidConfigurationException {
        return new WmmProcessingManager(config);
    }

    // ==================================================

    public void run(Wmm wmm) {
        processors.forEach(p -> p.run(wmm));
    }


}