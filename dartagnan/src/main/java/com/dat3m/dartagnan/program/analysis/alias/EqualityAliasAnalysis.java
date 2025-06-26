package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;

import java.util.List;
import java.util.Set;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * A simple alias analysis that establishes must-aliases of
 * two events, if they use the same address-expression and
 * the evaluation result of that expression does not change between the two events.
 * NOTE: By itself, this analysis is very imprecise and should only be used in conjunction with a proper alias analysis
 * Also, for better results, constant propagation should get performed first.
 */
public class EqualityAliasAnalysis implements AliasAnalysis {

    private final Config config;

    private final MutableEventGraph trueSet = new MapEventGraph();
    private final MutableEventGraph falseSet = new MapEventGraph();

    public static EqualityAliasAnalysis fromConfig(Program program, Config config) {
        return new EqualityAliasAnalysis(config);
    }

    private EqualityAliasAnalysis(Config c) {
        config = checkNotNull(c);
    }

    @Override
    public boolean mayAlias(Event a, Event b) {
        return true;
    }

    @Override
    public boolean mustAlias(Event a, Event b) {
        Expression addrA = getAddress(a);
        Expression addrB = getAddress(b);
        if (a.getFunction() != b.getFunction() || !addrA.equals(addrB)) {
            return false;
        } else if (a == b) {
            return true;
        }
        // Normalize direction
        if (a.getGlobalId() > b.getGlobalId()) {
            Event temp = a;
            a = b;
            b = temp;
        }

        // Check cache
        if (trueSet.contains(a, b)) {
            return true;
        }
        if (falseSet.contains(a, b)) {
            return false;
        }

        // Establish that address expression evaluates to same value at both events.
        Set<Register> addrRegs = addrA.getRegs();
        Event e = a.getSuccessor();
        while (e != b) {
            if (e instanceof RegWriter rw && addrRegs.contains(rw.getResultRegister())) {
                falseSet.add(a, b);
                return false;
            }
            e = e.getSuccessor();
        }
        trueSet.add(a, b);
        return true;
    }

    @Override
    public boolean mayObjectAlias(Event a, Event b) {
        return true;
    }

    @Override
    public boolean mustObjectAlias(Event a, Event b) {
        return false;
    }

    private Expression getAddress(Event e) {
        if (e instanceof MemoryCoreEvent me) {
            return me.getAddress();
        } else if (e instanceof MemFree f) {
            return f.getAddress();
        } else if (e instanceof MemAlloc a) {
            return a.getAllocatedObject();
        } else {
            throw new UnsupportedOperationException("Event type has no address: " + e.getClass().getSimpleName());
        }
    }

    @Override
    public List<Integer> mayMixedSizeAccesses(MemoryCoreEvent event) {
        return config.defaultMayMixedSizeAccesses(event);
    }
}
