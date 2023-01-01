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
import com.dat3m.dartagnan.program.event.lang.svcomp.LoopStart;
import com.google.common.base.Preconditions;
import com.google.common.collect.Sets;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

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

	// This method assumes the following implementation of await_while
	// #define await_while(cond)                                                  \
    // for (int tmp = (__VERIFIER_loop_begin(), 0); __VERIFIER_spin_start(),  \
    //     tmp = cond, __VERIFIER_spin_end(!tmp), tmp;)
    private void markAnnotatedSpinLoops(Thread t){
        Event curr = t.getEntry();
        while (curr != null) {
            // Find start of spinloop.
            if (curr.getSuccessor() instanceof LoopStart) {
            	if(!(curr instanceof Label)) {
            		logger.warn("LoopStart does not match expected use (it should be preceded by a Label)");
            		continue;
            	}
                final Label label = (Label) curr;
                // This looks for all backjumps to the label
                final List<CondJump> backjumps = label.getJumpSet()
                        .stream().filter(x -> x.getOId() > label.getOId())
                        .collect(Collectors.toList());
                final boolean isLoop = !backjumps.isEmpty();

                if (isLoop) {
                    // No need to check if the loop is side effect free
                	// The user guarantees this by using the annotation
                	label.addFilters(Tag.SPINLOOP, Tag.NOOPT);
                    backjumps.forEach(x -> x.addFilters(Tag.SPINLOOP, Tag.NOOPT));
                    spinloops++;
                }
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
                final Label label = (Label) curr;
                final List<CondJump> backjumps = label.getJumpSet()
                        .stream().filter(x -> x.getOId() > label.getOId())
                        .sorted().collect(Collectors.toList());
                final boolean isLoop = !backjumps.isEmpty();

                if (isLoop) {
                    // Importantly, this looks for the LAST backjump to the loop start
                    final CondJump loopEnd = backjumps.get(backjumps.size() - 1);
                    final Label loopStart = label;
                    if (isSideEffectFree(loopStart, loopEnd)) {
                        loopStart.addFilters(Tag.SPINLOOP, Tag.NOOPT);
                        backjumps.forEach(x -> x.addFilters(Tag.SPINLOOP, Tag.NOOPT));
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
                final Set<Register> addrRegs = ((MemEvent) cur).getAddress().getRegs();
                unsafeRegisters.addAll(Sets.difference(addrRegs, safeRegisters));
            }

            if (cur instanceof RegReaderData) {
                final Set<Register> dataRegs = ((RegReaderData) cur).getDataRegs();
                unsafeRegisters.addAll(Sets.difference(dataRegs, safeRegisters));
            }

            if (cur instanceof RegWriter) {
                final RegWriter writer = (RegWriter) cur;
                if (unsafeRegisters.contains(writer.getResultRegister())) {
                    // The loop writes to a register it previously read from.
                    // This means the next loop iteration will observe the newly written value,
                    // hence the loop is not side effect free.
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