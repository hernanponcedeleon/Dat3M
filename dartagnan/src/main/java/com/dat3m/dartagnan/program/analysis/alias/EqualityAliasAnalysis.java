package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableEventGraph;
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

    private final ImmutableEventGraph trueSet;

    public static EqualityAliasAnalysis fromConfig(Program program, Config config) {
        return new EqualityAliasAnalysis(program, config);
    }

    private EqualityAliasAnalysis(Program program, Config c) {
        config = checkNotNull(c);
        // Precompute
        final MutableEventGraph tSet = new MapEventGraph();
        for (final Function f : program.getFunctions()) {
            final List<MemoryCoreEvent> events = f.getEvents(MemoryCoreEvent.class);
            for (int i = 0; i < events.size(); ++i) {
                final MemoryCoreEvent a = events.get(i);
                for (int j = i + 1; j < events.size(); ++j) {
                    final MemoryCoreEvent b = events.get(j);
                    if (a.getAddress().equals(b.getAddress()) && regNotModified(a, b)) {
                        tSet.add(a, b);
                        tSet.add(b, a);
                    }
                }
            }
        }
        trueSet = ImmutableEventGraph.from(tSet);
    }

    @Override
    public boolean mayAlias(MemoryCoreEvent a, MemoryCoreEvent b) {
        return true;
    }

    @Override
    public boolean mustAlias(MemoryCoreEvent a, MemoryCoreEvent b) {
        return (a == b) || trueSet.contains(a, b);
    }

    @Override
    public boolean mayObjectAlias(MemoryCoreEvent a, MemoryCoreEvent b) {
        return true;
    }

    @Override
    public boolean mustObjectAlias(MemoryCoreEvent a, MemoryCoreEvent b) {
        return false;
    }

    @Override
    public List<Integer> mayMixedSizeAccesses(MemoryCoreEvent event) {
        return config.defaultMayMixedSizeAccesses(event);
    }

    private boolean regNotModified(MemoryCoreEvent a, MemoryCoreEvent b) {
        final Expression addrA = a.getAddress();
        assert (addrA.equals(b.getAddress()) && a.getFunction() == b.getFunction());
        // Establish that address expression evaluates to same value at both events.
        Set<Register> addrRegs = addrA.getRegs();
        Event e = a.getSuccessor();
        while (e != b) {
            if (e instanceof RegWriter rw && addrRegs.contains(rw.getResultRegister())) {
                return false;
            }
            e = e.getSuccessor();
        }
        return true;
    }
}
