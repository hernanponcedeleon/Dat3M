package com.dat3m.dartagnan.utils.symmetry;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;

import java.util.Set;
import java.util.stream.Collectors;


// A first rough implementation for symmetry reduction
public class SymmetryReduction {

    private final ThreadSymmetry symm;

    public SymmetryReduction(Program prog) {
        this.symm = new ThreadSymmetry(prog, false);
    }

    public void apply() {

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
    }
}
