package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;
import com.google.common.base.Verify;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.expression.op.IOpBin.ADD;

/**
 * Inclusion-based pointer analysis by Andersen.
 * <p>
 * Each register and memory location gets a variable set of pointers.
 * A graph denotes inclusion relationships between pointer sets.
 * Iteratively, the sets of pointers are populated based on this graph.
 * Memory operations can generate new edges during the process.
 *
 * @author flo
 * @author xeren
 */
public class AndersenAliasAnalysis implements AliasAnalysis {

    ///When a pointer set gains new content, it is added to this queue
    private final Queue<Object> variables = new ArrayDeque<>();
    ///Super set of all pointer sets in this analysis
    private final ImmutableSet<Location> maxAddressSet;
    private final Map<Object, Set<Object>> edges = new HashMap<>();
    private final Map<Object, Set<Location>> addresses = new HashMap<>();
    private final Map<Register, Set<MemoryEvent>> events = new HashMap<>();
    private final Map<Register, Set<Location>> targets = new HashMap<>();
    private final Map<MemoryEvent, ImmutableSet<Location>> eventAddressSpaceMap = new HashMap<>();

    // ================================ Construction ================================

    private AndersenAliasAnalysis(Program program) {
        Preconditions.checkArgument(program.isCompiled(), "The program must be compiled first.");
        ImmutableSet.Builder<Location> builder = new ImmutableSet.Builder<>();
        for (MemoryObject a : program.getMemory().getObjects()) {
            for (int i = 0; i < a.size(); i++) {
                builder.add(new Location(a, i));
            }
        }
        maxAddressSet = builder.build();
        run(program);
    }

    public static AndersenAliasAnalysis fromConfig(Program program, Configuration config) throws InvalidConfigurationException {
        return new AndersenAliasAnalysis(program);
    }

    // ================================ API ================================

    @Override
    public boolean mayAlias(MemoryCoreEvent x, MemoryCoreEvent y) {
        return !Sets.intersection(getMaxAddressSet(x), getMaxAddressSet(y)).isEmpty();
    }

    @Override
    public boolean mustAlias(MemoryCoreEvent x, MemoryCoreEvent y) {
        return getMaxAddressSet(x).size() == 1 && getMaxAddressSet(x).containsAll(getMaxAddressSet(y));
    }

    private ImmutableSet<Location> getMaxAddressSet(MemoryEvent e) {
        return eventAddressSpaceMap.get(e);
    }

    // ================================ Processing ================================

    private void run(Program program) {
        List<MemoryCoreEvent> memEvents = program.getThreadEvents(MemoryCoreEvent.class);
        List<Local> locals = program.getThreadEvents(Local.class);
        for (MemoryCoreEvent e : memEvents) {
            processLocs(e);
        }
        //FIXME: Add handling for thread parameters (or get rid of this class)
        for (Local e : locals) {
            processRegs(e);
        }
        algorithm();
        for (Local e : locals) {
            processResults(e);
        }
        for (MemoryCoreEvent e : memEvents) {
            processResults(e);
        }
    }

    private void processLocs(MemoryCoreEvent e) {
        Expression address = e.getAddress();
        // Collect for each v events of form: p = *v, *v = q
        if (address instanceof Register register) {
            addEvent(register, e);
            return;
        }
        Constant addressConstant = new Constant(address);
        if (addressConstant.failed) {
            // r = *(CompExpr) -> loc(r) = max
            if (e instanceof RegWriter rw) {
                Register register = rw.getResultRegister();
                addAllAddresses(register, maxAddressSet);
                variables.add(register);
            }
            //FIXME if e is a store event, then all locations should include its values
            eventAddressSpaceMap.put(e, maxAddressSet);
            return;
        }
        //address is a constant
        Location location = addressConstant.location;
        if (location == null) {
            throw new RuntimeException("memory event accessing a pure constant address");
        }
        eventAddressSpaceMap.put(e, ImmutableSet.of(location));
        if (e instanceof RegWriter rw) {
            addEdge(location, rw.getResultRegister());
            return;
        }
        //event is a store operation
        Verify.verify(e instanceof Store,
                "Encountered memory event that is neither store nor load: {}", e);
        Expression value = ((Store)e).getMemValue();
        if (value instanceof Register) {
            addEdge(value, location);
            return;
        }
        Constant v = new Constant(value);
        if (v.failed) {
            addAllAddresses(location, maxAddressSet);
        } else if (v.location != null) {
            addAddress(location, v.location);
        }
        variables.add(location);
    }

    private void processRegs(Local e) {
        Register register = e.getResultRegister();
        Expression expr = e.getExpr();
        if (expr instanceof Register) {
            // r1 = r2 -> add edge r2 --> r1
            addEdge(expr, register);
        } else if (expr instanceof IExprBin iBin && iBin.getLHS() instanceof Register) {
            addAllAddresses(register, maxAddressSet);
            variables.add(register);
        } else if (expr instanceof MemoryObject mem) {
            // r = &a
            addAddress(register, new Location(mem, 0));
            variables.add(register);
        }
        //FIXME if the expression is too complicated, the register should receive maxAddressSet
    }

    private void algorithm() {
        while (!variables.isEmpty()) {
            Object variable = variables.poll();
            if (variable instanceof Register reg) {
                // Process rules with *variable:
                for (Location address : getAddresses(variable)) {
                    for (MemoryEvent e : getEvents(reg)) {
                        // p = *variable:
                        if (e instanceof RegWriter rw) {
                            // Add edge from location to p
                            if (addEdge(address, rw.getResultRegister())) {
                                // Add location to variables if edge is new.
                                variables.add(address);
                            }
                        } else if (e instanceof Store store && store.getMemValue() instanceof Register register) {
                            // *variable = register
                            // Add edge from register to location
                            if (addEdge(register, address)) {
                                // Add register to variables if edge is new.
                                variables.add(register);
                            }
                        }
                    }
                }
            }
            // Process edges
            for (Object q : getEdges(variable)) {
                if (addAllAddresses(q, getAddresses(variable))) {
                    variables.add(q);
                }
            }
        }
    }

    private void processResults(Local e) {
        Expression exp = e.getExpr();
        Register reg = e.getResultRegister();
        if (exp instanceof MemoryObject mem) {
            addTarget(reg, new Location(mem, 0));
            return;
        }
        if (!(exp instanceof IExprBin iBin)) {
            return;
        }
        Expression base = iBin.getLHS();
        if (base instanceof MemoryObject mem) {
            Expression rhs = iBin.getRHS();
            //FIXME Address extends IConst
            if (rhs instanceof IConst ic) {
                addTarget(reg, new Location(mem, ic.getValueAsInt()));
            } else {
                addTargetArray(reg, (MemoryObject) base);
            }
            return;
        }
        if (!(base instanceof Register)) {
            return;
        }
        //accept register2 = register1 + constant
        for (Location target : targets.getOrDefault(base, Set.of())) {
            Expression rhs = ((IExprBin) exp).getRHS();
            //FIXME Address extends IConst
            if (rhs instanceof IConst ic) {
                int o = target.offset + ic.getValueAsInt();
                if (o < target.base.size()) {
                    addTarget(reg, new Location(target.base, o));
                }
            } else {
                addTargetArray(reg, target.base);
            }
        }
    }

    private void processResults(MemoryCoreEvent e) {
        Expression address = e.getAddress();
        Set<Location> addresses;
        if (address instanceof Register) {
            Set<Location> target = targets.get(address);
            addresses = target != null ? target : getAddresses(address);
        } else {
            Constant addressConstant = new Constant(address);
            if (addressConstant.failed) {
                addresses = maxAddressSet;
            } else {
                Verify.verify(addressConstant.location != null, "memory event accessing a pure constant address");
                addresses = ImmutableSet.of(addressConstant.location);
            }
        }
        if (addresses.size() == 0) {
            addresses = maxAddressSet;
        }
        eventAddressSpaceMap.put(e, ImmutableSet.copyOf(addresses));
    }

    private static final class Constant {

        final Location location;
        //implies location == null
        final boolean failed;

        /**
         * Tries to match an expression as a constant address.
         */
        Constant(Expression x) {
            if (x instanceof IConst) {
                location = x instanceof MemoryObject mem ? new Location(mem, 0) : null;
                failed = false;
                return;
            }
            if (x instanceof IExprBin iBin && iBin.getOp() == ADD) {
                Expression lhs = iBin.getLHS();
                Expression rhs = iBin.getRHS();
                if (lhs instanceof MemoryObject mem && rhs instanceof IConst ic && !(rhs instanceof MemoryObject)) {
                    location = new Location(mem, ic.getValueAsInt());
                    failed = false;
                    return;
                }
            }
            location = null;
            failed = true;
        }

        @Override
        public String toString() {
            return failed ? "failed" : String.valueOf(location);
        }
    }

    private static final class Location {

        final MemoryObject base;
        final int offset;

        Location(MemoryObject b, int o) {
            Preconditions.checkArgument(0 <= o && o < b.size(), "Array out of bounds");
            base = b;
            offset = o;
        }

        @Override
        public int hashCode() {
            return base.hashCode() + offset;
        }

        @Override
        public boolean equals(Object o) {
            return this == o || o instanceof Location loc && base.equals(loc.base) && offset == loc.offset;
        }

        @Override
        public String toString() {
            return String.format("%s[%d]", base, offset);
        }
    }

    private boolean addEdge(Object v1, Object v2) {
        return edges.computeIfAbsent(v1, key -> new HashSet<>()).add(v2);
    }

    private Set<Object> getEdges(Object v) {
        return edges.getOrDefault(v, ImmutableSet.of());
    }

    private void addAddress(Object v, Location a) {
        addresses.computeIfAbsent(v, key -> new HashSet<>()).add(a);
    }

    private boolean addAllAddresses(Object v, Set<Location> s) {
        return addresses.computeIfAbsent(v, key -> new HashSet<>()).addAll(s);
    }

    private Set<Location> getAddresses(Object v) {
        return addresses.getOrDefault(v, ImmutableSet.of());
    }

    private void addEvent(Register r, MemoryEvent e) {
        events.computeIfAbsent(r, key -> new HashSet<>()).add(e);
    }

    private Set<MemoryEvent> getEvents(Register r) {
        return events.getOrDefault(r, ImmutableSet.of());
    }

    private void addTarget(Register r, Location l) {
        targets.put(r, Set.of(l));
    }

    private void addTargetArray(Register r, MemoryObject b) {
        targets.put(r, IntStream.range(0, b.size())
                .mapToObj(i -> new Location(b, i))
                .collect(Collectors.toSet()));
    }
}
