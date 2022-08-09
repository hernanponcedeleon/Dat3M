package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;
import com.google.common.base.Verify;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;
import java.util.function.BiConsumer;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.expression.op.IOpBin.PLUS;

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
    private final Graph graph = new Graph();

    private final Map<MemEvent, ImmutableSet<Location>> eventAddressSpaceMap = new HashMap<>();

    // ================================ Construction ================================

    private AndersenAliasAnalysis(Program program) {
        Preconditions.checkArgument(program.isCompiled(), "The program must be compiled first.");
        ImmutableSet.Builder<Location> builder = new ImmutableSet.Builder<>();
        for(MemoryObject a : program.getMemory().getObjects()) {
            for(int i = 0; i < a.size(); i++) {
                builder.add(new Location(a,i));
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
    public boolean mayAlias(MemEvent x, MemEvent y) {
        return !Sets.intersection(getMaxAddressSet(x), getMaxAddressSet(y)).isEmpty();
    }


    @Override
    public boolean mustAlias(MemEvent x, MemEvent y) {
        return getMaxAddressSet(x).size() == 1 && getMaxAddressSet(x).containsAll(getMaxAddressSet(y));
    }

    private ImmutableSet<Location> getMaxAddressSet(MemEvent e) {
        return eventAddressSpaceMap.get(e);
    }

    // ================================ Processing ================================

    private void run(Program program) {
        processLocs(program);
        processRegs(program);
        algorithm(program);
        processResults(program);
    }

    private void processLocs(Program program) {
        for (Event ev : program.getCache().getEvents(FilterBasic.get(Tag.MEMORY))) {
            MemEvent e = (MemEvent) ev;
            IExpr address = e.getAddress();

            // Collect for each v events of form: p = *v, *v = q
            if(address instanceof Register) {
                graph.addEvent((Register) address, e);
                continue;
            }
            Constant addressConstant = new Constant(address);
            if(addressConstant.failed) {
                // r = *(CompExpr) -> loc(r) = max
                if (e instanceof RegWriter) {
                    Register register = ((RegWriter) e).getResultRegister();
                    graph.addAllAddresses(register, maxAddressSet);
                    variables.add(register);
                }
                //FIXME if e is a store event, then all locations should include its values
                eventAddressSpaceMap.put(e, maxAddressSet);
                continue;
            }
            //address is a constant
            Location location = addressConstant.location;
            if(location == null) {
                throw new RuntimeException("memory event accessing a pure constant address");
            }
            eventAddressSpaceMap.put(e,ImmutableSet.of(location));
            if(e instanceof RegWriter) {
                graph.addEdge(location,((RegWriter)e).getResultRegister());
                continue;
            }
            //event is a store operation
            Verify.verify(e.is(Tag.WRITE),"memory event that is neither tagged \"W\" nor a register writer");
            ExprInterface value = e.getMemValue();
            if(value instanceof Register) {
                graph.addEdge(value,location);
                continue;
            }
            Constant v = new Constant(value);
            if(v.failed) {
                graph.addAllAddresses(location,maxAddressSet);
            } else if(v.location != null) {
                graph.addAddress(location,v.location);
            }
            variables.add(location);
        }
    }

    private void processRegs(Program program) {
        for (Event ev : program.getCache().getEvents(FilterBasic.get(Tag.LOCAL))) {
            if(ev instanceof Local) {
                Local e = (Local) ev;
                Register register = e.getResultRegister();
                ExprInterface expr = e.getExpr();

                if (expr instanceof Register) {
                    // r1 = r2 -> add edge r2 --> r1
                    graph.addEdge(expr, register);
                } else if (expr instanceof IExprBin && ((IExprBin)expr).getBase() instanceof Register) {
                	graph.addAllAddresses(register, maxAddressSet);
                    variables.add(register);
                } else if (expr instanceof MemoryObject) {
                    // r = &a
                    graph.addAddress(register,new Location((MemoryObject) expr,0));
                    variables.add(register);
                }
                //FIXME if the expression is too complicated, the register should receive maxAddressSet
            }
        }
    }

    private void algorithm(Program program) {
        while (!variables.isEmpty()) {
            Object variable = variables.poll();
            if(variable instanceof Register){
                // Process rules with *variable:
                for (Location address : graph.getAddresses(variable)) {
                    for(MemEvent e : graph.getEvents((Register)variable)) {
                        // p = *variable:
                        if(e instanceof RegWriter) {
                            // Add edge from location to p
                            if(graph.addEdge(address,((RegWriter)e).getResultRegister())) {
                                // Add location to variables if edge is new.
                                variables.add(address);
                            }
                        } else if(e instanceof Store) {
                            // *variable = register
                            ExprInterface value = e.getMemValue();
                            if(value instanceof Register) {
                                Register register = (Register) value;
                                // Add edge from register to location
                                if(graph.addEdge(register,address)) {
                                    // Add register to variables if edge is new.
                                    variables.add(register);
                                }
                            }
                        }
                    }
                }
            }
            // Process edges
            for (Object q : graph.getEdges(variable)) {
                if (graph.addAllAddresses(q, graph.getAddresses(variable))) {
                    variables.add(q);
                }
            }
        }
    }

    private void processResults(Program program) {
    	// Used to have pointer analysis when having arrays and structures
        Map<Register,Set<Location>> targets = new HashMap<>();
        BiConsumer<Register,Location> addTarget = (r,l)->targets.put(r,Set.of(l));
        BiConsumer<Register,MemoryObject> addTargetArray = (r,b)->targets.put(r,IntStream.range(0,b.size())
                .mapToObj(i->new Location(b,i))
                .collect(Collectors.toSet()));
    	for (Event ev : program.getCache().getEvents(FilterBasic.get(Tag.LOCAL))) {
    		// Not only Local events have EType.LOCAL tag
    		if(!(ev instanceof Local)) {
    			continue;
    		}
    		Local l = (Local)ev;
    		ExprInterface exp = l.getExpr();
    		Register reg = l.getResultRegister();
			if(exp instanceof MemoryObject) {
                addTarget.accept(reg,new Location((MemoryObject)exp,0));
            } else if(exp instanceof IExprBin) {
    			IExpr base = ((IExprBin)exp).getBase();
    			if(base instanceof MemoryObject) {
                    IExpr rhs = ((IExprBin) exp).getRHS();
                    //FIXME Address extends IConst
                    if(rhs instanceof IConst) {
                        addTarget.accept(reg,new Location((MemoryObject)base,((IConst)rhs).getValueAsInt()));
                    } else {
                        addTargetArray.accept(reg,(MemoryObject)base);
                    }
                    continue;
                }
                if(!(base instanceof Register)) {
                    continue;
                }
                //accept register2 = register1 + constant
                for(Location target : targets.getOrDefault(base,Set.of())) {
                    IExpr rhs = ((IExprBin) exp).getRHS();
                    //FIXME Address extends IConst
                    if(rhs instanceof IConst) {
                        int o = target.offset + ((IConst)rhs).getValueAsInt();
                        if(o < target.base.size()) {
                            addTarget.accept(reg,new Location(target.base,o));
                        }
                    } else {
                        addTargetArray.accept(reg,target.base);
                    }
    			}
    		}
    	}

        for (Event e : program.getCache().getEvents(FilterBasic.get(Tag.MEMORY))) {
            IExpr address = ((MemEvent) e).getAddress();
            Set<Location> addresses;
            if (address instanceof Register) {
                Set<Location> target = targets.get(address);
                if(target != null) {
                    addresses = target;
            	} else {
            	    addresses = graph.getAddresses(address);
            	}
            } else {
                Constant addressConstant = new Constant(address);
                if(addressConstant.failed) {
                    addresses = maxAddressSet;
                } else {
                    Verify.verify(addressConstant.location!=null,"memory event accessing a pure constant address");
                    addresses = ImmutableSet.of(addressConstant.location);
                }
            }
            if (addresses.size() == 0) {
                addresses = maxAddressSet;
            }

            eventAddressSpaceMap.put((MemEvent) e, ImmutableSet.copyOf(addresses));
        }
    }

    private static final class Constant {

        final Location location;
        //implies location == null
        final boolean failed;

        /**
         * Tries to match an expression as a constant address.
         */
        Constant(ExprInterface x) {
            if(x instanceof IConst) {
                location = x instanceof MemoryObject ? new Location((MemoryObject)x,0) : null;
                failed = false;
                return;
            }
            if(x instanceof IExprBin && ((IExprBin)x).getOp() == PLUS) {
                IExpr lhs = ((IExprBin)x).getLHS();
                IExpr rhs = ((IExprBin)x).getRHS();
                if(lhs instanceof MemoryObject && rhs instanceof IConst && !(rhs instanceof MemoryObject)) {
                    location = new Location((MemoryObject)lhs,((IConst)rhs).getValueAsInt());
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
            Preconditions.checkArgument(0 <= o && o < b.size(),"Array out of bounds");
            base = b;
            offset = o;
        }

        @Override
        public int hashCode() {
            return base.hashCode() + offset;
        }

        @Override
        public boolean equals(Object o) {
            return this==o || o instanceof Location && base.equals(((Location)o).base) && offset == ((Location)o).offset;
        }

        @Override
        public String toString() {
            return String.format("%s[%d]",base,offset);
        }
    }

    private static class Graph {

        private final Map<Object, Set<Object>> edges = new HashMap<>();
        private final Map<Object, Set<Location>> addresses = new HashMap<>();
        private final Map<Register, Set<MemEvent>> events = new HashMap<>();

        boolean addEdge(Object v1, Object v2){
            return edges.computeIfAbsent(v1, key -> new HashSet<>()).add(v2);
        }

        Set<Object> getEdges(Object v){
            return edges.getOrDefault(v, ImmutableSet.of());
        }

        void addAddress(Object v, Location a){
            addresses.computeIfAbsent(v, key -> new HashSet<>()).add(a);
        }

        boolean addAllAddresses(Object v, Set<Location> s){
            return addresses.computeIfAbsent(v, key -> new HashSet<>()).addAll(s);
        }

        Set<Location> getAddresses(Object v){
            return addresses.getOrDefault(v, ImmutableSet.of());
        }

        void addEvent(Register r, MemEvent e){
            events.computeIfAbsent(r, key -> new HashSet<>()).add(e);
        }

        Set<MemEvent> getEvents(Register r){
            return events.getOrDefault(r, ImmutableSet.of());
        }
    }
}
