package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import static com.dat3m.dartagnan.configuration.OptionNames.ALIAS_METHOD;

public interface AliasAnalysis {

    Logger logger = LogManager.getLogger(AliasAnalysis.class);

    boolean mustAlias(MemEvent a, MemEvent b);
    boolean mayAlias(MemEvent a, MemEvent b);

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

        long t1 = System.currentTimeMillis();
        logger.info("Finished alias analysis in {}ms", t1 - t0);
        return a;
    }

    // This models same_alias_r from the Alloy model
    static boolean virtualLoc(MemEvent e1, MemEvent e2) {
        // TODO: Add support for pointers
        if (!(e1.getAddress() instanceof MemoryObject) || !(e2.getAddress() instanceof MemoryObject)) {
            return false;
        }
        MemoryObject add1 = (MemoryObject) e1.getAddress();
        MemoryObject add2 = (MemoryObject) e2.getAddress();
        boolean isAdd1Virtual = add1.getVirtual();
        boolean isAdd2Virtual = add2.getVirtual();
        if (isAdd1Virtual && isAdd2Virtual) {
            // Virtual addresses always have an alias
            assert(add1.getAlias() != null);
            assert(add2.getAlias() != null);
            // add1, add2 should virtually alias to the same physical Address
            return (add1.getAlias().equals(add2.getAlias()));
        } else if (!isAdd1Virtual && isAdd2Virtual) {
            // Virtual addresses always have an alias
            assert(add2.getAlias() != null);
            // add2 should virtually alias to physical add1
            return add1 == add2.getAlias();
        } else if (isAdd1Virtual && !isAdd2Virtual) {
            // Virtual addresses always have an alias
            assert(add1.getAlias() != null);
            // add1 should virtually alias to physical add2
            return add1.getAlias() == add2;
        } else {
            // The normal AliasAnalysis handles the case where both addresses are physical 
            return false;
        }
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
        public boolean mustAlias(MemEvent a, MemEvent b) {
            return a1.mustAlias(a, b) || a2.mustAlias(a, b);
        }

        @Override
        public boolean mayAlias(MemEvent a, MemEvent b) {
            return a1.mayAlias(a, b) && a2.mayAlias(a, b);
        }
    }

}