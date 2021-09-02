package com.dat3m.dartagnan.wmm.utils.alias;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.google.common.collect.ImmutableSet;

import java.util.*;

/**
 *
 * @author flo
 */
public class AliasAnalysis {

    private List<Object> variables = new LinkedList<>(); // TODO: Use a queue
    private ImmutableSet<Address> maxAddressSet;
    private Map<Register, Map<Event, Integer>> ssaMap;

    private Graph graph = new Graph();

    public void calculateLocationSets(Program program, Alias alias) {
        if(alias == Alias.NONE){
            calculateLocationSetsNoAlias(program);
        } else if (alias == Alias.CFS){
            maxAddressSet = program.getMemory().getAllAddresses();
            ssaMap = getRegSsaMap(program);
            cfsProcessLocs(program);
            cfsProcessRegs(program);
            cfsAlgorithm(program);
            processResults(program);
        } else {
            maxAddressSet = program.getMemory().getAllAddresses();
            processLocs(program);
            processRegs(program);            	
            algorithm(program);
            processResults(program);
        }
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

    private void cfsProcessLocs(Program program) {
        for (Event ev : program.getCache().getEvents(FilterBasic.get(EType.MEMORY))) {
            MemEvent e = (MemEvent) ev;
            IExpr address = e.getAddress();

            // Collect for each v events of form: p = *v, *v = q
            if (address instanceof Register) {
                Register register = (Register) address;
                SSAReg ssaReg = graph.getSSAReg(register, ssaMap.get(register).get(e));
                ssaReg.getEventsWithAddr().add(e);

            } else if (address instanceof Address) {
                // Rule register = &loc -> lo(register)={loc}
                if (e instanceof RegWriter) {
                    Register register = ((RegWriter) e).getResultRegister();
                    SSAReg ssaReg = graph.getSSAReg(register, ssaMap.get(register).get(e));
                    graph.addAddress(ssaReg, (Address) address);
                    variables.add(ssaReg);

                } else if (e instanceof Init) {
                    // Rule loc=&loc2 -> lo(loc)={loc2} (only possible in init events)
                    Location loc = program.getMemory().getLocationForAddress((Address) address);
                    IExpr value = ((Init) e).getValue();
                    if (loc != null && value instanceof Address) {
                        graph.addAddress(loc, (Address) value);
                        variables.add(loc);
                    }
                }
            } else {
                if (e instanceof RegWriter) {
                    Register register = ((RegWriter) e).getResultRegister();
                    SSAReg ssaReg = graph.getSSAReg(register, ssaMap.get(register).get(e));
                    graph.addAllAddresses(ssaReg, maxAddressSet);
                    variables.add(ssaReg);
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
                } else if (expr instanceof IExprBin && expr.getBase() instanceof Register) {
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

    private void cfsProcessRegs(Program program) {
        for (Event ev : program.getCache().getEvents(FilterBasic.get(EType.LOCAL))) {
            if(ev instanceof Local) {
                Local e = (Local) ev;
                Register register = e.getResultRegister();
                int id = ssaMap.get(register).get(e) + 1;
                SSAReg ssaReg1 = graph.getSSAReg(register, id);
                ExprInterface expr = e.getExpr();

                if (expr instanceof Register) {
                    // r1 = r2 -> add edge r2 --> r1
                    Register register2 = (Register) expr;
                    SSAReg ssaReg2 = graph.getSSAReg(register2, ssaMap.get(register2).get(e));
                    graph.addEdge(ssaReg2, ssaReg1);

                } else if (expr instanceof Address) {
                    // r = &a
                    graph.addAddress(ssaReg1, (Address) expr);
                    variables.add(ssaReg1);
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

    private void cfsAlgorithm(Program program) {
        while (!variables.isEmpty()) {
            Object variable = variables.remove(0);
            // Process rules with *variable:
            for (Address address : graph.getAddresses(variable)) {
                Location location = program.getMemory().getLocationForAddress(address);
                if (location != null && variable instanceof SSAReg) {
                    for (MemEvent e : ((SSAReg) variable).getEventsWithAddr()) {
                        // p = *variable:
                        if (e instanceof RegWriter) {
                            // Add edge from location to p
                            Register reg = ((RegWriter) e).getResultRegister();
                            SSAReg ssaReg = graph.getSSAReg(reg, ssaMap.get(reg).get(e) + 1);
                            if (graph.addEdge(location, ssaReg)) {
                                //add a to W if edge is new.
                                variables.add(location);
                            }
                        } else if (e instanceof Store) {
                            // *variable = register
                            ExprInterface value = e.getMemValue();
                            if (value instanceof Register) {
                                Register register = (Register) value;
                                SSAReg ssaReg = graph.getSSAReg(register, ssaMap.get(register).get(e));
                                // Add edge from register to location
                                if (graph.addEdge(ssaReg, location)) {
                                    // Add register to variables if edge is new.
                                    variables.add(ssaReg);
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
    			IExpr base = exp.getBase();
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
            	    addresses = graph.getAddresses(((Register) address));	
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

    private void calculateLocationSetsNoAlias(Program program) {
        ImmutableSet<Address> maxAddressSet = program.getMemory().getAllAddresses();
        for (Event e : program.getCache().getEvents(FilterBasic.get(EType.MEMORY))) {
            IExpr address = ((MemEvent) e).getAddress();
            if (address instanceof Address) {
                ((MemEvent) e).setMaxAddressSet(ImmutableSet.of((Address) address));
            } else {
                ((MemEvent) e).setMaxAddressSet(maxAddressSet);
            }
        }
    }

    private Map<Register, Map<Event, Integer>> getRegSsaMap(Program program){
        Map<Register, Map<Event, Integer>> ssaMap = new HashMap<>();
        Map<Register, Integer> indexMap = new HashMap<>();
        for(Thread thread : program.getThreads()){
            List<Event> events = thread.getCache().getEvents(FilterBasic.get(EType.ANY));
            mkSsaIndices(events, ssaMap, indexMap);
        }
        return ssaMap;
    }


    private void mkSsaIndices(
            List<Event> events,
            Map<Register, Map<Event, Integer>> ssaMap,
            Map<Register, Integer> indexMap
    ){
        for(int i = 0; i < events.size(); i++){
            Event e = events.get(i);

            if(e instanceof RegReaderData){
                for(Register register : ((RegReaderData)e).getDataRegs()){
                    ssaMap.putIfAbsent(register, new HashMap<>());
                    ssaMap.get(register).put(e, indexMap.getOrDefault(register, 0));
                }
            }

            if(e instanceof MemEvent){
                for(Register register : ((MemEvent)e).getAddress().getRegs()){
                    ssaMap.putIfAbsent(register, new HashMap<>());
                    ssaMap.get(register).put(e, indexMap.getOrDefault(register, 0));
                }
            }

            if(e instanceof RegWriter){
                Register register = ((RegWriter)e).getResultRegister();
                int index = indexMap.getOrDefault(register, 0);
                ssaMap.putIfAbsent(register, new HashMap<>());
                ssaMap.get(register).put(e, index);
                indexMap.put(register, ++index);
            }
        }
    }
}
