package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryExpr;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;
import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;
import com.google.common.base.Verify;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.ADD;
import static com.dat3m.dartagnan.configuration.Alias.*;

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

    private final AliasAnalysis.Config config;

    private static final TypeFactory types = TypeFactory.getInstance();

    // For providing helpful error messages, this analysis prints call-stack and loop information for events.
    private final Supplier<SyntacticContextAnalysis> synContext;

    ///When a pointer set gains new content, it is added to this queue
    private final Queue<Object> variables = new ArrayDeque<>();
    ///Super set of all pointer sets in this analysis
    private final ImmutableSet<Location> maxAddressSet;
    private final Map<Object, Set<Object>> edges = new HashMap<>();
    private final Map<Object, Set<Location>> addresses = new HashMap<>();
    private final Map<Register, Set<MemoryEvent>> events = new HashMap<>();
    private final Map<Register, Set<Location>> targets = new HashMap<>();
    private final Map<Event, ImmutableSet<Location>> eventAddressSpaceMap = new HashMap<>();
    // Maps memory events to additional offsets inside their byte range, which may match other accesses' bounds.
    private final Map<MemoryCoreEvent, List<Integer>> mixedAccesses = new HashMap<>();

    // ================================ Construction ================================

    private AndersenAliasAnalysis(Program program, Config c) {
        Preconditions.checkArgument(program.isCompiled(), "The program must be compiled first.");
        config = c;
        synContext = Suppliers.memoize(() -> SyntacticContextAnalysis.newInstance(program));
        ImmutableSet.Builder<Location> builder = new ImmutableSet.Builder<>();
        for (MemoryObject a : program.getMemory().getObjects()) {
            if (!a.hasKnownSize()) {
                throw new UnsupportedOperationException(String.format("%s alias analysis does not support memory objects of unknown size. " +
                    "You can try the %s alias analysis", FIELD_INSENSITIVE, FULL));
            }
            for (int i = 0; i < a.getKnownSize(); i++) {
                builder.add(new Location(a, i));
            }
        }
        maxAddressSet = builder.build();
        run(program);
        detectMixedSizeAccesses();
    }

    public static AndersenAliasAnalysis fromConfig(Program program, Config config) {
        return new AndersenAliasAnalysis(program, config);
    }

    // ================================ API ================================

    @Override
    public boolean mayAlias(Event x, Event y) {
        return !Sets.intersection(getMaxAddressSet(x), getMaxAddressSet(y)).isEmpty();
    }

    @Override
    public boolean mustAlias(Event x, Event y) {
        Set<Location> lx = getMaxAddressSet(x);
        return lx.size() == 1 && lx.equals(getMaxAddressSet(y));
    }

    @Override
    public boolean mayObjectAlias(Event a, Event b) {
        return !Sets.intersection(getAccessibleObjects(a), getAccessibleObjects(b)).isEmpty();
    }

    @Override
    public boolean mustObjectAlias(Event a, Event b) {
        Set<MemoryObject> objsA = getAccessibleObjects(a);
        return objsA.size() == 1 && objsA.equals(getAccessibleObjects(b));
    }

    @Override
    public List<Integer> mayMixedSizeAccesses(MemoryCoreEvent event) {
        final List<Integer> result = mixedAccesses.get(event);
        if (result != null) {
            return Collections.unmodifiableList(result);
        }
        final int bytes = types.getMemorySizeInBytes(event.getAccessType());
        return IntStream.range(1, bytes).boxed().toList();
    }

    private ImmutableSet<Location> getMaxAddressSet(Event e) {
        return eventAddressSpaceMap.get(e);
    }

    private Set<MemoryObject> getAccessibleObjects(Event e) {
        Set<MemoryObject> objs = new HashSet<>();
        Set<Location> locs = getMaxAddressSet(e);
        if (locs != null) {
            locs.stream().forEach(l -> objs.add(l.base));
        }
        return objs;
    }

    // ================================ Mixed Size Access Detection ================================

    private void detectMixedSizeAccesses() {
        if (!config.detectMixedSizeAccesses) {
            return;
        }
        final List<MemoryCoreEvent> events = eventAddressSpaceMap.keySet().stream()
                .filter(e -> e instanceof MemoryCoreEvent)
                .map(e -> (MemoryCoreEvent) e).collect(Collectors.toList());
        final List<Set<Integer>> offsets = new ArrayList<>();
        for (int i = 0; i < events.size(); i++) {
            final var set0 = new HashSet<Integer>();
            final MemoryCoreEvent event0 = events.get(i);
            final Set<Location> addresses0 = eventAddressSpaceMap.get(event0);
            final int bytes0 = types.getMemorySizeInBytes(event0.getAccessType());
            for (int j = 0; j < i; j++) {
                final MemoryCoreEvent event1 = events.get(j);
                final Set<Location> addresses1 = eventAddressSpaceMap.get(event1);
                final int bytes1 = types.getMemorySizeInBytes(event1.getAccessType());
                fetchMixedOffsets(set0, addresses0, bytes0, addresses1, bytes1);
                fetchMixedOffsets(offsets.get(j), addresses1, bytes1, addresses0, bytes0);
            }
            offsets.add(set0);
        }
        for (int i = 0; i < events.size(); i++) {
            mixedAccesses.put(events.get(i), offsets.get(i).stream().sorted().toList());
        }
    }

    private void fetchMixedOffsets(Set<Integer> setX, Set<Location> addressesX, int bytesX, Set<Location> addressesY, int bytesY) {
        for (int i = 1; i < bytesX; i++) {
            for (Location location1 : addressesY) {
                if (addressesX.contains(new Location(location1.base, location1.offset - i)) ||
                        addressesX.contains(new Location(location1.base, location1.offset - i + bytesY))) {
                    setX.add(i);
                    break;
                }
            }
        }
    }

    // ================================ Processing ================================

    private void run(Program program) {
        List<MemoryCoreEvent> memEvents = program.getThreadEvents(MemoryCoreEvent.class);
        List<Local> locals = program.getThreadEvents(Local.class);
        for (MemAlloc a : program.getThreadEvents(MemAlloc.class)) {
            processAllocs(a);
        }
        for (MemoryCoreEvent e : memEvents) {
            processLocs(e);
        }
        //FIXME: Add handling for thread parameters and allocations (or get rid of this class)
        for (Local e : locals) {
            processRegs(e);
        }
        algorithm();
        for (Local e : locals) {
            processResults(e);
        }
        for (MemoryCoreEvent e : memEvents) {
            eventAddressSpaceMap.put(e, ImmutableSet.copyOf(getAddressSpace(e)));
        }
        for (MemFree f : program.getThreadEvents(MemFree.class)) {
            eventAddressSpaceMap.put(f, ImmutableSet.copyOf(getAddressSpace(f)));
        }
    }

    private void processAllocs(MemAlloc a) {
        Register r = a.getResultRegister();
        Location base = new Location(a.getAllocatedObject(), 0);
        eventAddressSpaceMap.put(a, ImmutableSet.of(base));
        addAddress(r, base);
        variables.add(r);
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
        } else if (expr instanceof IntBinaryExpr iBin && iBin.getLeft() instanceof Register) {
            addAllAddresses(register, maxAddressSet);
            variables.add(register);
        } else if (expr instanceof MemoryObject mem) {
            // r = &a
            addAddress(register, new Location(mem, 0));
            variables.add(register);
        } else {
            addAllAddresses(register, maxAddressSet);
        }
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
        if (!(exp instanceof IntBinaryExpr iBin)) {
            return;
        }
        Expression base = iBin.getLeft();
        if (base instanceof MemoryObject mem) {
            Expression rhs = iBin.getRight();
            if (rhs instanceof IntLiteral ic) {
                addTarget(reg, new Location(mem, ic.getValueAsInt()));
            } else {
                addTargetArray(reg, mem);
            }
            return;
        }
        if (!(base instanceof Register)) {
            return;
        }
        //accept register2 = register1 + constant
        for (Location target : targets.getOrDefault(base, Set.of())) {
            Expression rhs = iBin.getRight();
            if (rhs instanceof IntLiteral ic) {
                int o = target.offset + ic.getValueAsInt();
                if (o < target.base.getKnownSize()) {
                    addTarget(reg, new Location(target.base, o));
                }
            } else {
                addTargetArray(reg, target.base);
            }
        }
    }

    private Set<Location> getAddressSpace(Event e) {
        Expression addrExpr;
        if (e instanceof MemoryCoreEvent mce) {
            addrExpr = mce.getAddress();
        } else {
            assert e instanceof MemFree;
            addrExpr = ((MemFree) e).getAddress();
        }
        Set<Location> addresses;
        if (addrExpr instanceof Register) {
            Set<Location> target = targets.get(addrExpr);
            addresses = target != null ? target : getAddresses(addrExpr);
        } else {
            Constant addressConstant = new Constant(addrExpr);
            if (addressConstant.failed) {
                addresses = maxAddressSet;
            } else {
                Verify.verify(addressConstant.location != null, "accessing a pure constant address");
                addresses = ImmutableSet.of(addressConstant.location);
            }
        }
        if (addresses.isEmpty()) {
            logger.warn("Empty pointer set for {}", synContext.get().getContextInfo(e));
            addresses = maxAddressSet;
        }
        return addresses;
    }

    private static final class Constant {

        final Location location;
        //implies location == null
        final boolean failed;

        /**
         * Tries to match an expression as a constant address.
         */
        Constant(Expression x) {
            if (x instanceof MemoryObject mem) {
                location = new Location(mem, 0);
                failed = false;
                return;
            }
            if (x instanceof IntLiteral) {
                location = null;
                failed = false;
                return;
            }
            if (x instanceof IntBinaryExpr iBin && iBin.getKind() == ADD) {
                Expression lhs = iBin.getLeft();
                Expression rhs = iBin.getRight();
                if (lhs instanceof MemoryObject mem && rhs instanceof IntLiteral ic) {
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

    private record Location(MemoryObject base, int offset) {}

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
        targets.put(r, IntStream.range(0, b.getKnownSize())
                .mapToObj(i -> new Location(b, i))
                .collect(Collectors.toSet()));
    }
}
