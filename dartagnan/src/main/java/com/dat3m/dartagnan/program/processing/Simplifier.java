package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.*;
import com.google.common.base.Preconditions;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

public class Simplifier implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(Simplifier.class);

    private Simplifier() { }

    public static Simplifier newInstance() {
        return new Simplifier();
    }

    public static Simplifier fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance(); // There is nothing to configure
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(!program.isUnrolled(), "Simplifying should be performed before unrolling.");
        // Some simplification are only applicable after others.
        // Thus we apply them iteratively until we reach a fixpoint.
        logger.info("pre-simplification: " + program.getEvents().size() + " events");

        for (Thread t : program.getThreads()) {
            if (simplify(t)) {
                t.clearCache();
            }
        }
        program.clearCache(false);

        logger.info("post-simplification: " + program.getEvents().size() + " events");
    }

    private boolean simplify(Thread t) {
        Event pred = t.getEntry();
        boolean hasAnyChanges = false;
        while (true) {
            Event next = pred.getSuccessor();
            if (next == null) {
                break;
            }
            if (simplifyEvent(pred, next)) {
                hasAnyChanges = true;
            } else {
                // If nothing has changed, we proceed to the next event
                pred = pred.getSuccessor();
            }
        }

        return hasAnyChanges;
    }


    private boolean simplifyEvent(Event pred, Event next) {
        boolean changed = false;
        if (next instanceof CondJump) {
            changed = simplifyJump(pred, (CondJump) next);
        } else if (next instanceof Label) {
            changed = simplifyLabel(pred, (Label) next);
        } else if (next instanceof FunCall) {
            changed = simplifyFunCall(pred, (FunCall) next);
        }
        return changed;
    }

    private boolean simplifyJump(Event pred, CondJump jump) {
        Label label = jump.getLabel();
        Event successor = jump.getSuccessor();
        BExpr expr = jump.getGuard();
        if(label.equals(successor) && expr instanceof BConst) {
            label.getListeners().remove(jump);
            pred.setSuccessor(successor);
            return true;
        }
        return false;
    }

    private boolean simplifyLabel(Event pred, Label label) {
        if (label.getListeners().isEmpty() && !label.getName().startsWith("END_OF_T")) {
            pred.setSuccessor(label.getSuccessor());
            return true;
        }
        return false;
    }

    private boolean simplifyFunCall(Event pred, FunCall call) {
        // If simplifyEvent returns false, the function is either non-empty or we reached the return statement
        while (simplifyEvent(call, call.getSuccessor())) { }

        // Check if we reached the return statement
        Event successor = call.getSuccessor();
        if(successor instanceof FunRet && ((FunRet)successor).getFunctionName().equals(call.getFunctionName())) {
            // We skip the function call + the function return
            pred.setSuccessor(successor.getSuccessor());
            return true;
        }
        return false;
    }
}