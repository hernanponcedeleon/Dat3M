package com.dat3m.dartagnan.solver.caat4wmm;

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

    private final RefinementModel refinementModel;
    public Refiner(RefinementModel refinementModel) {
        this.refinementModel = refinementModel;
    }

    public BooleanFormula refine(DNF<CoreLiteral> coreReasons, EncodingContext context) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        List<BooleanFormula> refinement = new ArrayList<>();
        for (Conjunction<CoreLiteral> reason : coreReasons.getCubes()) {
            BooleanFormula clause = bmgr.makeFalse();
            for (CoreLiteral lit : reason.getLiterals()) {
                final BooleanFormula litFormula = encode(lit, context);
                if (bmgr.isFalse(litFormula)) {
                    clause = bmgr.makeTrue();
                    break;
                } else {
                    clause = bmgr.or(clause, bmgr.not(litFormula));
                }
            }
            if (!bmgr.isTrue(clause)) {
                refinement.add(clause);
            }
        }
        return bmgr.and(refinement);
    }

    private BooleanFormula encode(CoreLiteral literal, EncodingContext encoder) {
        final BooleanFormulaManager bmgr = encoder.getBooleanFormulaManager();
        final BooleanFormula enc;
        if (literal instanceof ExecLiteral lit) {
            enc = encoder.execution(lit.getEvent());
        } else if (literal instanceof AddressLiteral loc) {
            enc = encoder.sameAddress((MemoryCoreEvent) loc.getFirst(), (MemoryCoreEvent) loc.getSecond());
        } else if (literal instanceof RelLiteral lit) {
            final Relation rel = refinementModel.translateToBase(lit.getRelation());
            enc = encoder.edge(rel, lit.getSource(), lit.getTarget());
        } else {
            throw new IllegalArgumentException("CoreLiteral " + literal + " is not supported");
        }

        return literal.isNegative() ? bmgr.not(enc) : enc;
    }

}
