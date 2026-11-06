package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

/*
    Removes the accesses to memory objects whose value is never observed.
    An object qualifies if it is accessed only by plain (non-atomic) loads and stores whose address is the object itself,
    and every value loaded from it flows, through local assignments only, back into stores to the same object.
    A typical case is a statistics counter `count++` that nothing reads.
    Such an object cannot influence control flow, other memory, or the specification, so its accesses can be removed.
    Its changing value would otherwise prevent the non-termination encoding from finding a repeated iteration.

    The pass runs before compilation: at that point atomic accesses are still dedicated events (e.g. LLVM atomics),
    so the plain Load and Store classes identify non-atomic accesses on every target.
    CAUTION: removing the accesses also removes data races on the object, so the pass is off by default.
 */
public class RemoveWriteOnlyMemory implements ProgramProcessor {

    private static final Logger logger = LoggerFactory.getLogger(RemoveWriteOnlyMemory.class);

    private RemoveWriteOnlyMemory() {}

    public static RemoveWriteOnlyMemory newInstance() {
        return new RemoveWriteOnlyMemory();
    }

    @Override
    public void run(Program program) {
        final Set<Function> functions = new LinkedHashSet<>(program.getFunctions());
        functions.addAll(program.getThreads());
        final List<Event> events = functions.stream().flatMap(f -> f.getEvents().stream()).toList();

        final Set<MemoryObject> observed = new HashSet<>();
        final Set<Register> specRegs = new HashSet<>();
        for (Expression spec : Arrays.asList(program.getSpecification(), program.getFilterSpecification())) {
            if (spec != null) {
                observed.addAll(spec.getMemoryObjects());
                specRegs.addAll(spec.getRegs());
            }
        }
        program.getMemory().getObjects().forEach(o -> o.getInitializedFields()
                .forEach(f -> observed.addAll(o.getInitialValue(f).getMemoryObjects())));

        int removed = 0;
        for (MemoryObject object : program.getMemory().getObjects()) {
            if (!observed.contains(object) && removeIfWriteOnly(object, events, specRegs)) {
                removed++;
            }
        }
        logger.info("Removed the accesses to {} write-only memory objects", removed);
    }

    private boolean removeIfWriteOnly(MemoryObject object, List<Event> events, Set<Register> specRegs) {
        final List<Load> loads = new ArrayList<>();
        final List<Store> stores = new ArrayList<>();
        for (Event e : events) {
            if (!(e instanceof RegReader reader) || !mentions(reader, object)) {
                continue;
            }
            if (e.hasTag(Tag.NOOPT)) {
                return false;
            }
            if (e.getClass() == Load.class && ((Load) e).getAddress().equals(object)) {
                loads.add((Load) e);
            } else if (e.getClass() == Store.class && ((Store) e).getAddress().equals(object)
                    && !((Store) e).getMemValue().getMemoryObjects().contains(object)) {
                stores.add((Store) e);
            } else {
                return false;
            }
        }
        if (loads.isEmpty() && stores.isEmpty()) {
            return false;
        }

        // The registers that carry values loaded from the object, closed under local assignments.
        final Set<Register> carried = new HashSet<>();
        loads.forEach(l -> carried.add(l.getResultRegister()));
        final Set<Local> locals = new HashSet<>();
        boolean changed = true;
        while (changed) {
            changed = false;
            for (Event e : events) {
                if (e instanceof Local local && !locals.contains(local) && readsAny(local, carried)) {
                    locals.add(local);
                    carried.add(local.getResultRegister());
                    changed = true;
                }
            }
        }
        if (carried.stream().anyMatch(specRegs::contains)) {
            return false;
        }

        // Carried values may only reach the chain itself or the value of a store to the object.
        final Set<Event> chain = new HashSet<>(loads);
        chain.addAll(stores);
        chain.addAll(locals);
        for (Event e : events) {
            if (chain.contains(e)) {
                continue;
            }
            if (e instanceof RegReader reader && readsAny(reader, carried)) {
                return false;
            }
            if (e instanceof RegWriter writer && carried.contains(writer.getResultRegister())) {
                return false;
            }
        }

        chain.forEach(Event::forceDelete);
        logger.debug("Removed {} accesses to write-only memory object {}", loads.size() + stores.size(), object);
        return true;
    }

    private static boolean mentions(RegReader reader, MemoryObject object) {
        final boolean[] found = {false};
        reader.transformExpressions(new ExpressionInspector() {
            @Override
            public Expression visitMemoryObject(MemoryObject address) {
                found[0] |= address == object;
                return address;
            }
        });
        return found[0];
    }

    private static boolean readsAny(RegReader reader, Set<Register> registers) {
        return reader.getRegisterReads().stream().map(Register.Read::register).anyMatch(registers::contains);
    }
}
