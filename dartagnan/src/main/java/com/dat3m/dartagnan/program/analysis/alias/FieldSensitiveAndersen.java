package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.filter.FilterBasic;
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
    private final Map<MemEvent,ImmutableSet<Location>> eventAddressSpaceMap = new HashMap<>();

    // ================================ Construction ================================

    public static FieldSensitiveAndersen fromConfig(Program program, Configuration config) throws InvalidConfigurationException {
        return new FieldSensitiveAndersen(program);
    }

    private FieldSensitiveAndersen(Program program) {
        Preconditions.checkArgument(program.isCompiled(), "The program must be compiled first.");
        for(Event e : program.getCache().getEvents(FilterBasic.get(Tag.MEMORY))) {
            processLocs((MemEvent)e);
        }
        for(Event e : program.getCache().getEvents(FilterBasic.get(Tag.LOCAL))) {
            if(e instanceof Local) {
                processRegs((Local)e);
            }
        }
        while(!variables.isEmpty()) {
            algorithm(variables.poll());
        }
        for(Event e : program.getCache().getEvents(FilterBasic.get(Tag.MEMORY))) {
            processResults((MemEvent)e);
        }
    }

    // ================================ API ================================

    @Override
    public boolean mayAlias(MemEvent x, MemEvent y) {
        return !Sets.intersection(getMaxAddressSet(x), getMaxAddressSet(y)).isEmpty();
    }

    @Override
    public boolean mustAlias(MemEvent x, MemEvent y) {
        Set<Location> a = getMaxAddressSet(x);
        return a.size() == 1 && a.containsAll(getMaxAddressSet(y));
    }

    private ImmutableSet<Location> getMaxAddressSet(MemEvent e) {
        return eventAddressSpaceMap.get(e);
    }

    // ================================ Processing ================================

    protected void processLocs(MemEvent e) {
        Collector collector = new Collector(e.getAddress());
        if(e instanceof RegWriter) {
            Register result = ((RegWriter)e).getResultRegister();
            for(Offset<Register> r : collector.register()) {
                loads.computeIfAbsent(r.base,k->new LinkedList<>()).add(new Offset<>(result,r.offset,r.alignment));
            }
            for(Location f : collector.address()) {
                addEdge(f,result,0,0);
            }
        } else {
            Collector value = new Collector(e.getMemValue());
            for(Offset<Register> r : collector.register()) {
                stores.computeIfAbsent(r.base,k->new LinkedList<>()).add(new Offset<>(value,r.offset,r.alignment));
            }
            for(Location l : collector.address()) {
                for(Offset<Register> r : value.register()) {
                    addEdge(r.base,l,r.offset,r.alignment);
                }
                addAllAddresses(l,value.address());
            }
        }
    }

    protected void processRegs(Local e) {
        Register register = e.getResultRegister();
        Collector collector = new Collector(e.getExpr());
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

    protected void processResults(MemEvent e) {
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
            return base.hashCode() + Objects.hashCode(offset);
        }

        @Override
        public boolean equals(Object o) {
            return this == o || o instanceof Location && base.equals(((Location)o).base) && offset==((Location)o).offset;
        }

        @Override
        public String toString() {
            return String.format("%s[%d]",base,offset);
        }
    }

    private static List<Location> fields(Collection<Location> v, int offset, int alignment) {
        return v.stream()
                .flatMap(l->range(0,div(l.base.size(),alignment))
                        .map(i->l.offset+offset+i*alignment)
                        .filter(i->0<=i&&i<l.base.size())
                        .mapToObj(i->new Location(l.base,i)))
                .filter(l->0<=l.offset&&l.offset<l.base.size())
                .collect(toList());
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

        Collector(ExprInterface x) {
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
        if(addresses.computeIfAbsent(v, key -> new HashSet<>()).addAll(s)) {
            variables.add(v);
        }
    }

    private Set<Location> getAddresses(Object v) {
        return addresses.getOrDefault(v, ImmutableSet.of());
    }
}
