package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.annotations.FunCall;
import com.dat3m.dartagnan.program.event.core.annotations.FunRet;
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
        return newInstance();
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(!program.isUnrolled(), "Simplifying should be performed before unrolling.");

        logger.info("pre-simplification: " + program.getEvents().size() + " events");
        for (Thread thread : program.getThreads()) {
            simplify(thread);
        }
        logger.info("post-simplification: " + program.getEvents().size() + " events");
    }

    private void simplify(Function func) {
        Event cur = func.getEntry();
        Event next;
        while ((next = cur.getSuccessor()) != null) {
            // Some simplifications are only applicable after others.
            // Thus, we apply them iteratively until we reach a fixpoint.
            if (!simplifyEvent(next)) {
                // If nothing has changed, we proceed to the next event
                cur = next;
            }
        }
    }

    private boolean simplifyEvent(Event next) {
        if (next.hasTag(Tag.NOOPT)) {
            return false;
        }
        boolean changed = false;
        if (next instanceof CondJump jump) {
            changed = simplifyJump(jump);
        } else if (next instanceof Label label) {
            changed = simplifyLabel(label);
        } else if (next instanceof FunCall fc) {
            changed = simplifyFunCall(fc);
        }
        return changed;
    }

    private boolean simplifyJump(CondJump jump) {
        final Label jumpTarget = jump.getLabel();
        final Event successor = jump.getSuccessor();
        final Expression guard = jump.getGuard();
        if(jumpTarget.equals(successor) && guard instanceof BConst) {
            return jump.tryDelete();
        }
        return false;
    }

    private boolean simplifyLabel(Label label) {
        if (label.getJumpSet().isEmpty() && label != label.getFunction().getExit()) {
            return label.tryDelete();
        }
        return false;
    }

    private boolean simplifyFunCall(FunCall call) {
        // If simplifyEvent returns false, the function is either non-empty or we reached the return statement
        while (simplifyEvent(call.getSuccessor())) { }

        // Check if we reached the return statement
        final Event successor = call.getSuccessor();
        if(successor instanceof FunRet funRet && funRet.getFunctionName().equals(call.getFunctionName())) {
            call.tryDelete();
            successor.tryDelete();
            return true;
        }
        return false;
    }
}