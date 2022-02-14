package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.MemEvent;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import static com.dat3m.dartagnan.configuration.OptionNames.ALIAS_METHOD;

public interface AliasAnalysis {

    static final Logger logger = LogManager.getLogger(AliasAnalysis.class);

    boolean mustAlias(MemEvent a, MemEvent b);
    boolean mayAlias(MemEvent a, MemEvent b);

    static AliasAnalysis fromConfig(Program program, Configuration config) throws InvalidConfigurationException {
        InjectionTarget o = new InjectionTarget();
        config.inject(o);
		logger.info("Selected Alias Analysis: " + o.method);
    	switch (o.method) {
		case FIELD_SENSITIVE:
			return FieldSensitiveAndersen.fromConfig(program, config);
		case FIELD_INSENSITIVE:
			return AndersenAliasAnalysis.fromConfig(program, config);
		default:
			throw new UnsupportedOperationException("Alias method not recognized");
		}
    }

    @Options
    final class InjectionTarget {
        @Option(name = ALIAS_METHOD,
                description = "General type of analysis that approximates the 'loc' relationship between memory events.")
        private Alias method = Alias.FIELD_SENSITIVE;
    }
}
