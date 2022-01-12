package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.memory.Address;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;

/**
 *
 * @author flo
 */
public class AndersenAliasAnalysis implements AliasAnalysis {

    private final Queue<Object> variables = new ArrayDeque<>();
    private final ImmutableSet<Location> maxAddressSet;
    private final Graph graph = new Graph();

    private final Map<MemEvent, ImmutableSet<Location>> eventAddressSpaceMap = new HashMap<>();

    // ================================ Construction ================================

    private AndersenAliasAnalysis(Program program) {
        Preconditions.checkArgument(program.isCompiled(), "The program must be compiled first.");
        ImmutableSet.Builder<Location> builder = new ImmutableSet.Builder<>();
        for(Address a : program.getMemory().getAllAddresses()) {
            builder.add(new Location(a,0));
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
            if(e instanceof Init && ((Init)e).getValue() instanceof Address) {
                // Rule loc = &loc2 -> lo(loc) = {loc2} (only possible in init events)
                Location location = new Location(((Init)e).getBase(),((Init)e).getOffset());
                graph.addAddress(location,new Location((Address)((Init)e).getValue(),0));
                variables.add(location);
            } else if (address instanceof Register) {
                graph.addEvent((Register) address, e);
            } else if(!(address instanceof Address)) {
                // r = *(CompExpr) -> loc(r) = max
                if (e instanceof RegWriter) {
                    Register register = ((RegWriter) e).getResultRegister();
                    graph.addAllAddresses(register, maxAddressSet);
                    variables.add(register);
                }
                // We allow for more address calculations
                //e.setMaxAddressSet(maxAddressSet);
                eventAddressSpaceMap.put(e, maxAddressSet);
            }
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
                } else if (expr instanceof Address) {
                    // r = &a
                    graph.addAddress(register,new Location((Address) expr,0));
                    variables.add(register);
                }
            }
        }
    }

    private void algorithm(Program program) {
        while (!variables.isEmpty()) {
            Object variable = variables.poll();
            if(variable instanceof Register){
                // Process rules with *variable:
                for (Location address : graph.getAddresses(variable)) {
                    if(program.getMemory().isStatic(address.base)) {
                        for (MemEvent e : graph.getEvents((Register) variable)) {
                            // p = *variable:
                            if (e instanceof RegWriter) {
                                // Add edge from location to p
                                if (graph.addEdge(address, ((RegWriter) e).getResultRegister())) {
                                    // Add location to variables if edge is new.
                                    variables.add(address);
                                }
                            } else if (e instanceof Store) {
                                // *variable = register
                                ExprInterface value = e.getMemValue();
                                if (value instanceof Register) {
                                    Register register = (Register) value;
                                    // Add edge from register to location
                                    if (graph.addEdge(register, address)) {
                                        // Add register to variables if edge is new.
                                        variables.add(register);
                                    }
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
        Map<Register,Location> targets = new HashMap<>();
    	for (Event ev : program.getCache().getEvents(FilterBasic.get(Tag.LOCAL))) {
    		// Not only Local events have EType.LOCAL tag
    		if(!(ev instanceof Local)) {
    			continue;
    		}
    		Local l = (Local)ev;
    		ExprInterface exp = l.getExpr();
    		Register reg = l.getResultRegister();
			if(exp instanceof Address) {
                targets.put(reg,new Location((Address)exp,0));
            } else if(exp instanceof IExprBin) {
    			IExpr base = ((IExprBin)exp).getBase();
    			if(base instanceof Address) {
                    IExpr rhs = ((IExprBin) exp).getRHS();
                    targets.put(reg,new Location((Address)base,rhs instanceof IConst?((IConst)rhs).getValueAsInt():-1));
    			} else if(base instanceof Register && targets.containsKey(base)) {
                    Location target = targets.get(base);
                    IExpr rhs = ((IExprBin) exp).getRHS();
                    targets.put(reg,rhs instanceof IConst ? target.add(((IConst)rhs).getValueAsInt()) : target.invalid());
    			}
    		}
    	}

        for (Event e : program.getCache().getEvents(FilterBasic.get(Tag.MEMORY))) {
            IExpr address = ((MemEvent) e).getAddress();
            Set<Location> addresses;
            if (address instanceof Register) {
                Location target = targets.get(address);
                if(target != null) {
            		if(target.offset >= 0) {
                        addresses = ImmutableSet.of(target);
            		} else {
                        addresses = new HashSet<>();
                        List<Address> array = program.getMemory().getArrayFromPointer(target.base);
                        int size = array == null ? 1 : array.size();
                        for(int i = 0; i < size; i++) {
                            addresses.add(new Location(target.base,i));
                        }
            		}
            	} else {
            	    addresses = graph.getAddresses(address);
            	}
            } else if (address instanceof Address) {
                addresses = ImmutableSet.of(new Location((Address) address,0));
            } else {
                addresses = maxAddressSet;
            }
            if (addresses.size() == 0) {
                addresses = maxAddressSet;
            }

            eventAddressSpaceMap.put((MemEvent) e, ImmutableSet.copyOf(addresses));
        }
    }

    private static final class Location {

        final Address base;
        final int offset;

        Location(Address b, int o) {
            base = b;
            offset = o;
        }

        Location add(int o) {
            return offset<0 || o==0 ? this : new Location(base,offset+o);
        }

        Location invalid() {
            return offset<0 ? this : new Location(base,-1);
        }

        @Override
        public int hashCode() {
            return base.hashCode() + offset;
        }

        @Override
        public boolean equals(Object o) {
            return this==o || o instanceof Location && base.equals(((Location)o).base) && offset == ((Location)o).offset;
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
