package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;

import java.util.Collection;
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
    private final Set<MemoryObject> allObjects;

    private final MutableEventGraph trueSet = new MapEventGraph();
    private final MutableEventGraph falseSet = new MapEventGraph();

    public static EqualityAliasAnalysis fromConfig(Program program, Config config) {
        return new EqualityAliasAnalysis(program, config);
    }

    private EqualityAliasAnalysis(Program p, Config c) {
        config = checkNotNull(c);
        allObjects = p.getMemory().getObjects();
    }

    @Override
    public boolean mustAlias(MemoryCoreEvent a, MemoryCoreEvent b) {

        if (a.getFunction() != b.getFunction()
                || !a.getAddress().equals(b.getAddress())) {
            return false;
        } else if (a == b) {
            return true;
        }
        // Normalize direction
        if (a.getGlobalId() > b.getGlobalId()) {
            MemoryCoreEvent temp = a;
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
        Set<Register> addrRegs = a.getAddress().getRegs();
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
    public boolean mayAlias(MemoryCoreEvent a, MemoryCoreEvent b) {
        return true;
    }

    @Override
    public Collection<MemoryObject> addressableObjects(MemoryCoreEvent a) {
        return allObjects;
    }

    @Override
    public Collection<MemoryObject> communicableObjects(MemoryCoreEvent a) {
        final int size = a.getAccessType() instanceof IntegerType t ? t.getBitWidth() : 0;
        return size < 64 ? Set.of() : allObjects;
    }

    @Override
    public List<Integer> mayMixedSizeAccesses(MemoryCoreEvent event) {
        return config.defaultMayMixedSizeAccesses(event);
    }
}
