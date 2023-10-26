package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.threading.ThreadArgument;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.math.BigInteger;
import java.util.*;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Verify.verify;
import static java.util.stream.Collectors.toList;
import static java.util.stream.IntStream.range;

/**
 * Offset- and alignment-enhanced inclusion-based pointer analysis based on Andersen's.
 * This implementation is insensitive to control-flow, but field-sensitive.
 * <p>
 * The edges of the inclusion graph are labeled with sets of offset-alignment pairs.
 * Expressions with well-defined behavior have the form `base [+ constant * register]* + constant`.
 * Bases are either {@link Register variables} or {@link MemoryObject direct references to structures}.
 * Non-conforming expressions are probed for bases, which abide to the following rule:
 * Any object that taints the non-conforming expression can be accessed at any offset.
 * All other objects will be considered inaccessible from the expression.
 */
public class FieldSensitiveAndersen implements AliasAnalysis {

    ///When a pointer set gains new content, it is added to this queue
    private final Queue<Object> variables = new ArrayDeque<>();

    private final Map<Object, Set<Offset<Object>>> edges = new HashMap<>();
    private final Map<Object, Set<Location>> addresses = new HashMap<>();

    ///Maps registers to result registers of loads that use the register in their address
    private final Map<Object, List<Offset<Register>>> loads = new HashMap<>();
    ///Maps registers to matched value expressions of stores that use the register in their address
    private final Map<Object, List<Offset<Collector>>> stores = new HashMap<>();
    ///Result sets
    private final Map<MemoryEvent, ImmutableSet<Location>> eventAddressSpaceMap = new HashMap<>();

    // ================================ Construction ================================

    public static FieldSensitiveAndersen fromConfig(Program program, Configuration config) throws InvalidConfigurationException {
        return new FieldSensitiveAndersen(program);
    }

    private FieldSensitiveAndersen(Program program) {
        checkArgument(program.isCompiled(), "The program must be compiled first.");
        List<MemoryCoreEvent> memEvents = program.getThreadEvents(MemoryCoreEvent.class);
        for (MemoryCoreEvent e : memEvents) {
            processLocs(e);
        }
        program.getThreadEvents().forEach(this::processRegs);
        while (!variables.isEmpty()) {
            algorithm(variables.poll());
        }
        for (MemoryCoreEvent e : memEvents) {
            processResults(e);
        }
    }

    // ================================ API ================================

    @Override
    public boolean mayAlias(MemoryCoreEvent x, MemoryCoreEvent y) {
        return !Sets.intersection(getMaxAddressSet(x), getMaxAddressSet(y)).isEmpty();
    }

    @Override
    public boolean mustAlias(MemoryCoreEvent x, MemoryCoreEvent y) {
        Set<Location> a = getMaxAddressSet(x);
        return a.size() == 1 && a.containsAll(getMaxAddressSet(y));
    }

    private ImmutableSet<Location> getMaxAddressSet(MemoryEvent e) {
        return eventAddressSpaceMap.get(e);
    }

    // ================================ Processing ================================

    protected void processLocs(MemoryCoreEvent e) {
        Collector collector = new Collector(e.getAddress());
        if (e instanceof Load load) {
            Register result = load.getResultRegister();
            for (Offset<Register> r : collector.register()) {
                loads.computeIfAbsent(r.base, k -> new LinkedList<>())
                        .add(new Offset<>(result, r.offset, r.alignment));
            }
            for (Location f : collector.address()) {
                addEdge(f, result, 0, 0);
            }
        } else if (e instanceof Store store) {
            Collector value = new Collector(store.getMemValue());
            for (Offset<Register> r : collector.register()) {
                stores.computeIfAbsent(r.base, k -> new LinkedList<>())
                        .add(new Offset<>(value, r.offset, r.alignment));
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
        if (!(e instanceof Local || e instanceof ThreadArgument)) {
            return;
        }
        assert e instanceof RegWriter;
        final Register register = ((RegWriter) e).getResultRegister();
        final Expression expr;
        if (e instanceof Local local) {
            expr = local.getExpr();
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

    protected void processResults(MemoryCoreEvent e) {
        ImmutableSet.Builder<Location> addresses = ImmutableSet.builder();
        Collector collector = new Collector(e.getAddress());
        addresses.addAll(collector.address());
        for (Offset<Register> r : collector.register()) {
            addresses.addAll(fields(getAddresses(r.base), r.offset, r.alignment));
        }
        eventAddressSpaceMap.put(e, addresses.build());
    }

    private record Offset<Base>(Base base, int offset, int alignment) {}

    private record Location(MemoryObject base, int offset) {}

    private static List<Location> fields(Collection<Location> v, int offset, int alignment) {
        final List<Location> result = new ArrayList<>();
        for (Location l : v) {
            for (int i = 0; i < div(l.base.getSizeInBytes(), alignment); i++) {
                int mapped = l.offset + offset + i * alignment;
                if (0 <= mapped && mapped < l.base.getSizeInBytes()) {
                    result.add(new Location(l.base, mapped));
                }
            }
        }
        return result;

    }

    private static int div(int p, int q) {
        return q == 0 ? 1 : p / q + (p % q == 0 ? 0 : 1);
    }

    //Invariant: address == null || register == null
    private record Result(MemoryObject address, Register register, BigInteger offset, int alignment) {}

    private static final class Collector implements ExpressionVisitor<Result> {

        final Set<MemoryObject> address;
        final Set<Register> register;
        Result result;

        Collector(Expression x) {
            var memoryObjects = new MemoryObject.Collector();
            x.accept(memoryObjects);
            address = memoryObjects.getCollection();
            register = x.getRegs();
            result = x.accept(this);
        }

        List<Location> address() {
            if (result != null && result.address != null) {
                verify(address.size() == 1);
                return fields(List.of(new Location(result.address, 0)), result.offset.intValue(), result.alignment);
            }
            return address.stream().flatMap(a -> range(0, a.getSizeInBytes()).mapToObj(i -> new Location(a, i))).collect(toList());
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
        public Result visit(MemoryObject a) {
            return new Result(a, null, BigInteger.ZERO, 0);
        }

        @Override
        public Result visit(Register r) {
            return new Result(null, r, BigInteger.ZERO, 0);
        }

        @Override
        public Result visit(IValue v) {
            return new Result(null, null, v.getValue(), 0);
        }

        @Override
        public Result visit(GEPExpression gep) {
            final TypeFactory types = TypeFactory.getInstance();
            final Result base = gep.getBaseExpression().accept(this);
            Type type = gep.getIndexingType();
            final List<Expression> offsetExpressions = gep.getOffsetExpressions();
            for (Expression offset : offsetExpressions) {
                offset.accept(this);
            }
            if (base == null) {
                return null;
            }
            int offset = 0;
            int alignment = base.alignment;
            if (offsetExpressions.get(0) instanceof IValue offsetLiteral) {
                offset += types.getMemorySizeInBytes(type) * offsetLiteral.getValueAsInt();
            } else {
                alignment = types.getMemorySizeInBytes(type);
            }
            for (final Expression offsetExpression : offsetExpressions.subList(1, offsetExpressions.size())) {
                verify(type instanceof AggregateType || type instanceof ArrayType, "Non-container type %s", type);
                if (type instanceof AggregateType struct) {
                    verify(offsetExpression instanceof IValue,
                            "Non-constant field member expression: %s", gep);
                    int offsetValue = ((IValue) offsetExpression).getValueAsInt();
                    List<Type> fields = struct.getDirectFields();
                    verify(offsetValue >= 0 && offsetValue < fields.size(),
                            "Field member overflow: %s", gep);
                    for (Type field : fields.subList(0, offsetValue)) {
                        offset += types.getMemorySizeInBytes(field);
                    }
                    type = fields.get(offsetValue);
                } else {
                    type = ((ArrayType) type).getElementType();
                    int elementSize = TypeFactory.getInstance().getMemorySizeInBytes(type);
                    if (offsetExpression instanceof IValue offsetLiteral) {
                        int offsetValue = offsetLiteral.getValueAsInt();
                        offset += elementSize * offsetValue;
                    } else {
                        alignment = Math.max(Math.max(1, alignment), elementSize);
                    }
                }
            }
            return new Result(base.address, base.register, base.offset.add(BigInteger.valueOf(offset)), alignment);
        }

        @Override
        public Result visit(PointerCast cast) {
            final Result inner = cast.getInnerExpression().accept(this);
            return cast.getType() instanceof IntegerType target && !target.isMathematical() &&
                    target.getBitWidth() < TypeFactory.getInstance().getPointerType().getBitWidth() ? null : inner;
        }

        @Override
        public String toString() {
            return (result != null ? result : Sets.union(register, address)).toString();
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
