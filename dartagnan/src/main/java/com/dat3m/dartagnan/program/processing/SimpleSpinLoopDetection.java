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
import com.dat3m.dartagnan.program.event.lang.svcomp.SpinStart;
import com.google.common.base.Preconditions;
import com.google.common.collect.Sets;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/*
    This pass finds and marks simple loops that are totally side effect free (simple spin loops).
    It will also mark side-effect-full loops if they are annotated by a SpinStart event
    (we assume the user guarantees the correctness of the annotation)

    The pass is unable to detect complex types of loops that may spin endlessly (i.e. run into a deadlock)
    while producing side effects. It will also fail to mark loops with conditional side effects.

    TODO: Instead of tagging labels as spinning and checking for that tag during loop unrolling
          we could let this pass produce LoopBound-Annotations to guide the unrolling implicitly.
 */
public class SimpleSpinLoopDetection implements ProgramProcessor {

    private SimpleSpinLoopDetection() { }

    public static SimpleSpinLoopDetection newInstance() {
        return new SimpleSpinLoopDetection();
    }

    public static SimpleSpinLoopDetection fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    // --------------------------------------------------------------

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(!program.isUnrolled(),
                getClass().getSimpleName() + " should be performed before unrolling.");

        program.getThreads().forEach(this::detectAndMarkSpinLoops);
    }
    private int detectAndMarkSpinLoops(Thread thread) {
        final List<Label> unmarkedLabels = thread.getEvents().stream()
                .filter(e -> e instanceof Label && !e.hasTag(Tag.SPINLOOP))
                .map(Label.class::cast).collect(Collectors.toList());

        int spinloopCounter = 0;
        for (final Label label : unmarkedLabels) {
            final List<CondJump> backjumps = label.getJumpSet()
                    .stream().filter(x -> x.getGlobalId() > label.getGlobalId())
                    .collect(Collectors.toList());
            final boolean isLoop = !backjumps.isEmpty();

            if (isLoop) {
                assert backjumps.size() == 1; // Invariant holds for all normalized loops
                final CondJump backjump = backjumps.get(0);
                if (isSideEffectFree(label, backjump)) {
                    label.addTags(Tag.SPINLOOP, Tag.NOOPT);
                    backjump.addTags(Tag.SPINLOOP, Tag.NOOPT);
                    spinloopCounter++;
                }
            }
        }
        return spinloopCounter;
    }

    private boolean isSideEffectFree(Label loopBegin, CondJump loopEnd) {
        if (loopBegin.getSuccessor() instanceof SpinStart) {
            // No need to check if the loop is side effect free
            // The user guarantees this by using the annotation.

            // This checks assumes the following implementation of await_while
            // #define await_while(cond)                                                  \
            // for (int tmp = (__VERIFIER_loop_begin(), 0); __VERIFIER_spin_start(),  \
            //     tmp = cond, __VERIFIER_spin_end(!tmp), tmp;)
            return true;
        }

        // Unsafe means the loop read from the registers before writing to them.
        Set<Register> unsafeRegisters = new HashSet<>();
        // Safe means the loop wrote to these register before using them
        Set<Register> safeRegisters = new HashSet<>();

        Event cur = loopBegin;
        while ((cur = cur.getSuccessor()) != loopEnd) {
            if (cur.hasTag(Tag.WRITE)) {
                return false;// Writes always cause side effects
            }

            if (cur instanceof MemEvent) {
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
        }
        return true;
    }
}