package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.google.common.collect.Lists;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.*;

// This is just Dead Store Elimination, but the use of the term "Store" can be confusing in our setting 
public class DeadAssignmentElimination implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(DeadAssignmentElimination.class);

    private DeadAssignmentElimination() { }

    public static DeadAssignmentElimination newInstance() {
        return new DeadAssignmentElimination();
    }

    public static DeadAssignmentElimination fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    @Override
    public void run(Program program) {
        logger.info("#Events before DSE: " + program.getEvents().size());

        for (Thread t : program.getThreads()) {
            eliminateDeadAssignments(program, t);
        }
        logger.info("#Events after DSE: " + program.getEvents().size());
    }

    private void eliminateDeadAssignments(Program program, Thread thread) {
        Set<Register> usedRegs = new HashSet<>();
        // Registers that are used by other threads and assertions cannot be removed
        if(program.getAss() != null) {
            usedRegs.addAll(program.getAss().getRegs()); // for litmus tests
        }
        program.getEvents().stream()
                .filter(e -> e.is(ASSERTION))
                .filter(RegWriter.class::isInstance)
                .map(RegWriter.class::cast)
                .map(RegWriter::getResultRegister)
                .forEach(usedRegs::add);
        program.getEvents().stream()
                .filter(o -> !o.getThread().equals(thread))
                .filter(RegReaderData.class::isInstance)
                .forEach(o -> usedRegs.addAll(((RegReaderData)o).getDataRegs()));


        // Compute events to be removed (removal is delayed)
        final List<Event> threadEvents = thread.getEvents();
        final Set<Event> toBeRemoved = new HashSet<>();
        for(Event e : Lists.reverse(threadEvents)) {
            if (e instanceof RegWriter && !e.is(NOOPT) && !e.is(VISIBLE) && !usedRegs.contains(((RegWriter)e).getResultRegister())) {
                // TODO (TH): Can we also remove loads to unused registers here?
                // Invisible RegWriters that write to an unused reg can get removed
                toBeRemoved.add(e);
            } else {
                // An event that was not removed adds its dependencies to the used registers
                if (e instanceof RegReaderData) {
                    // Data & Ctrl dependencies
                    usedRegs.addAll(((RegReaderData) e).getDataRegs());
                }
                if (e instanceof MemEvent) {
                    // Address dependencies
                    usedRegs.addAll(((MemEvent) e).getAddress().getRegs());
                }
            }
        }

        // Here is the actual removal
        threadEvents.stream()
                .filter(toBeRemoved::contains)
                .forEach(Event::delete);
    }
}