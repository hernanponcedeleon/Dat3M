package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import static com.dat3m.dartagnan.configuration.OptionNames.ALIAS_METHOD;

public interface AliasAnalysis {

    Logger logger = LogManager.getLogger(AliasAnalysis.class);

    boolean mustAlias(MemoryCoreEvent a, MemoryCoreEvent b);
    boolean mayAlias(MemoryCoreEvent a, MemoryCoreEvent b);

    static AliasAnalysis fromConfig(Program program, Configuration config) throws InvalidConfigurationException {
        Config c = new Config(config);
		logger.info("Selected alias analysis: " + c.method);
        AliasAnalysis a;
        long t0 = System.currentTimeMillis();
    	switch (c.method) {
            case FIELD_SENSITIVE:
                a = FieldSensitiveAndersen.fromConfig(program, config);
                break;
            case FIELD_INSENSITIVE:
                a = AndersenAliasAnalysis.fromConfig(program, config);
                break;
            default:
                throw new UnsupportedOperationException("Alias method not recognized");
        }
        a = new CombinedAliasAnalysis(a, EqualityAliasAnalysis.fromConfig(program, config));
        if (Arch.supportsVirtualAddressing(program.getArch())) {
            a = VirtualAliasAnalysis.wrap(a);
        }

        long t1 = System.currentTimeMillis();
        logger.info("Finished alias analysis in {}ms", t1 - t0);
        return a;
    }

    @Options
    final class Config {
        @Option(name = ALIAS_METHOD,
                description = "General type of analysis that approximates the 'loc' relationship between memory events.")
        private Alias method = Alias.FIELD_SENSITIVE;

        private Config(Configuration config) throws InvalidConfigurationException {
            config.inject(this);
        }
    }

    final class CombinedAliasAnalysis implements AliasAnalysis {

        private final AliasAnalysis a1;
        private final AliasAnalysis a2;

        private CombinedAliasAnalysis(AliasAnalysis a1, AliasAnalysis a2) {
            this.a1 = a1;
            this.a2 = a2;
        }

        @Override
        public boolean mustAlias(MemoryCoreEvent a, MemoryCoreEvent b) {
            return a1.mustAlias(a, b) || a2.mustAlias(a, b);
        }

        @Override
        public boolean mayAlias(MemoryCoreEvent a, MemoryCoreEvent b) {
            return a1.mayAlias(a, b) && a2.mayAlias(a, b);
        }
    }

}
