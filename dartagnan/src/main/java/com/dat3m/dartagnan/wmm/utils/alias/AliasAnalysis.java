package com.dat3m.dartagnan.wmm.utils.alias;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.google.common.collect.ImmutableSet;

import java.util.*;

import org.sosy_lab.common.configuration.Options;

/**
 *
 * @author flo
 */
@Options
public class AliasAnalysis {

    private final List<Object> variables = new LinkedList<>(); // TODO: Use a queue
    private ImmutableSet<Address> maxAddressSet;

    private final Graph graph = new Graph();

    public void calculateLocationSets(Program program) {
    	maxAddressSet = program.getMemory().getAllAddresses();
    	processLocs(program);
    	processRegs(program);            	
    	algorithm(program);
    	processResults(program);
    }

    private void processLocs(Program program) {
        for (Event ev : program.getCache().getEvents(FilterBasic.get(EType.MEMORY))) {
            MemEvent e = (MemEvent) ev;
            IExpr address = e.getAddress();

            // Collect for each v events of form: p = *v, *v = q
            if (address instanceof Register) {
                graph.addEvent((Register) address, e);
            } else if (address instanceof Address) {
                if (e instanceof Init) {
                    // Rule loc = &loc2 -> lo(loc) = {loc2} (only possible in init events)
                    Location loc = program.getMemory().getLocationForAddress((Address) address);
                    IExpr value = ((Init) e).getValue();
                    if (loc != null && value instanceof Address) {
                        graph.addAddress(loc, (Address)value);
                        variables.add(loc);
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
                e.setMaxAddressSet(maxAddressSet);
            }
        }
    }

    private void processRegs(Program program) {
        for (Event ev : program.getCache().getEvents(FilterBasic.get(EType.LOCAL))) {
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
            Object variable = variables.remove(0);
            if(variable instanceof Register){
                // Process rules with *variable:
                for (Address address : graph.getAddresses(variable)) {
                    Location location = program.getMemory().getLocationForAddress(address);
                    if (location != null) {
                        for (MemEvent e : graph.getEvents((Register) variable)) {
                            // p = *variable:
                            if (e instanceof RegWriter) {
                                // Add edge from location to p
                                if (graph.addEdge(location, ((RegWriter) e).getResultRegister())) {
                                    // Add location to variables if edge is new.
                                    variables.add(location);
                                }
                            } else if (e instanceof Store) {
                                // *variable = register
                                ExprInterface value = e.getMemValue();
                                if (value instanceof Register) {
                                    Register register = (Register) value;
                                    // Add edge from register to location
                                    if (graph.addEdge(register, location)) {
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
    	for (Event ev : program.getCache().getEvents(FilterBasic.get(EType.LOCAL))) {
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
        				offsets.put(reg, ((IConst)((IExprBin) exp).getRHS()).getIntValue().intValue());    					
    				}
    			} else if(base instanceof Register && bases.containsKey(base)) {
    				bases.put(reg, bases.get(base));
    				if(((IExprBin) exp).getRHS() instanceof IConst) {
        				offsets.put(reg, ((IConst)((IExprBin) exp).getRHS()).getIntValue().intValue());    					
    				}
    			}
    		}
    	}

        for (Event e : program.getCache().getEvents(FilterBasic.get(EType.MEMORY))) {
            IExpr address = ((MemEvent) e).getAddress();
            Set<Address> addresses;
            if (address instanceof Register) {
            	if(bases.containsKey(address) && program.getMemory().isArrayPointer(bases.get(address))) {
            		if(offsets.containsKey(address)) {
                		addresses = ImmutableSet.of(program.getMemory().getArrayfromPointer(bases.get(address)).get(offsets.get(address)));            			
            		} else {
                		addresses = new HashSet<>(program.getMemory().getArrayfromPointer(bases.get(address)));
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
            ImmutableSet<Address> addr = ImmutableSet.copyOf(addresses);
            ((MemEvent) e).setMaxAddressSet(addr);
        }
    }
}
