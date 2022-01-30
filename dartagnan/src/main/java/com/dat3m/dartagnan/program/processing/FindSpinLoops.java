package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.lang.svcomp.LoopEnd;
import com.google.common.base.Preconditions;
import com.google.common.collect.Sets;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

@Options
public class FindSpinLoops implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(FindSpinLoops.class);
    
    private int spinloops = 0;

    // =========================== Configurables ===========================

    // =====================================================================

    private FindSpinLoops() { }

    private FindSpinLoops(Configuration config) throws InvalidConfigurationException {
        this();
        config.inject(this);
    }

    public static FindSpinLoops fromConfig(Configuration config) throws InvalidConfigurationException {
        return new FindSpinLoops(config);
    }

    public static FindSpinLoops newInstance() {
        return new FindSpinLoops();
    }


    @Override
    public void run(Program program) {
        Preconditions.checkArgument(!program.isUnrolled(), getClass().getSimpleName() + " should be performed before unrolling.");
        for(Thread thread : program.getThreads()){
            markAnnotatedSpinLoops(thread);
            detectAndMarkSpinLoops(thread);
        }
        program.clearCache(false);

        logger.info("# of spinloops: {}", spinloops);
}

    private void markAnnotatedSpinLoops(Thread t){
    	Event pred = t.getEntry();
        Event curr = pred.getSuccessor();
        while (curr != null) {
        	if(curr instanceof LoopEnd) {
        		// This assume the following implementation of await_while
        		// #define await_while(cond)                                                  \
        	    // for (int tmp = (__VERIFIER_loop_begin(), 0); __VERIFIER_spin_start(),  \
        	    //     tmp = cond, __VERIFIER_spin_end(!tmp), tmp;)
        		Event spinloop = curr.getSuccessors().stream().filter(e -> e instanceof CondJump && ((CondJump)e).isGoto()).findFirst().get();
        		spinloop.addFilters(Tag.SPINLOOP);
                ((CondJump)spinloop).getLabel().addFilters(Tag.SPINLOOP);
        		spinloops++;
        	}
            curr = curr.getSuccessor();
        }

        t.clearCache();
    }

    private void detectAndMarkSpinLoops(Thread t) {
        Event curr = t.getEntry();
        while (curr != null) {
            // Find start of spinloop that is not already marked.
            if (curr instanceof Label && !curr.is(Tag.SPINLOOP)) {
                Label label = (Label) curr;
                Optional<Event> listener = label.getListeners().stream().filter(x -> x.getOId() > label.getOId()).findFirst();
                if (listener.isPresent()) {
                    Label loopStart = label;
                    CondJump loopEnd = (CondJump) listener.get();
                    if (isSideEffectFree(loopStart, loopEnd)) {
                        loopStart.addFilters(Tag.SPINLOOP);
                        loopEnd.addFilters(Tag.SPINLOOP);
                        spinloops++;
                    }
                }
            }
            curr = curr.getSuccessor();

        }

        t.clearCache();
    }

    private boolean isSideEffectFree(Label loopBegin, CondJump loopEnd) {
        Event cur = loopBegin.getSuccessor();
        // Unsafe means the loop read from the registers before writing to them.
        Set<Register> unsafeRegisters = new HashSet<>();
        // Safe means the loop wrote to these register before using them
        Set<Register> safeRegisters = new HashSet<>();
        while (cur != loopEnd) {

            if (cur instanceof MemEvent) {
                if (cur.is(Tag.WRITE)) {
                    return false; // Writes always cause side effects
                }
                MemEvent memEvent = (MemEvent) cur;
                Set<Register> addrRegs = memEvent.getAddress().getRegs();
                unsafeRegisters.addAll(Sets.difference(addrRegs, safeRegisters));
            }

            if (cur instanceof RegReaderData) {
                RegReaderData reader = (RegReaderData) cur;
                Set<Register> dataRegs = reader.getDataRegs();
                unsafeRegisters.addAll(Sets.difference(dataRegs, safeRegisters));
            }

            if (cur instanceof RegWriter) {
                RegWriter writer = (RegWriter) cur;
                if (unsafeRegisters.contains(writer.getResultRegister())) {
                    return false;
                } else {
                    safeRegisters.add(writer.getResultRegister());
                }
            }

            cur = cur.getSuccessor();
        }
        return true;
    }
}