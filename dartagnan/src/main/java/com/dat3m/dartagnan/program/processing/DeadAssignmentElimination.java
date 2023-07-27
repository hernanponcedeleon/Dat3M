package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.google.common.collect.Lists;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.ASSERTION;
import static com.dat3m.dartagnan.program.event.Tag.NOOPT;

// This is just Dead Store Elimination, but the use of the term "Store" can be confusing in our setting 
public class DeadAssignmentElimination implements FunctionProcessor {

    private DeadAssignmentElimination() { }

    public static DeadAssignmentElimination newInstance() {
        return new DeadAssignmentElimination();
    }

    public static DeadAssignmentElimination fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    @Override
    public void run(Function function) {
        eliminateDeadAssignments(function);
    }

    private void eliminateDeadAssignments(Function function) {
        final Program program = function.getProgram();
        Set<Register> usedRegs = new HashSet<>();
        if(program.getSpecification() != null) {
            usedRegs.addAll(program.getSpecification().getRegs());
            // for litmus tests
            if (program.getFilterSpecification() != null) {
                usedRegs.addAll(program.getFilterSpecification().getRegs());
            }
        }

        // Compute events to be removed (removal is delayed)
        final List<Event> funcEvents = function.getEvents();
        final Set<Event> toBeRemoved = new HashSet<>();
        for(Event e : Lists.reverse(funcEvents)) {
            if (!e.hasTag(NOOPT) && !e.hasTag(ASSERTION)
                    && e instanceof Local regWriter && !usedRegs.contains(regWriter.getResultRegister())) {
                // Invisible RegWriters that write to an unused reg can get removed
                toBeRemoved.add(e);
            } else if (e instanceof RegReader regReader) {
                // An event that was not removed adds its dependencies to the used registers
                regReader.getRegisterReads().stream().map(Register.Read::register).forEach(usedRegs::add);
            }
        }

        // Here is the actual removal
        funcEvents.stream()
                .filter(toBeRemoved::contains)
                .forEach(Event::tryDelete);
    }
}