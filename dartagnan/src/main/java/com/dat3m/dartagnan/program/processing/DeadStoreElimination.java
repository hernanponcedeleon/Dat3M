package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;

import static com.dat3m.dartagnan.program.event.Tag.READ;
import static com.dat3m.dartagnan.program.event.Tag.REG_WRITER;

import java.util.ArrayList;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

public class DeadStoreElimination implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(DeadStoreElimination.class);

    private DeadStoreElimination() { }

    public static DeadStoreElimination newInstance() {
        return new DeadStoreElimination();
    }

    public static DeadStoreElimination fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    @Override
    public void run(Program program) {
        logger.info("#Events before DSE: " + program.getEvents().size());

        for (Thread t : program.getThreads()) {
            eliminateDeadStores(t);
            t.clearCache();
        }
        program.clearCache(false);

        logger.info("#Events after DSE: " + program.getEvents().size());
    }

    private void eliminateDeadStores(Thread thread) {
    	
    	List<Event> removed = new ArrayList<>();
    	
    	// We traverse the events in inverse order and mark those that can be removed
    	ArrayList<Event> sorted = new ArrayList<Event>(thread.getEvents());
    	sorted.sort((Event e1, Event e2) -> e2.compareTo(e1));
    	for(Event e : sorted) {
    		// We cannot remove load events
    		if(e.is(REG_WRITER) && !e.is(READ)) {
    			RegWriter rw = (RegWriter)e;
    			if(e.getSuccessors().stream()
    					.filter(s -> s instanceof RegReaderData && !removed.contains(s))
    					.noneMatch(s -> ((RegReaderData)s).getDataRegs().contains(rw.getResultRegister()))) {
    				removed.add(e);
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