package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.lang.svcomp.SpinStart;
import com.google.common.collect.Sets;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/*
    This pass finds and marks simple loops that are totally side-effect-free (simple spin loops).
    It will also mark side-effect-full loops if they are annotated by a SpinStart event
    (we assume the user guarantees the correctness of the annotation)

    The pass is unable to detect complex types of loops that may spin endlessly (i.e. run into a deadlock)
    while producing side effects. It will also fail to mark loops with conditional side effects.

    TODO: Instead of tagging labels as spinning and checking for that tag during loop unrolling
          we could let this pass produce LoopBound-Annotations to guide the unrolling implicitly.

    TODO 2: Intrinsic calls need to get special treatment as they might be side-effect-full
     (for now, all our intrinsics are side-effect-free, so it works fine).
 */
public class SimpleSpinLoopDetection implements FunctionProcessor {

    private SimpleSpinLoopDetection() { }

    public static SimpleSpinLoopDetection newInstance() {
        return new SimpleSpinLoopDetection();
    }

    public static SimpleSpinLoopDetection fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    // --------------------------------------------------------------

    @Override
    public void run(Function function) {
        if (function.hasBody()) {
            detectAndMarkSpinLoops(function);
        }
    }

    private int detectAndMarkSpinLoops(Function function) {
        final List<Label> unmarkedLabels = function.getEvents(Label.class).stream()
                .filter(e -> !e.hasTag(Tag.SPINLOOP)).toList();

        int spinloopCounter = 0;
        for (final Label label : unmarkedLabels) {
            final List<CondJump> backjumps = label.getJumpSet()
                    .stream().filter(x -> x.getGlobalId() > label.getGlobalId())
                    .toList();
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
            // No need to check if the loop is side effect free,
            // the user guarantees this by using the annotation.

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
            if (cur.hasTag(Tag.WRITE) || (cur instanceof FunctionCall call
                    && (!call.isDirectCall() || call.getCalledFunction().getIntrinsicInfo().writesMemory()))) {
                // We assume side effects for all writes, writing intrinsics, or unresolved function calls.
                return false;
            }

            if (cur instanceof RegReader regReader) {
                final Set<Register> readRegs = regReader.getRegisterReads().stream()
                        .map(Register.Read::register).collect(Collectors.toSet());
                unsafeRegisters.addAll(Sets.difference(readRegs, safeRegisters));
            }

            if (cur instanceof RegWriter writer) {
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