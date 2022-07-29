package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * A simple alias analysis that establishes must-aliases of
 * two events, if they use the same address-expression and
 * the evaluation result of that expression does not change between the two events.
 * NOTE: By itself, this analysis is very imprecise and should only be used in conjunction with a proper alias analysis
 * Also, for better results, constant propagation should get performed first.
 */
public class EqualityAliasAnalysis implements AliasAnalysis {

    private final Map<Tuple, Boolean> cache = new HashMap<>();

    public static EqualityAliasAnalysis fromConfig(Program program, Configuration config) throws InvalidConfigurationException {
        return new EqualityAliasAnalysis();
    }

    @Override
    public boolean mustAlias(MemEvent a, MemEvent b) {
        if (a.getThread() != b.getThread() || !a.getAddress().equals(b.getAddress())) {
            return false;
        } else if (a == b) {
            return true;
        }
        // Normalize direction
        if (a.getCId() > b.getCId()) {
            MemEvent temp = a;
            a = b;
            b = temp;
        }

        // Check cache
        Tuple t = new Tuple(a, b);
        if (cache.containsKey(t)) {
            return cache.get(t);
        }

        // Establish that address expression evaluates to same value at both events.
        Set<Register> addrRegs = a.getAddress().getRegs();
        Event e = a.getSuccessor();
        while (e != b) {
            if (e instanceof RegWriter && addrRegs.contains(((RegWriter)e).getResultRegister())) {
                cache.put(t, Boolean.FALSE);
                return false;
            }
            e = e.getSuccessor();
        }
        cache.put(t, Boolean.TRUE);
        return true;
    }

    @Override
    public boolean mayAlias(MemEvent a, MemEvent b) {
        return true;
    }
}
