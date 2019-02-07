package com.dat3m.dartagnan.program.utils;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.Variable;

import java.util.*;

/**
 *
 * @author flo
 */
public class AliasAnalysis {

    private List<Variable> variables = new LinkedList<>();
    private ImmutableSet<Address> maxAddressSet;
    private Map<Register, Map<Event, Integer>> ssaMap;

    public void calculateLocationSets(Program program, Memory memory, Alias alias) {
        if(alias == Alias.NONE){
            calculateLocationSetsNoAlias(program, memory);
        } else if (alias == Alias.CFS){
            maxAddressSet = memory.getAllAddresses();
            ssaMap = getRegSsaMap(program);
            cfsProcessLocs(program, memory);
            cfsProcessRegs(program);
            cfsAlgorithm(memory);
            processResults(program);
        } else {
            maxAddressSet = memory.getAllAddresses();
            processLocs(program, memory);
            processRegs(program);
            algorithm(memory);
            processResults(program);
        }
    }

    private void processLocs(Program program, Memory memory) {
        for (Event ev : program.getEventRepository().getEvents(EventRepository.MEMORY)) {
            MemEvent e = (MemEvent) ev;
            IExpr address = e.getAddress();

            // Collect for each v events of form: p = *v, *v = q
            if (address instanceof Register) {
                ((Register) address).getAliasEvents().add(e);

            } else if (address instanceof Address) {
                // Rule reg = &loc -> lo(reg) = {loc}
                if (e instanceof RegWriter) {
                    Register register = ((RegWriter) e).getResultRegister();
                    register.getAliasAddresses().add((Address) address);
                    variables.add(register);

                } else if (e instanceof Init) {
                    // Rule loc = &loc2 -> lo(loc) = {loc2} (only possible in init events)
                    Location loc = memory.getLocationForAddress((Address) address);
                    IExpr value = ((Init) e).getValue();
                    if (loc != null && value instanceof Address) {
                        loc.getAliasAddresses().add((Address)value);
                        variables.add(loc);
                    }
                }

            } else {
                // r = *(CompExpr) -> loc(r) = max
                if (e instanceof RegWriter) {
                    Register register = ((RegWriter) e).getResultRegister();
                    register.getAliasAddresses().addAll(maxAddressSet);
                    variables.add(register);
                }
                // We allow for more address calculations
                e.setMaxAddressSet(maxAddressSet);
            }
        }
    }

    private void cfsProcessLocs(Program program, Memory memory) {
        for (Event ev : program.getEventRepository().getEvents(EventRepository.MEMORY)) {
            MemEvent e = (MemEvent) ev;
            IExpr address = e.getAddress();

            // Collect for each v events of form: p = *v, *v = q
            if (address instanceof Register) {
                Register register = (Register) address;
                SSAReg ssaReg = (register.getSSAReg(ssaMap.get(register).get(e)));
                ssaReg.getEventsWithAddr().add(e);

            } else if (address instanceof Address) {
                // Rule reg = &loc -> lo(reg)={loc}
                if (e instanceof RegWriter) {
                    Register register = ((RegWriter) e).getResultRegister();
                    SSAReg ssaReg = (register.getSSAReg(ssaMap.get(register).get(e)));
                    ssaReg.getAliasAddresses().add((Address) address);
                    variables.add(ssaReg);

                } else if (e instanceof Init) {
                    // Rule loc=&loc2 -> lo(loc)={loc2} (only possible in init events)
                    Location loc = memory.getLocationForAddress((Address) address);
                    IExpr value = ((Init) e).getValue();
                    if (loc != null && value instanceof Address) {
                        loc.getAliasAddresses().add((Address) value);
                        variables.add(loc);
                    }
                }
            } else {
                if (e instanceof RegWriter) {
                    Register register = ((RegWriter) e).getResultRegister();
                    SSAReg ssaReg = (register.getSSAReg(ssaMap.get(register).get(e)));
                    ssaReg.getAliasAddresses().addAll(maxAddressSet);
                    variables.add(ssaReg);
                }

                // We allow for more address calculations
                e.setMaxAddressSet(maxAddressSet);
            }
        }
    }

    private void processRegs(Program program) {
        for (Event ev : program.getEventRepository().getEvents(EventRepository.LOCAL)) {
            Local e = (Local) ev;
            Register register = e.getResultRegister();
            ExprInterface expr = e.getExpr();

            if (expr instanceof Register) {
                // r1 = r2 -> add edge r2 --> r1
                ((Register) expr).getAliasEdges().add(register);

            } else if (expr instanceof Address) {
                // r = &a
                register.getAliasAddresses().add((Address) expr);
                variables.add(register);
            }
        }
    }

    private void cfsProcessRegs(Program program) {
        for (Event ev : program.getEventRepository().getEvents(EventRepository.LOCAL)) {
            Local e = (Local) ev;
            Register register = e.getResultRegister();
            int id = ssaMap.get(register).get(e) + 1;
            SSAReg ssaReg1 = (register.getSSAReg(id));
            ExprInterface expr = e.getExpr();

            if (expr instanceof Register) {
                // r1 = r2 -> add edge r2 --> r1
                Register register2 = (Register) expr;
                SSAReg ssaReg2 = (register2.getSSAReg(ssaMap.get(register2).get(e)));
                ssaReg2.getAliasEdges().add(ssaReg1);

            } else if (expr instanceof Address) {
                // r = &a
                ssaReg1.getAliasAddresses().add((Address) expr);
                variables.add(ssaReg1);
            }
        }
    }

    private void algorithm(Memory memory) {
        while (!variables.isEmpty()) {
            Variable variable = variables.remove(0);
            if(variable instanceof Register){
                // Process rules with *variable:
                for (Address address : variable.getAliasAddresses()) {
                    Location location = memory.getLocationForAddress(address);
                    if (location != null) {
                        for (MemEvent e : ((Register) variable).getAliasEvents()) {
                            // p = *variable:
                            if (e instanceof RegWriter) {
                                // Add edge from location to p
                                if (location.getAliasEdges().add(((RegWriter) e).getResultRegister())) {
                                    // Add location to variables if edge is new.
                                    variables.add(location);
                                }
                            } else if (e instanceof Store) {
                                // *variable = register
                                ExprInterface value = e.getMemValue();
                                if (value instanceof Register) {
                                    Register register = (Register) value;
                                    // Add edge from register to location
                                    if (register.getAliasEdges().add(location)) {
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
            for (Variable q : variable.getAliasEdges()) {
                if (q.getAliasAddresses().addAll(variable.getAliasAddresses())) {
                    variables.add(q);
                }
            }
        }
    }

    private void cfsAlgorithm(Memory memory) {
        while (!variables.isEmpty()) {
            Variable variable = variables.remove(0);
            // Process rules with *variable:
            for (Address address : variable.getAliasAddresses()) {
                Location location = memory.getLocationForAddress(address);
                if (location != null && variable instanceof SSAReg) {
                    for (MemEvent e : ((SSAReg) variable).getEventsWithAddr()) {
                        // p = *variable:
                        if (e instanceof RegWriter) {
                            // Add edge from location to p
                            Register reg = ((RegWriter) e).getResultRegister();
                            SSAReg ssaReg = reg.getSSAReg(ssaMap.get(reg).get(e) + 1);
                            if (location.getAliasEdges().add(ssaReg)) {
                                //add a to W if edge is new.
                                variables.add(location);
                            }
                        } else if (e instanceof Store) {
                            // *variable = register
                            ExprInterface value = e.getMemValue();
                            if (value instanceof Register) {
                                Register register = (Register) value;
                                SSAReg ssaReg = register.getSSAReg(ssaMap.get(register).get(e));
                                // Add edge from register to location
                                if (ssaReg.getAliasEdges().add(location)) {
                                    // Add register to variables if edge is new.
                                    variables.add(ssaReg);
                                }
                            }
                        }
                    }
                }
            }
            // Process edges
            for (Variable q : variable.getAliasEdges()) {
                if (q.getAliasAddresses().addAll(variable.getAliasAddresses())) {
                    variables.add(q);
                }
            }
        }
    }

    private void processResults(Program program) {
        for (Event e : program.getEventRepository().getEvents(EventRepository.MEMORY)) {
            IExpr address = ((MemEvent) e).getAddress();
            Set<Address> adresses;
            if (address instanceof Register) {
                adresses = ((Register) address).getAliasAddresses();
            } else if (address instanceof Address) {
                    adresses = ImmutableSet.of(((Address) address));
            } else {
                adresses = maxAddressSet;
            }
            if (adresses.size() == 0) {
                adresses = maxAddressSet;
            }
            ImmutableSet<Address> addr = ImmutableSet.copyOf(adresses);
            ((MemEvent) e).setMaxAddressSet(addr);
        }
    }

    private void calculateLocationSetsNoAlias(Program program, Memory memory) {
        ImmutableSet<Address> maxAddressSet = memory.getAllAddresses();
        for (Event e : program.getEventRepository().getEvents(EventRepository.MEMORY)) {
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
            List<Event> events = thread.getEventRepository().getSortedList(EventRepository.ALL);
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

            if(e instanceof If){
                Map<Register, Integer> indexMapClone = new HashMap<>(indexMap);
                List<Event> t1Events = ((If)e).getT1().getEventRepository().getSortedList(EventRepository.ALL);
                List<Event> t2Events = ((If)e).getT2().getEventRepository().getSortedList(EventRepository.ALL);
                mkSsaIndices(t1Events, ssaMap, indexMap);
                mkSsaIndices(t2Events, ssaMap, indexMapClone);

                for(Register r : indexMapClone.keySet()){
                    indexMap.put(r, Integer.max(indexMap.getOrDefault(r, 0), indexMapClone.get(r)));
                    if(indexMap.get(r) < indexMapClone.get(r)){
                        r.getSSAReg(indexMap.get(r)).getAliasEdges().add(r.getSSAReg(indexMapClone.get(r)));
                    } else if(indexMap.get(r) > indexMapClone.get(r)){
                        r.getSSAReg(indexMapClone.get(r)).getAliasEdges().add(r.getSSAReg(indexMap.get(r)));
                    }
                }
                i += t1Events.size() + t2Events.size();
            }
        }
    }
}
