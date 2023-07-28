package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.threading.ThreadArgument;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.expression.op.IOpBin.*;
import static com.dat3m.dartagnan.expression.op.IOpUn.MINUS;
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
 * Non-conforming expressions are probed for bases, which contribute in the most general manner:
 * Any structure that occurs
 * <p>
 * Structures, that never occurs in any expression, are considered unreachable.
 *
 * @author xeren
 */
public class FieldSensitiveAndersen implements AliasAnalysis {

    ///When a pointer set gains new content, it is added to this queue
    private final Queue<Object> variables = new ArrayDeque<>();

    private final Map<Object,Set<Offset<Object>>> edges = new HashMap<>();
    private final Map<Object,Set<Location>> addresses = new HashMap<>();

    ///Maps registers to result registers of loads that use the register in their address
    private final Map<Object,List<Offset<Register>>> loads = new HashMap<>();
    ///Maps registers to matched value expressions of stores that use the register in their address
    private final Map<Object,List<Offset<Collector>>> stores = new HashMap<>();
    ///Result sets
    private final Map<MemoryEvent,ImmutableSet<Location>> eventAddressSpaceMap = new HashMap<>();

    // ================================ Construction ================================

    public static FieldSensitiveAndersen fromConfig(Program program, Configuration config) throws InvalidConfigurationException {
        return new FieldSensitiveAndersen(program);
    }

    private FieldSensitiveAndersen(Program program) {
        Preconditions.checkArgument(program.isCompiled(), "The program must be compiled first.");
        List<MemoryCoreEvent> memEvents = program.getThreadEvents(MemoryCoreEvent.class);
        for (MemoryCoreEvent e : memEvents) {
            processLocs(e);
        }
        program.getThreadEvents().forEach(this::processRegs);
        while(!variables.isEmpty()) {
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
        if(e instanceof Load load) {
            Register result = load.getResultRegister();
            for(Offset<Register> r : collector.register()) {
                loads.computeIfAbsent(r.base,k->new LinkedList<>()).add(new Offset<>(result,r.offset,r.alignment));
            }
            for(Location f : collector.address()) {
                addEdge(f,result,0,0);
            }
        } else if (e instanceof Store store) {
            Collector value = new Collector(store.getMemValue());
            for(Offset<Register> r : collector.register()) {
                stores.computeIfAbsent(r.base,k->new LinkedList<>()).add(new Offset<>(value,r.offset,r.alignment));
            }
            for(Location l : collector.address()) {
                for(Offset<Register> r : value.register()) {
                    addEdge(r.base,l,r.offset,r.alignment);
                }
                addAllAddresses(l,value.address());
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
        final Register register = ((RegWriter)e).getResultRegister();
        final Expression expr;
        if (e instanceof Local local) {
            expr = local.getExpr();
        } else {
            final ThreadArgument arg = (ThreadArgument) e;
            expr = arg.getCreator().getArguments().get(arg.getIndex());
        }
        final Collector collector = new Collector(expr);
        addAllAddresses(register,collector.address());
        for(Offset<Register> r : collector.register()) {
            addEdge(r.base,register,r.offset,r.alignment);
        }
    }

    protected void algorithm(Object variable) {
        Set<Location> addresses = getAddresses(variable);
        //if variable is a register, there may be loads using it in their address
        for(Offset<Register> load : loads.getOrDefault(variable,List.of())) {
            //if load.offset is not null, the operation accesses variable + load.offset
            for(Location f : fields(addresses,load.offset,load.alignment)) {
                if(addEdge(f,load.base,0,0)) {
                    variables.add(f);
                }
            }
        }
        //if variable is a register, there may be stores using it in their address
        for(Offset<Collector> store : stores.getOrDefault(variable,List.of())) {
            for(Location a : fields(addresses,store.offset,store.alignment)) {
                for(Offset<Register> r : store.base.register()) {
                    if(addEdge(r.base,a,r.offset,r.alignment)) {
                        variables.add(r.base);
                    }
                }
                addAllAddresses(a,store.base.address());
            }
        }
        // Process edges
        for(Offset<Object> q : getEdges(variable)) {
            addAllAddresses(q.base,fields(addresses,q.offset,q.alignment));
        }
    }

    protected void processResults(MemoryCoreEvent e) {
        ImmutableSet.Builder<Location> addresses = ImmutableSet.builder();
        Collector collector = new Collector(e.getAddress());
        addresses.addAll(collector.address());
        for(Offset<Register> r : collector.register()) {
            addresses.addAll(fields(getAddresses(r.base),r.offset,r.alignment));
        }
        eventAddressSpaceMap.put(e,addresses.build());
    }

    private static final class Offset <Base> {

        final Base base;
        final int offset;
        final int alignment;

        Offset(Base b, int o, int a) {
            base = b;
            offset = o;
            alignment = a;
        }

        @Override
        public int hashCode() {
            return base.hashCode() + Objects.hashCode(offset) + Objects.hashCode(alignment);
        }

        @Override
        public boolean equals(Object o) {
            return this == o || o instanceof Offset && base.equals(((Offset<?>)o).base) && Objects.equals(offset,((Offset<?>)o).offset);
        }

        @Override
        public String toString() {
            return String.format("%s+%d+%dx",base,offset,alignment);
        }
    }

    private static final class Location {

        final MemoryObject base;
        final int offset;

        Location(MemoryObject b, int o) {
            base = b;
            offset = o;
        }

        @Override
        public int hashCode() {
            return 1201 * base.hashCode() + offset; // High factor to prevent overlapping hashcodes
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) {
                return true;
            } else if (o == null || getClass() != o.getClass()) {
                return false;
            }
            Location other = (Location) o;
            // Can we check reference-equality on the MemoryObject?
            return this.base.equals(other.base) && this.offset == other.offset;
        }

        @Override
        public String toString() {
            return String.format("%s[%d]",base,offset);
        }
    }

    private static List<Location> fields(Collection<Location> v, int offset, int alignment) {
        final List<Location> result = new ArrayList<>();
        for (Location l : v) {
            for (int i = 0; i < div(l.base.size(), alignment); i++) {
                int mapped = l.offset + offset + i * alignment;
                if ( 0 <= mapped && mapped < l.base.size()) {
                    Location loc = new Location(l.base, mapped);
                    result.add(loc);
                }
            }
        }
        return result;

    }

    private static int div(int p, int q) {
        return q==0 ? 1 : p / q + (p % q == 0 ? 0 : 1);
    }

    private static final class Result {
        final MemoryObject address;
        final Register register;
        final BigInteger offset;
        final int alignment;

        Result(MemoryObject b, Register r, BigInteger o, int a) {
            address = b;
            register = r;
            offset = o;
            alignment = a;
        }

        @Override
        public String toString() {
            return String.format("%s+%s+%dx",address!=null?address:register,offset,alignment);
        }
    }

    private static final class Collector implements ExpressionVisitor<Result> {

        final HashSet<MemoryObject> address = new HashSet<>();
        final HashSet<Register> register = new HashSet<>();
        Result result;

        Collector(Expression x) {
            result = x.visit(this);
        }

        List<Location> address() {
            if(result != null && result.address != null) {
                verify(address.size() == 1);
                return fields(List.of(new Location(result.address,0)),result.offset.intValue(),result.alignment);
            }
            return address.stream().flatMap(a->range(0,a.size()).mapToObj(i->new Location(a,i))).collect(toList());
        }

        List<Offset<Register>> register() {
            List<Offset<Register>> list = new LinkedList<>();
            Register r = result==null ? null : result.register;
            if(r != null) {
                list.add(new Offset<>(r,result.offset.intValue(),result.alignment));
            }
            register.stream().filter(i->i!=r).map(i->new Offset<>(i,0,1)).forEach(list::add);
            return list;
        }

        @Override
        public Result visit(IExprBin x) {
            Result l = x.getLHS().visit(this);
            Result r = x.getRHS().visit(this);
            if(l == null || r == null || x.getOp() == R_SHIFT) {
                return null;
            }
            if(l.address==null && l.register==null && l.alignment==0 && r.address==null && r.register==null && r.alignment==0) {
                return new Result(null,null,x.getOp().combine(l.offset,r.offset),0);
            }
            if(x.getOp() == MULT) {
                if(l.address!=null || r.address!=null) {
                    return null;
                }
                return new Result(null, null, l.offset.multiply(r.offset), min(min(l.alignment,l.register)*r.offset.intValue(), min(r.alignment,r.register)*l.offset.intValue()));
            }
            if(x.getOp() == PLUS) {
                if(l.address!=null && r.address!=null) {
                    return null;
                }
                MemoryObject base = l.address!=null ? l.address : r.address;
                BigInteger offset = l.offset.add(r.offset);
                if(base!=null) {
                    return new Result(base,null,offset,min(min(l.alignment,l.register), min(r.alignment,r.register)));
                }
                if(l.register != null) {
                    return new Result(null,l.register,offset,min(l.alignment,min(r.alignment,r.register)));
                }
                return new Result(null,r.register,offset,min(l.alignment,r.alignment));
            }
            return null;
        }

        @Override
        public Result visit(IExprUn x) {
            Result i = x.getInner().visit(this);
            return i == null ? null : x.getOp() != MINUS ? i
                    : new Result(null,null,i.offset.negate(),i.alignment==0?1:i.alignment);
        }

        @Override
        public Result visit(IfExpr x) {
            x.getTrueBranch().visit(this);
            x.getFalseBranch().visit(this);
            return null;
        }

        @Override
        public Result visit(MemoryObject a) {
            address.add(a);
            return new Result(a,null,BigInteger.ZERO,0);
        }

        @Override
        public Result visit(Register r) {
            register.add(r);
            return new Result(null,r,BigInteger.ZERO,0);
        }

        @Override
        public Result visit(IValue v) {
            return new Result(null,null,v.getValue(),0);
        }

        @Override
        public String toString() {
            return (result!=null ? result : Sets.union(register,address)).toString();
        }

        private static int min(int a, int b) {
            return a==0 || b!=0 && b < a ? b : a;
        }

        private int min(int a, Object b) {
            return b==null || a!=0 ? a : 1;
        }
    }

    private boolean addEdge(Object v1, Object v2, int o, int a) {
        return edges.computeIfAbsent(v1, key -> new HashSet<>()).add(new Offset<>(v2,o,a));
    }

    private Set<Offset<Object>> getEdges(Object v) {
        return edges.getOrDefault(v, ImmutableSet.of());
    }

    private void addAllAddresses(Object v, Collection<Location> s) {
        // NOTE: This method is the most expensive of the whole computation
        if(addresses.computeIfAbsent(v, key -> new HashSet<>()).addAll(s)) {
            variables.add(v);
        }
    }

    private Set<Location> getAddresses(Object v) {
        return addresses.getOrDefault(v, ImmutableSet.of());
    }
}
