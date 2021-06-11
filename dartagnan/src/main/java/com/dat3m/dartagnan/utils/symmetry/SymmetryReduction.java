package com.dat3m.dartagnan.utils.symmetry;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;

import java.util.List;
import java.util.stream.Collectors;


// A first rough implementation for symmetry reduction
public class SymmetryReduction {

    private final ThreadSymmetry symm;
    private final Program program;

    public SymmetryReduction(Program prog) {
        this.program = prog;
        this.symm = new ThreadSymmetry(prog);
    }

    public void apply() {

        List<EquivalenceClass<Thread>> symmClasses = symm.getAllEquivalenceClasses().stream().filter(c -> c.size() > 1).collect(Collectors.toList());
        if (symmClasses.isEmpty()) {
            return;
        }
        Thread rep = symmClasses.get(0).getRepresentative();
        if (rep.getEvents().stream().noneMatch(x -> x.is(EType.ASSERTION))) {
            return;
        }

        rep.setName(rep.getName() + "_unique");

        for (Thread t : symmClasses.get(0).stream().filter(x -> x != rep).collect(Collectors.toList())) {
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
