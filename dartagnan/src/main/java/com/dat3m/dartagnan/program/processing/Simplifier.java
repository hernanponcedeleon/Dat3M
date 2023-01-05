package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.annotations.FunCall;
import com.dat3m.dartagnan.program.event.core.annotations.FunRet;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import static com.dat3m.dartagnan.configuration.OptionNames.PRINT_PROGRAM_AFTER_SIMPLIFICATION;

@Options
public class Simplifier implements ProgramProcessor {

    // =========================== Configurables ===========================

	@Option(name = PRINT_PROGRAM_AFTER_SIMPLIFICATION,
            description = "Prints the program after simplification.",
            secure = true)
    private boolean print = false;

    // =====================================================================

	private static final Logger logger = LogManager.getLogger(Simplifier.class);

    private Simplifier() { }

    private Simplifier(Configuration config) throws InvalidConfigurationException {
        this();
        config.inject(this);
    }

    public static Simplifier newInstance() {
        return new Simplifier();
    }

    public static Simplifier fromConfig(Configuration config) throws InvalidConfigurationException {
        return new Simplifier(config);
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(!program.isUnrolled(), "Simplifying should be performed before unrolling.");

        logger.info("pre-simplification: " + program.getEvents().size() + " events");
        program.getThreads().stream().filter(this::simplify).forEach(Thread::clearCache);
        program.clearCache(false);
        logger.info("post-simplification: " + program.getEvents().size() + " events");

        if(print) {
        	System.out.println("===== Program after simplification =====");
        	System.out.println(new Printer().print(program));
        	System.out.println("========================================");
        }
    }

    private boolean simplify(Thread t) {
        boolean hasAnyChanges = false;

        Event cur = t.getEntry();
        Event next;
        while ((next = cur.getSuccessor()) != null) {
            if (simplifyEvent(next)) {
                // Some simplifications are only applicable after others.
                // Thus, we apply them iteratively until we reach a fixpoint.
                hasAnyChanges = true;
            } else {
                // If nothing has changed, we proceed to the next event
                cur = next;
            }
        }

        return hasAnyChanges;
    }


    private boolean simplifyEvent(Event next) {
        if (next.is(Tag.NOOPT)) {
            return false;
        }
        boolean changed = false;
        if (next instanceof CondJump) {
            changed = simplifyJump((CondJump) next);
        } else if (next instanceof Label) {
            changed = simplifyLabel((Label) next);
        } else if (next instanceof FunCall) {
            changed = simplifyFunCall((FunCall) next);
        }
        return changed;
    }

    private boolean simplifyJump(CondJump jump) {
        final Label jumpTarget = jump.getLabel();
        final Event successor = jump.getSuccessor();
        final BExpr guard = jump.getGuard();
        if(jumpTarget.equals(successor) && guard instanceof BConst) {
            jump.delete();
            return true;
        }
        return false;
    }

    private boolean simplifyLabel(Label label) {
        if (label.getJumpSet().isEmpty() && label != label.getThread().getExit()) {
            label.delete();
            return true;
        }
        return false;
    }

    private boolean simplifyFunCall(FunCall call) {
        // If simplifyEvent returns false, the function is either non-empty or we reached the return statement
        while (simplifyEvent(call.getSuccessor())) { }

        // Check if we reached the return statement
        final Event successor = call.getSuccessor();
        if(successor instanceof FunRet && ((FunRet)successor).getFunctionName().equals(call.getFunctionName())) {
            final Event ret = successor;
            call.delete();
            ret.delete();
            return true;
        }
        return false;
    }
}