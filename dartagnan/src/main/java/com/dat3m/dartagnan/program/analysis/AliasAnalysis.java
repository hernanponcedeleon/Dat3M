package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import static com.dat3m.dartagnan.configuration.OptionNames.ALIAS_METHOD;

public interface AliasAnalysis {

    boolean mustAlias(MemEvent a, MemEvent b);
    boolean mayAlias(MemEvent a, MemEvent b);

    static AliasAnalysis fromConfig(Program program, Configuration config) throws InvalidConfigurationException {
        InjectionTarget o = new InjectionTarget();
        config.inject(o);
        try {
            return (AliasAnalysis)o.method
            .getDeclaredMethod("fromConfig",Program.class,Configuration.class)
            .invoke(null,program,config);
        } catch(ReflectiveOperationException x) {
            throw new InvalidConfigurationException(String.format("invalid %s#fromConfig(%s,%s)",
                    o.method.getName(),
                    Program.class.getSimpleName(),
                    Configuration.class.getSimpleName()),
                x);
        }
    }

    @Options
    final class InjectionTarget {
        @Option(name = ALIAS_METHOD,
                description = "General type of analysis that approximates the 'loc' relationship between memory events.")
        private Class<?extends AliasAnalysis> method = FieldSensitiveAndersen.class;
    }
}
