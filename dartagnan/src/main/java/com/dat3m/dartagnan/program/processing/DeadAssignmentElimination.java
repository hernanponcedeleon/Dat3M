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
import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;

// This is just Dead Store Elimination, but the use of the term "Store" can be confusing in our setting 
public class DeadAssignmentElimination implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(DeadAssignmentElimination.class);
    private Program program;

    private DeadAssignmentElimination() { }

    public static DeadAssignmentElimination newInstance() {
        return new DeadAssignmentElimination();
    }

    public static DeadAssignmentElimination fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    @Override
    public void run(Program program) {
    	this.program = program;
        logger.info("#Events before DSE: " + program.getEvents().size());

        for (Thread t : program.getThreads()) {
            eliminateDeadStores(t);
            t.clearCache();
        }
        program.clearCache(false);

        logger.info("#Events after DSE: " + program.getEvents().size());
    }

    private void eliminateDeadStores(Thread thread) {
        Set<Event> removed = new HashSet<>();

        // Registers that are used by other threads or assertions cannot be removed
        Set<Register> usedRegs = new HashSet<>(program.getAss().getRegs());
        program.getEvents().stream()
                .filter(o -> !o.getThread().equals(thread))
                .filter(o -> o instanceof RegReaderData)
                .forEach(o -> usedRegs.addAll(((RegReaderData)o).getDataRegs()));

        for(Event e : Lists.reverse(thread.getEvents())) {
            if (e instanceof RegWriter && !e.is(VISIBLE) && !usedRegs.contains(((RegWriter)e).getResultRegister())) {
                // Invisible RegWriters that write to an unused reg can get removed
                removed.add(e);
            }
            // An event that was not removed adds its dependencies to the used registers
            if (!removed.contains(e)) {
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
        Event pred = null;
        Event cur = thread.getEntry();
        while (cur != null) {
            if (removed.contains(cur)) {
                cur.delete(pred);
                cur = pred;
            }
            pred = cur;
            cur = cur.getSuccessor();
        }
    }
}