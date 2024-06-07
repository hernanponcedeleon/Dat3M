package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;

import java.util.List;
import java.util.function.ToIntFunction;
import java.util.stream.Stream;

/*
    Rather than a typical transformer, this pass checks that all loops in the program are in a normalized form
    which is usually provided by LLVM.
    NOTE: It does not itself construct this normalized form, instead it throws exceptions if the form is not met.
    The normalized form guarantees the following:
    - Each loop has a single entry point (its header label)
    - Each loop has a single back jump (the jump that goes back to the header).
      Furthermore, this jump is unconditional.

    As its only side effect, this pass renames the loop header label to indicate the presence of a loop
    and marks the loop header as NOOPT to avoid removal of that label.

    NOTE: This should only be run after BranchReordering since it relies on the linear syntax produced by it.
 */

public class LoopFormVerification implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(LoopFormVerification.class);

    public static LoopFormVerification fromConfig(Configuration config) {
        return new LoopFormVerification();
    }

    @Override
    public void run(Program program) {
        final int numberOfLoops = Stream.concat(program.getThreads().stream(), program.getFunctions().stream())
                .mapToInt(f -> checkAndCountLoops(f, Event::getLocalId)).sum();
        logger.info("Detected {} loops in the program.", numberOfLoops);
    }

    private int checkAndCountLoops(Function function, ToIntFunction<Event> linId) {
        int loopCounter = 0;
        for (Label label : function.getEvents(Label.class)) {
            final List<CondJump> backJumps = label.getJumpSet().stream()
                    .filter(j -> linId.applyAsInt(j) > linId.applyAsInt(label))
                    .toList();
            final boolean isLoop = backJumps.size() > 0;

            if (!isLoop) {
                continue;
            }
            if (backJumps.size() > 1) {
                final String error = String.format("Loop entry label %s has multiple back edges", label);
                throw new MalformedProgramException(error);
            }

            loopCounter++;
            final Label loopBegin = label;
            loopBegin.setName(String.format("%s%s", loopBegin.getName(), LoopUnrolling.LOOP_LABEL_IDENTIFIER));
            loopBegin.addTags(Tag.NOOPT);

            final CondJump uniqueBackJump = backJumps.get(0);
            if (!uniqueBackJump.isGoto()) {
                final String error = String.format("Loop back jump %s is conditional.", uniqueBackJump);
                throw new MalformedProgramException(error);
            }

            final List<Label> loopBodyLabels = loopBegin.getSuccessor().getSuccessors().stream()
                    .takeWhile(ev -> ev != uniqueBackJump)
                    .filter(Label.class::isInstance).map(Label.class::cast)
                    .toList();
            for (Label l : loopBodyLabels) {
                final boolean isLoopEntryPoint = l.getJumpSet().stream().anyMatch(j ->
                        linId.applyAsInt(j) < linId.applyAsInt(loopBegin) ||
                                linId.applyAsInt(j) > linId.applyAsInt(uniqueBackJump));
                if (isLoopEntryPoint) {
                    final String error = String.format("Loop body label %s inside loop %s" +
                            " has entry edges from outside the loop", l, loopBegin);
                    throw new MalformedProgramException(error);
                }
            }
        }
        return loopCounter;
    }

}
