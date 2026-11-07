package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.LiveRegistersAnalysis;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Local;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

import static com.dat3m.dartagnan.program.processing.LoopUnrolling.LOOP_LABEL_IDENTIFIER;

/*
    This pass rotates "while" loops whose header only tests a condition into "do-while" form,
    if this makes the loop free of loop-carried registers.

        L:                                  L:
            H  (Locals/Loads)                   H
            if !c goto EXIT                     if !c goto EXIT
        C:                          ==>     C:
            Body                                Body
            goto L                              H'                 // copy of H
                                                if !c goto EXIT
                                                goto C
        EXIT:                               EXIT:

    The transformation only duplicates code and preserves the sequence of events executed by every path,
    so it is sound independently of the memory model.

    Motivation: in an await loop "while (f) { f = load(x); }" the flag "f" is live at the header "L",
    so an iteration that reads a new value counts as a local side effect for DynamicSpinLoopDetection.
    After rotation, "f" is defined before use in every iteration, i.e., it is not live at the new header "C",
    and the loop becomes side-effect-free (statically bounded by 1).

    We rotate only if this removes all loop-carried registers, i.e., some register written in the loop is live
    at "L" but none is live at "C".
 */
public class LoopRotation implements FunctionProcessor {

    private static final Logger logger = LoggerFactory.getLogger(LoopRotation.class);

    private final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private LoopRotation() { }

    public static LoopRotation newInstance() {
        return new LoopRotation();
    }

    @Override
    public void run(Function function) {
        final List<LoopAnalysis.LoopInfo> loops = LoopAnalysis.onFunction(function).getLoopsOfFunction(function);
        if (loops.isEmpty()) {
            return;
        }
        final LiveRegistersAnalysis liveness = LiveRegistersAnalysis.forFunction(function);
        int rotated = 0;
        for (LoopAnalysis.LoopInfo loop : loops) {
            if (tryRotate(loop.iterations().getFirst(), liveness)) {
                rotated++;
            }
        }
        if (rotated > 0) {
            IdReassignment.newInstance().run(function);
            logger.debug("Rotated {} loops in function {}.", rotated, function.getName());
        }
    }

    private boolean tryRotate(LoopAnalysis.LoopIterationInfo loop, LiveRegistersAnalysis liveness) {
        if (!(loop.getIterationStart() instanceof Label header) || !(loop.getIterationEnd() instanceof CondJump backJump)
                || !backJump.isGoto() || backJump.getLabel() != header) {
            return false;
        }
        final Set<Event> body = new HashSet<>(loop.computeBody());

        // The back jump must be the only jump into the header from inside the loop.
        if (header.getJumpSet().stream().anyMatch(j -> j != backJump && body.contains(j))) {
            return false;
        }

        // The header must consist of side-effect-free events followed by the exit test.
        final List<Event> headerEvents = new ArrayList<>();
        Event cur = header.getSuccessor();
        while (cur instanceof Local || cur instanceof Load) {
            headerEvents.add(cur);
            cur = cur.getSuccessor();
        }
        if (!(cur instanceof CondJump test) || test.isGoto() || test == backJump) {
            return false;
        }

        final Label exit;
        final Label continueLabel;
        final Expression exitCondition;
        if (!body.contains(test.getLabel())) {
            // "if c goto EXIT; C: ..."
            if (!(test.getSuccessor() instanceof Label next)) {
                return false;
            }
            exit = test.getLabel();
            continueLabel = next;
            exitCondition = test.getGuard();
        } else if (test.getSuccessor() instanceof CondJump gotoExit && gotoExit.isGoto() && gotoExit != backJump
                && !body.contains(gotoExit.getLabel()) && gotoExit.getSuccessor() == test.getLabel()) {
            // "if c goto C; goto EXIT; C: ..."
            exit = gotoExit.getLabel();
            continueLabel = test.getLabel();
            exitCondition = expressions.makeNot(test.getGuard());
        } else {
            return false;
        }
        if (!body.contains(continueLabel) || continueLabel.getJumpSet().stream().anyMatch(j -> j != test)) {
            // Other jumps to the new header would introduce additional back jumps.
            return false;
        }

        // Rotate only if this removes all loop-carried registers.
        final Set<Register> written = new HashSet<>();
        for (Event e : body) {
            if (e instanceof RegWriter writer) {
                written.add(writer.getResultRegister());
            }
        }
        final boolean carriedAtHeader = liveness.getLiveRegistersAt(header).stream().anyMatch(written::contains);
        final boolean carriedAtContinue = liveness.getLiveRegistersAt(continueLabel).stream().anyMatch(written::contains);
        if (!carriedAtHeader || carriedAtContinue) {
            return false;
        }

        // ---------- Transformation ----------
        final List<Event> latch = new ArrayList<>(headerEvents.stream().map(Event::getCopy).toList());
        final CondJump exitJump = EventFactory.newJump(exitCondition, exit);
        exitJump.copyAllMetadataFrom(test);
        latch.add(exitJump);
        backJump.insertBefore(latch);
        backJump.updateReferences(Map.of(header, continueLabel));

        if (header.getName().endsWith(LOOP_LABEL_IDENTIFIER)) {
            header.setName(header.getName().substring(0, header.getName().length() - LOOP_LABEL_IDENTIFIER.length()));
        }
        continueLabel.setName(continueLabel.getName() + LOOP_LABEL_IDENTIFIER);
        continueLabel.addTags(Tag.NOOPT);
        return true;
    }
}
