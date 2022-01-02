package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.utils.symmetry.ThreadSymmetry;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.Set;
import java.util.stream.Collectors;


// A first rough implementation for symmetry reduction
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

        ThreadSymmetry symm = new ThreadSymmetry(program, false);
        Set<? extends EquivalenceClass<Thread>> symmClasses = symm.getNonTrivialClasses();
        if (symmClasses.isEmpty()) {
            return;
        }

        for (EquivalenceClass<Thread> c : symmClasses) {
            Thread rep = c.getRepresentative();
            if (rep.getEvents().stream().noneMatch(x -> x.is(EType.ASSERTION))) {
                continue;
            }

            rep.setName(rep.getName() + "__symm_unique");

            for (Thread t : c.stream().filter(x -> x != rep).collect(Collectors.toList())) {
                Event pred = null;
                for (Event e : t.getEvents()) {
                    if (e.is(EType.ASSERTION)) {
                        e.delete(pred);
                        e.getSuccessor().delete(pred);
                    }
                    pred = e;
                }
                t.clearCache();
            }
        }

        logger.info("Reduced symmetry of {} many symmetry classes", symmClasses.size());

    }
}