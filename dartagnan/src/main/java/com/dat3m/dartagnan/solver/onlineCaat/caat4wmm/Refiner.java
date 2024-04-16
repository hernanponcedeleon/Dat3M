package com.dat3m.dartagnan.solver.onlineCaat.caat4wmm;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.solver.onlineCaat.caat4wmm.RefinementModel;
import com.dat3m.dartagnan.solver.onlineCaat.caat4wmm.coreReasoning.AddressLiteral;
import com.dat3m.dartagnan.solver.onlineCaat.caat4wmm.coreReasoning.CoreLiteral;
import com.dat3m.dartagnan.solver.onlineCaat.caat4wmm.coreReasoning.ExecLiteral;
import com.dat3m.dartagnan.solver.onlineCaat.caat4wmm.coreReasoning.RelLiteral;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.wmm.Relation;
import com.google.common.collect.Lists;
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

    public record ConflictLiteral(BooleanFormula var, boolean value) {
        @Override
        public String toString() {
            return (value ? "" : "!") + var;
        }
    }

    public record Conflict(List<ConflictLiteral> assignment) {

        public List<BooleanFormula> getVariables() { return Lists.transform(assignment, ConflictLiteral::var); }

        public BooleanFormula toFormula(BooleanFormulaManager bmgr) {
            return assignment.stream()
                    .map(l -> l.value ? l.var : bmgr.not(l.var))
                    .reduce(bmgr.makeTrue(), bmgr::and);
        }
    }

    public List<Conflict> computeConflicts(DNF<CoreLiteral> coreReasons, EncodingContext context) {
        final BooleanFormulaManager bmgr  = context.getBooleanFormulaManager();
        final List<Conflict> conflicts = new ArrayList<>();
        for (Conjunction<CoreLiteral> reason : coreReasons.getCubes()) {
            List<ConflictLiteral> assignment = new ArrayList<>();
            for (CoreLiteral lit : reason.getLiterals()) {
                final ConflictLiteral conflictLiteral = toConflictLiteral(lit, context);
                if (bmgr.isFalse(conflictLiteral.var) && conflictLiteral.value) {
                    assignment = null;
                    break;
                } else {
                    assignment.add(conflictLiteral);
                }
            }
            if (assignment != null) {
                conflicts.add(new Conflict(assignment));
            }
        }
        return conflicts;
    }

    private ConflictLiteral toConflictLiteral(CoreLiteral literal, EncodingContext encoder) {
        final BooleanFormula enc;
        if (literal instanceof ExecLiteral lit) {
            enc = encoder.execution(lit.getEvent());
        } else if (literal instanceof AddressLiteral loc) {
            enc = encoder.sameAddress((MemoryCoreEvent) loc.getFirst(), (MemoryCoreEvent) loc.getSecond());
        } else if (literal instanceof RelLiteral lit) {
            final Relation rel = refinementModel.translateToBase(lit.getRelation());
            enc = encoder.edge(rel, lit.getSource(), lit.getTarget());
        } else {
            throw new IllegalArgumentException("CoreLiteral " + literal.toString() + " is not supported");
        }

        return new ConflictLiteral(enc, literal.isPositive());
    }

}
