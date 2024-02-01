package com.dat3m.dartagnan.solver.onlineCaat;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.AddressLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.CoreLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.ExecLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.RelLiteral;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.wmm.Relation;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.ArrayList;
import java.util.List;

/*
    This class handles the computation of refinement clauses from violations found by the WMM-solver procedure.
 */
public class Refiner {

    public Refiner() { }

    public record Conflict(List<BooleanFormula> assignment) {}

    public List<Conflict> computeConflicts(DNF<CoreLiteral> coreReasons, EncodingContext context) {
        final List<Conflict> conflicts = new ArrayList<>();
        for (Conjunction<CoreLiteral> reason : coreReasons.getCubes()) {
            List<BooleanFormula> assignment = new ArrayList<>();
            for (CoreLiteral lit : reason.getLiterals()) {
                final BooleanFormula litFormula = encode(lit, context);
                assignment.add(litFormula);
            }
            conflicts.add(new Conflict(assignment));
        }
        return conflicts;
    }

    private BooleanFormula encode(CoreLiteral literal, EncodingContext encoder) {
        final BooleanFormulaManager bmgr = encoder.getBooleanFormulaManager();
        final BooleanFormula enc;
        if (literal instanceof ExecLiteral lit) {
            enc = encoder.execution(lit.getData());
        } else if (literal instanceof AddressLiteral loc) {
            enc = encoder.sameAddress((MemoryCoreEvent) loc.getFirst(), (MemoryCoreEvent) loc.getSecond());
        } else if (literal instanceof RelLiteral lit) {
            final Relation rel = encoder.getTask().getMemoryModel().getRelation(lit.getName());
            enc = encoder.edge(rel, lit.getData().first(), lit.getData().second());
        } else {
            throw new IllegalArgumentException("CoreLiteral " + literal.toString() + " is not supported");
        }

        return literal.isNegative() ? bmgr.not(enc) : enc;
    }

}
