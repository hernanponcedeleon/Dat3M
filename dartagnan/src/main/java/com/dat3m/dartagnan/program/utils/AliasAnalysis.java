package com.dat3m.dartagnan.program.utils;

import com.dat3m.dartagnan.expression.ExprInterface;
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

    public void calculateLocationSets(Program program, Memory memory, boolean noAlias) {
        if(noAlias){
            calculateLocationSetsNoAlias(program, memory);
        } else {
            maxAddressSet = memory.getAllAddresses();
            preprocessLocs(program, memory);
            preprocessRegs(program);
            mainAlgorithm(memory);
            processResults(program);
        }
    }

    private void preprocessLocs(Program program, Memory memory) {
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

    private void preprocessRegs(Program program) {
        for (Event ev : program.getEventRepository().getEvents(EventRepository.LOCAL)) {
            Local e = (Local) ev;
            Register register = e.getResultRegister();
            ExprInterface expr = e.getExpr();

            if (expr instanceof Register) {
                // r1 = r2 -> add edge r2 --> r1
                ((Register) expr).getAliasEdges().add(register);

            } else if (e.getExpr() instanceof Address) {
                // r = &a
                register.getAliasAddresses().add((Address) expr);
                variables.add(register);
            }
        }
    }

    private void mainAlgorithm(Memory memory) {
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
}
