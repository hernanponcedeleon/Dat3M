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
    private final ImmutableSet<Address> maxAddressSet;
    private final Graph graph = new Graph();

    private final Map<MemEvent, ImmutableSet<Address>> eventAddressSpaceMap = new HashMap<>();

    // ================================ Construction ================================

    private AndersenAliasAnalysis(Program program) {
        Preconditions.checkArgument(program.isCompiled(), "The program must be compiled first.");
        maxAddressSet = program.getMemory().getAllAddresses();
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

    private ImmutableSet<Address> getMaxAddressSet(MemEvent e) {
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
            if (address instanceof Register) {
                graph.addEvent((Register) address, e);
            } else if (address instanceof Address) {
                if (e instanceof Init) {
                    // Rule loc = &loc2 -> lo(loc) = {loc2} (only possible in init events)
                    IExpr value = ((Init) e).getValue();
                    if (program.getMemory().isStatic((Address)address) && value instanceof Address) {
                        graph.addAddress(address, (Address)value);
                        variables.add(address);
                    }
                }
            } else {
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
                    graph.addAddress(register, (Address) expr);
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
                for (Address address : graph.getAddresses(variable)) {
                    if(program.getMemory().isStatic(address)) {
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
    	Map<Register, Address> bases = new HashMap<>();
    	Map<Register, Integer> offsets = new HashMap<>();
    	for (Event ev : program.getCache().getEvents(FilterBasic.get(Tag.LOCAL))) {
    		// Not only Local events have EType.LOCAL tag
    		if(!(ev instanceof Local)) {
    			continue;
    		}
    		Local l = (Local)ev;
    		ExprInterface exp = l.getExpr();
    		Register reg = l.getResultRegister();
			if(exp instanceof Address) {
    			bases.put(reg, (Address)exp);
                offsets.put(reg, 0);
            } else if(exp instanceof IExprBin) {
    			IExpr base = ((IExprBin)exp).getBase();
    			if(base instanceof Address) {
    				bases.put(reg, (Address)base);
    				if(((IExprBin) exp).getRHS() instanceof IConst) {
        				offsets.put(reg, ((IConst)((IExprBin) exp).getRHS()).getValueAsInt());    					
    				}
    			} else if(base instanceof Register && bases.containsKey(base)) {
    				bases.put(reg, bases.get(base));
    				if(((IExprBin) exp).getRHS() instanceof IConst) {
        				offsets.put(reg, ((IConst)((IExprBin) exp).getRHS()).getValueAsInt());    					
    				}
    			}
    		}
    	}

        for (Event e : program.getCache().getEvents(FilterBasic.get(Tag.MEMORY))) {
            IExpr address = ((MemEvent) e).getAddress();
            Set<Address> addresses;
            if (address instanceof Register) {
            	if(bases.containsKey(address) && program.getMemory().isArrayPointer(bases.get(address))) {
            		if(offsets.containsKey(address)) {
                		addresses = ImmutableSet.of(program.getMemory().getArrayFromPointer(bases.get(address)).get(offsets.get(address)));
            		} else {
                		addresses = new HashSet<>(program.getMemory().getArrayFromPointer(bases.get(address)));
            		}
            	} else {
            	    addresses = graph.getAddresses(address);
            	}
            } else if (address instanceof Address) {
                addresses = ImmutableSet.of(((Address) address));
            } else {
                addresses = maxAddressSet;
            }
            if (addresses.size() == 0) {
                addresses = maxAddressSet;
            }

            eventAddressSpaceMap.put((MemEvent) e, ImmutableSet.copyOf(addresses));
        }
    }

    private static class Graph {

        private final Map<Object, Set<Object>> edges = new HashMap<>();
        private final Map<Object, Set<Address>> addresses = new HashMap<>();
        private final Map<Register, Set<MemEvent>> events = new HashMap<>();

        boolean addEdge(Object v1, Object v2){
            return edges.computeIfAbsent(v1, key -> new HashSet<>()).add(v2);
        }

        Set<Object> getEdges(Object v){
            return edges.getOrDefault(v, ImmutableSet.of());
        }

        void addAddress(Object v, Address a){
            addresses.computeIfAbsent(v, key -> new HashSet<>()).add(a);
        }

        boolean addAllAddresses(Object v, Set<Address> s){
            return addresses.computeIfAbsent(v, key -> new HashSet<>()).addAll(s);
        }

        Set<Address> getAddresses(Object v){
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
