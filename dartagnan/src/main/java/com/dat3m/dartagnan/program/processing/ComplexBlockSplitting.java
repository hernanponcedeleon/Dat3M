package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
public class ComplexBlockSplitting implements FunctionProcessor {

    private static final Logger logger = LogManager.getLogger(ComplexBlockSplitting.class);

    private ComplexBlockSplitting() {}

    public static ComplexBlockSplitting newInstance() { return new ComplexBlockSplitting(); }

    @Override
    public void run(Function function) {
        if (function.hasBody()) {
            splitBlocks(function);
        }
    }

    private int splitBlocks(Function function) {
        int numSplittings = 0;
        // These are the jumps where we insert labels to split the containing block into two simpler blocks.
        final List<CondJump> splittingPoints = function.getEvents(CondJump.class).stream()
                .filter(j -> !j.isGoto() && !(j.getSuccessor() instanceof CondJump)).toList();
        final Map<String, Integer> labelName2OccurrenceMap = new HashMap<>();
        for (CondJump condJump : splittingPoints) {
            final String targetLabelName = condJump.getLabel().getName();
            final String newLabelName = String.format("%s_else_%d", targetLabelName,
                    labelName2OccurrenceMap.compute(targetLabelName, (k, v) -> v == null ? 1 : v + 1));
            final Label blockLabel = EventFactory.newLabel(newLabelName);
            final CondJump gotoLabel = EventFactory.newGoto(blockLabel);

            blockLabel.copyAllMetadataFrom(condJump);
            gotoLabel.copyAllMetadataFrom(condJump);

            condJump.insertAfter(gotoLabel);
            gotoLabel.insertAfter(blockLabel);
            numSplittings++;
        }

        return numSplittings;
    }

}
