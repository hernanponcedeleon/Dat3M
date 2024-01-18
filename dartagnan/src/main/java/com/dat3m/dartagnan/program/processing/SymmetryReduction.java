package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Assert;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.Set;


/**
 * A SymmetryReduction pass goes through all symmetry classes of the program threads
 * and designates in each a single thread (the representative).
 * It removes all assertions from non-designated threads thereby making them asymmetric
 * to the designated thread (hence the symmetries get reduced).
 * In the resultant program, only designated threads are able to trigger assertion violations / bugs.
 * This procedure is only sound if all symmetric threads have the same capability of triggering a violation assertion.
 * This may not be the case if symmetric threads have assertions that distinguish between the executing threads (by e.g.
 * using the local thread id or the input parameter in the assertion in an asymmetric manner)
 * E.g. "assert(tid == 3)" is a thread-distinguishing assertion which would make this pass unsound.
 */
public class SymmetryReduction implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(SymmetryReduction.class);

    private SymmetryReduction() { }

    public static SymmetryReduction newInstance() {
        return new SymmetryReduction();
    }

    public static SymmetryReduction fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    public void run(Program program) {
        ThreadSymmetry symm = ThreadSymmetry.withoutSymmetryMappings(program);
        Set<? extends EquivalenceClass<Thread>> symmClasses = symm.getNonTrivialClasses();
        if (symmClasses.isEmpty()) {
            return;
        }

        for (EquivalenceClass<Thread> c : symmClasses) {
            Thread rep = c.getRepresentative();
            if (rep.getEvents(Assert.class).isEmpty()) {
                continue;
            }

            rep.setName(rep.getName() + "__symm_unique");

            for (Thread t : c.stream().filter(x -> x != rep).toList()) {
                for (Event e : t.getEvents(Assert.class)) {
                    e.getSuccessor().tryDelete();
                    e.tryDelete();
                }
            }
        }

        logger.info("Reduced symmetry of {} many symmetry classes", symmClasses.size());

    }
}