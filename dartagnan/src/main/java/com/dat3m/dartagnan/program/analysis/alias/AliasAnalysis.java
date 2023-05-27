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

    // GPU memory models make use of virtual addresses.
    // This models same_alias_r from the PTX Alloy model
    // There are 4 cases to consider ("alias" below refers to the syntax  
    // used when allocating memory in the preamble of the litmus test).
    // (1) - both addresses are virtual: they should both alias to the same physical address
    // (2,3) - one virtual, one physical: the virtual should alias to the physical one
    // (4) - both addresses are physical: the traditional alias analysis handles this

    static boolean virtuallyAlias(MemEvent e1, MemEvent e2) {
        // TODO: Add support for pointers, i.e. if `x` and `y` virtually alias, 
        // then `x + offset` and `y + offset` should too
        if (!(e1.getAddress() instanceof MemoryObject) || !(e2.getAddress() instanceof MemoryObject)) {
            return false;
        }
        MemoryObject add1 = (MemoryObject) e1.getAddress();
        MemoryObject add2 = (MemoryObject) e2.getAddress();
        boolean isAdd1Virtual = add1.isVirtual();
        boolean isAdd2Virtual = add2.isVirtual();
        if (isAdd1Virtual && isAdd2Virtual) {
            // Case (1)
            // Virtual addresses always have an alias
            assert(add1.getAlias() != null);
            assert(add2.getAlias() != null);
            // add1, add2 should virtually alias to the same physical Address
            return (add1.getAlias().equals(add2.getAlias()));
        } else if (!isAdd1Virtual && isAdd2Virtual) {
            // Case (2)
            // Virtual addresses always have an alias
            assert(add2.getAlias() != null);
            // add2 should virtually alias to physical add1
            return add1 == add2.getAlias();
        } else if (isAdd1Virtual && !isAdd2Virtual) {
            // Case (3)
            // Virtual addresses always have an alias
            assert(add1.getAlias() != null);
            // add1 should virtually alias to physical add2
            return add1.getAlias() == add2;
        } else {
            // Case (4)
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
