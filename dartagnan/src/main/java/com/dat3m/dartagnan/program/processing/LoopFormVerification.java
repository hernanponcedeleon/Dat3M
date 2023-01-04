package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.utils.printer.Printer;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;

import java.util.List;
import java.util.stream.Collectors;

/*
    Rather than a transformer, this pass checks that all loops in the program are in a normalized form
    which is usually provided by LLVM.
    NOTE: It does not itself construct this normalized form, instead it throws exceptions if the form is not met.
    The normalized form guarantees the following:
    - Each loop has a single entry point (its header label)
    - Each loop has a single back edge (the jump that goes back to the header)

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
        int numberOfLoops = program.getThreads().stream().mapToInt(this::run).sum();
        logger.info("Detected {} loops in the program.", numberOfLoops);

        System.out.println(new Printer().print(program));
    }

    private int run(Thread thread) {
        final Event entry = thread.getEntry();

        int loopCounter = 0;
        for (Event e : entry.getSuccessors()) {
            if (e instanceof Label) {
                final Label loopBegin = (Label) e;
                final List<CondJump> backJumps = loopBegin.getJumpSet().stream()
                        .filter(j -> j.getOId() > loopBegin.getOId())
                        .collect(Collectors.toList());
                final boolean isLoop = backJumps.size() > 0;

                if (!isLoop) {
                    continue;
                }

                if (backJumps.size() > 1) {
                    final String error = String.format("Loop entry label %s has multiple back edges", loopBegin);
                    throw new MalformedProgramException(error);
                }

                loopCounter++;
                loopBegin.setName(String.format("%s.loop", loopBegin.getName()));
                loopBegin.addFilters(Tag.NOOPT);

                final CondJump uniqueBackJump = backJumps.get(0);
                final List<Label> loopBodyLabels = loopBegin.getSuccessor().getSuccessors().stream()
                        .takeWhile(ev -> ev != uniqueBackJump)
                        .filter(Label.class::isInstance).map(Label.class::cast)
                        .collect(Collectors.toList());

                for (Label l : loopBodyLabels) {
                    final boolean isLoopEntryPoint = l.getJumpSet().stream()
                            .anyMatch(j -> j.getOId() < loopBegin.getOId() || j.getOId() > uniqueBackJump.getOId());
                    if (isLoopEntryPoint) {
                        final String error = String.format("Loop body label %s inside loop %s" +
                                " has entry edges from outside the loop", l, loopBegin);
                        throw new MalformedProgramException(error);
                    }
                }
            }
        }

        return loopCounter;
    }
}
