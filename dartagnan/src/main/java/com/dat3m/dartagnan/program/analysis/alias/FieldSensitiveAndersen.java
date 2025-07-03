package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.integers.IntBinaryExpr;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.integers.IntSizeCast;
import com.dat3m.dartagnan.expression.integers.IntUnaryExpr;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.threading.ThreadArgument;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.*;
import static com.dat3m.dartagnan.expression.integers.IntUnaryOp.MINUS;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.base.Verify.verify;
import static java.util.stream.Collectors.toList;
import static java.util.stream.IntStream.range;
import static com.dat3m.dartagnan.configuration.Alias.*;

/**
 * Offset- and alignment-enhanced inclusion-based pointer analysis based on Andersen's.
 * This implementation is insensitive to control-flow, but field-sensitive.
 * <p>
 * The edges of the inclusion graph are labeled with sets of offset-alignment pairs.
 * Expressions with well-defined behavior have the form `base [+ constant * register]* + constant`.
 * Bases are either {@link Register variables} or {@link MemoryObject direct references to structures}.
 * Non-conforming expressions are probed for bases, which contribute in the most general manner:
 * Any structure that occurs
 * <p>
 * Structures, that never occurs in any expression, are considered unreachable.
 */
public class FieldSensitiveAndersen implements AliasAnalysis {

    private final Config config;

    private static final TypeFactory types = TypeFactory.getInstance();

    // For providing helpful error messages, this analysis prints call-stack and loop information for events.
    private final Supplier<SyntacticContextAnalysis> synContext;

    ///When a pointer set gains new content, it is added to this queue
    private final LinkedHashSet<Object> variables = new LinkedHashSet<>();

    private final Map<Object, Set<Offset<Object>>> edges = new HashMap<>();
    private final Map<Object, Set<Location>> addresses = new HashMap<>();

    ///Maps registers to result registers of loads that use the register in their address
    private final Map<Object, List<Offset<Register>>> loads = new HashMap<>();
    ///Maps registers to matched value expressions of stores that use the register in their address
    private final Map<Object, List<Offset<Collector>>> stores = new HashMap<>();
    ///Result sets
    private final Map<Event, ImmutableSet<Location>> eventAddressSpaceMap = new HashMap<>();

    // Maps memory events to additional offsets inside their byte range, which may match other accesses' bounds.
    private final Map<MemoryCoreEvent, List<Integer>> mixedAccesses = new HashMap<>();

    // ================================ Construction ================================

    public static FieldSensitiveAndersen fromConfig(Program program, Config config) {
        var analysis = new FieldSensitiveAndersen(program, config);
        analysis.run(program);
        analysis.detectMixedSizeAccesses();
        return analysis;
    }

    private FieldSensitiveAndersen(Program p, Config c) {
        config = checkNotNull(c);
        synContext = Suppliers.memoize(() -> SyntacticContextAnalysis.newInstance(p));
    }

    // ================================ API ================================

    @Override
    public boolean mayAlias(Event x, Event y) {
        return !Sets.intersection(getMaxAddressSet(x), getMaxAddressSet(y)).isEmpty();
    }

    @Override
    public boolean mustAlias(Event x, Event y) {
        Set<Location> a = getMaxAddressSet(x);
        return a.size() == 1 && a.equals(getMaxAddressSet(y));
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
                final MemoryCoreEvent eventY = events.get(j);
                final Set<Location> addresses1 = eventAddressSpaceMap.get(eventY);
                final int bytes1 = types.getMemorySizeInBytes(eventY.getAccessType());
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
            //Tests if addressesX + i may alias addressesY or addressesY + bytesY
            for (Location location1 : addressesY) {
                if (addressesX.contains(new Location(location1.base, location1.offset - i)) ||
                        addressesX.contains(new Location(location1.base, location1.offset - i + bytesY))) {
                    setX.add(i);
                    break;
                }
            }
        }
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

    // ================================ Processing ================================

    private void run(Program program) {
        checkArgument(program.isCompiled(), "The program must be compiled first.");
        for (MemAlloc a : program.getThreadEvents(MemAlloc.class)) {
            eventAddressSpaceMap.put(a, ImmutableSet.of(new Location(a.getAllocatedObject(), 0)));
        }
        List<MemoryCoreEvent> memEvents = program.getThreadEvents(MemoryCoreEvent.class);
        for (MemoryCoreEvent e : memEvents) {
            processLocs(e);
        }
        program.getThreadEvents().forEach(this::processRegs);
        while (!variables.isEmpty()) {
            //TODO replace with removeFirst() when using java 21 or newer
            final Object variable = variables.iterator().next();
            variables.remove(variable);
            algorithm(variable);
        }
        for (MemoryCoreEvent e : memEvents) {
            eventAddressSpaceMap.put(e, getAddressSpace(e));
        }
        for (MemFree f : program.getThreadEvents(MemFree.class)) {
            eventAddressSpaceMap.put(f, getAddressSpace(f));
        }
    }

    protected void processLocs(MemoryCoreEvent e) {
        Collector collector = new Collector(e.getAddress());
        if (e instanceof Load load) {
            Register result = load.getResultRegister();
            for (Offset<Register> r : collector.register()) {
                loads.computeIfAbsent(r.base, k -> new LinkedList<>()).add(new Offset<>(result, r.offset, r.alignment));
            }
            for (Location f : collector.address()) {
                addEdge(f, result, 0, 0);
            }
        } else if (e instanceof Store store) {
            Collector value = new Collector(store.getMemValue());
            for (Offset<Register> r : collector.register()) {
                stores.computeIfAbsent(r.base, k -> new LinkedList<>()).add(new Offset<>(value, r.offset, r.alignment));
            }
            for (Location l : collector.address()) {
                for (Offset<Register> r : value.register()) {
                    addEdge(r.base, l, r.offset, r.alignment);
                }
                addAllAddresses(l, value.address());
            }
        } else {
            // Special MemoryEvents that produce no values (e.g. SRCU) will just get skipped
        }
    }


    protected void processRegs(Event e) {
        if (!(e instanceof Local || e instanceof ThreadArgument || e instanceof MemAlloc)) {
            return;
        }
        assert e instanceof RegWriter;
        final Register register = ((RegWriter) e).getResultRegister();
        final Expression expr;
        if (e instanceof Local local) {
            expr = local.getExpr();
        } else if (e instanceof MemAlloc alloc) {
            expr = alloc.getAllocatedObject();
        } else {
            final ThreadArgument arg = (ThreadArgument) e;
            expr = arg.getCreator().getArguments().get(arg.getIndex());
        }
        final Collector collector = new Collector(expr);
        addAllAddresses(register, collector.address());
        for (Offset<Register> r : collector.register()) {
            addEdge(r.base, register, r.offset, r.alignment);
        }
    }

    protected void algorithm(Object variable) {
        Set<Location> addresses = getAddresses(variable);
        //if variable is a register, there may be loads using it in their address
        for (Offset<Register> load : loads.getOrDefault(variable, List.of())) {
            //if load.offset is not null, the operation accesses variable + load.offset
            for (Location f : fields(addresses, load.offset, load.alignment)) {
                if (addEdge(f, load.base, 0, 0)) {
                    variables.add(f);
                }
            }
        }
        //if variable is a register, there may be stores using it in their address
        for (Offset<Collector> store : stores.getOrDefault(variable, List.of())) {
            for (Location a : fields(addresses, store.offset, store.alignment)) {
                for (Offset<Register> r : store.base.register()) {
                    if (addEdge(r.base, a, r.offset, r.alignment)) {
                        variables.add(r.base);
                    }
                }
                addAllAddresses(a, store.base.address());
            }
        }
        // Process edges
        for (Offset<Object> q : getEdges(variable)) {
            addAllAddresses(q.base, fields(addresses, q.offset, q.alignment));
        }
    }

    protected ImmutableSet<Location> getAddressSpace(Event e) {
        Expression addrExpr;
        if (e instanceof MemoryCoreEvent mce) {
            addrExpr = mce.getAddress();
        } else {
            assert e instanceof MemFree;
            addrExpr = ((MemFree) e).getAddress();
        }
        ImmutableSet.Builder<Location> builder = new ImmutableSet.Builder<>();
        Collector collector = new Collector(addrExpr);
        builder.addAll(collector.address());
        for (Offset<Register> r : collector.register()) {
            builder.addAll(fields(getAddresses(r.base), r.offset, r.alignment));
        }
        Set<Location> set = builder.build();
        if (set.isEmpty()) {
            logger.warn("Empty pointer set for {}", synContext.get().getContextInfo(e));
        }
        return builder.build();
    }

    private record Offset<Base>(Base base, int offset, int alignment) {}

    private record Location(MemoryObject base, int offset) {}

    private static List<Location> fields(Collection<Location> v, int offset, int alignment) {
        final List<Location> result = new ArrayList<>();
        for (Location l : v) {
            if (!l.base.hasKnownSize()) {
                throw new UnsupportedOperationException(String.format("%s alias analysis does not support memory objects of unknown size. " +
                    "You can try the %s alias analysis", FIELD_SENSITIVE, FULL));
            }
            for (int i = 0; i < div(l.base.getKnownSize(), alignment); i++) {
                int mapped = l.offset + offset + i * alignment;
                if (0 <= mapped && mapped < l.base.getKnownSize()) {
                    Location loc = new Location(l.base, mapped);
                    result.add(loc);
                }
            }
        }
        return result;

    }

    private static int div(int p, int q) {
        return q == 0 ? 1 : p / q + (p % q == 0 ? 0 : 1);
    }

    // Describes (constant address or register or zero) + offset + alignment * (variable)
    private record Result(MemoryObject address, Register register, BigInteger offset, int alignment) {
        @Override
        public String toString() {
            return String.format("%s+%s+%dx", address != null ? address : register, offset, alignment);
        }
    }

    private static final class Collector implements ExpressionVisitor<Result> {

        final HashSet<MemoryObject> address = new HashSet<>();
        final HashSet<Register> register = new HashSet<>();
        Result result;

        Collector(Expression x) {
            result = x.accept(this);
        }

        @Override
        public Result visitExpression(Expression expr) {
            return null;
        }

        List<Location> address() {
            if (result != null && result.address != null) {
                verify(address.size() == 1);
                return fields(List.of(new Location(result.address, 0)), result.offset.intValue(), result.alignment);
            }
            return address.stream().flatMap(a -> range(0, a.getKnownSize()).mapToObj(i -> new Location(a, i)))
                    .collect(toList());
        }

        List<Offset<Register>> register() {
            List<Offset<Register>> list = new LinkedList<>();
            Register r = result == null ? null : result.register;
            if (r != null) {
                list.add(new Offset<>(r, result.offset.intValue(), result.alignment));
            }
            register.stream().filter(i -> i != r).map(i -> new Offset<>(i, 0, 1)).forEach(list::add);
            return list;
        }

        @Override
        public Result visitIntBinaryExpression(IntBinaryExpr x) {
            Result l = x.getLeft().accept(this);
            Result r = x.getRight().accept(this);
            if (l == null || r == null || x.getKind() == RSHIFT) {
                return null;
            }
            if (l.address == null && l.register == null && l.alignment == 0 && r.address == null &&
                    r.register == null && r.alignment == 0) {
                // TODO: Make sure that the type of normalization does not break this code.
                //  Maybe always do signed normalization?
                return new Result(null, null,
                        x.getKind().apply(l.offset, r.offset, x.getType().getBitWidth()), 0);
            }
            if (x.getKind() == MUL) {
                if (l.address != null || r.address != null) {
                    return null;
                }
                int lAlign = min(l.alignment, l.register != null ? 1 : 0) * r.offset.intValue();
                int rAlign = min(r.alignment, r.register != null ? 1 : 0) * l.offset.intValue();
                int newAlign = min(lAlign, rAlign);
                BigInteger newOffset = l.offset.multiply(r.offset);
                return new Result(null, null, newOffset, newAlign);
            }
            if (x.getKind() == ADD || x.getKind() == SUB) {
                if (l.address != null && r.address != null) {
                    return null;
                }
                MemoryObject base = l.address != null ? l.address : r.address;
                BigInteger offset = x.getKind() == ADD ? l.offset.add(r.offset) : l.offset.subtract(r.offset);
                if (base != null) {
                    return new Result(base,
                            null,
                            offset,
                            min(min(l.alignment, l.register), min(r.alignment, r.register)));
                }
                if (l.register != null) {
                    return new Result(null, l.register, offset, min(l.alignment, min(r.alignment, r.register)));
                }
                return new Result(null, r.register, offset, min(l.alignment, r.alignment));
            }
            return null;
        }

        @Override
        public Result visitIntUnaryExpression(IntUnaryExpr x) {
            Result i = x.getOperand().accept(this);
            return i == null ? null : x.getKind() != MINUS ? i :
                    new Result(null, null, i.offset.negate(), i.alignment == 0 ? 1 : i.alignment);
        }

        @Override
        public Result visitIntSizeCastExpression(IntSizeCast expr) {
            // We assume type casts do not affect the value of pointers.
            return expr.getOperand().accept(this);
        }

        @Override
        public Result visitITEExpression(ITEExpr x) {
            x.getTrueCase().accept(this);
            x.getFalseCase().accept(this);
            return null;
        }

        @Override
        public Result visitMemoryObject(MemoryObject a) {
            address.add(a);
            return new Result(a, null, BigInteger.ZERO, 0);
        }

        @Override
        public Result visitRegister(Register r) {
            register.add(r);
            return new Result(null, r, BigInteger.ZERO, 0);
        }

        @Override
        public Result visitIntLiteral(IntLiteral v) {
            return new Result(null, null, v.getValue(), 0);
        }

        @Override
        public String toString() {
            return (result != null ? result : Sets.union(register, address)).toString();
        }

        private static int min(int a, int b) {
            return a == 0 || b != 0 && b < a ? b : a;
        }

        private int min(int a, Object b) {
            return b == null || a != 0 ? a : 1;
        }
    }

    private boolean addEdge(Object v1, Object v2, int o, int a) {
        return edges.computeIfAbsent(v1, key -> new HashSet<>()).add(new Offset<>(v2, o, a));
    }

    private Set<Offset<Object>> getEdges(Object v) {
        return edges.getOrDefault(v, ImmutableSet.of());
    }

    private void addAllAddresses(Object v, Collection<Location> s) {
        // NOTE: This method is the most expensive of the whole computation
        if (addresses.computeIfAbsent(v, key -> new HashSet<>()).addAll(s)) {
            variables.add(v);
        }
    }

    private Set<Location> getAddresses(Object v) {
        return addresses.getOrDefault(v, ImmutableSet.of());
    }
}
