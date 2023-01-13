package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/*
    This pass transforms this code:
        """
        if (cond) goto X;  // Block 1
        moreCode           // (same) Block 1
        """
    to the following code:
        """
        if (cond) goto X; // Block 1
           goto Y;        // Block 1
        Y:                // (new) Block 2
        moreCode          // Block 2
        """
    This makes Block 2 a basic block, that can be moved around as done by BranchReordering.

    NOTE: LLVM and also SMACK already make sure that all blocks are "basic".
    However, our parser "destroys" this structure during parsing.
 */
public class ComplexBlockSplitting implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(ComplexBlockSplitting.class);

    private ComplexBlockSplitting() {}

    public static ComplexBlockSplitting newInstance() { return new ComplexBlockSplitting(); }

    @Override
    public void run(Program program) {
        final int numBlockSplittings = program.getThreads().stream().mapToInt(this::run).sum();

        logger.info("Split {} complex blocks.", numBlockSplittings);
        program.clearCache(true);
        EventIdReassignment.newInstance().run(program);
    }

    private int run(Thread thread) {
        int numSplittings = 0;
        // These are the jumps where we insert labels to split the containing block into two simpler blocks.
        final List<CondJump> splittingPoints = thread.getEvents().stream()
                .filter(CondJump.class::isInstance).map(CondJump.class::cast)
                .filter(j -> !j.isGoto() && !(j.getSuccessor() instanceof CondJump))
                .collect(Collectors.toList());
        final Map<String, Integer> labelName2OccurrenceMap = new HashMap<>();
        for (CondJump condJump : splittingPoints) {
            final String targetLabelName = condJump.getLabel().getName();
            final String newLabelName = String.format("%s_%d", targetLabelName,
                    labelName2OccurrenceMap.compute(targetLabelName, (k, v) -> v == null ? 2 : v + 1));
            final Label blockLabel = EventFactory.newLabel(newLabelName);
            final CondJump gotoLabel = EventFactory.newGoto(blockLabel);

            condJump.insertAfter(gotoLabel);
            gotoLabel.insertAfter(blockLabel);
            numSplittings++;
        }

        return numSplittings;
    }
}
