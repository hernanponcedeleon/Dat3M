package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

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
        // For now we return a configured value. Ideally, we would like to
        // find this property automatically.
        return assumeLocalConsistency;
    }

    public boolean doesRespectAtomicBlocks() {
        // For now we return a configured value. Ideally, we would like to
        // find this property automatically. This is currently only relevant for SVCOMP
        return respectsAtomicBlocks;
    }

    private WmmAnalysis(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
    }

    public static WmmAnalysis fromConfig(Wmm memoryModel, Configuration config) throws InvalidConfigurationException {
        return new WmmAnalysis(config);
    }
}
