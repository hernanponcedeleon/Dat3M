package com.dat3m.dartagnan.smt;

import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class EncodingUtils {

    private final FormulaManagerExt fmgr;

    EncodingUtils(FormulaManagerExt fmgr) {
        this.fmgr = fmgr;
    }

    // -----------------------------------------------------------------------------------------------
    // Cardinality constraints

    public BooleanFormula atLeastOne(Collection<BooleanFormula> formulas) {
        return fmgr.getBooleanFormulaManager().or(formulas);
    }

    public BooleanFormula atMostOnePairwise(List<BooleanFormula> formulas) {
        final BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        final List<BooleanFormula> enc = new ArrayList<>(formulas.size() * (formulas.size() - 1) / 2);
        for (int i = 0; i < formulas.size(); i++) {
            for (int j = i + 1; j < formulas.size(); j++) {
                enc.add(bmgr.or(bmgr.not(formulas.get(i)), bmgr.not(formulas.get(j))));
            }
        }
        return bmgr.and(enc);
    }

    // NOTE: This method generates helper variables using <uniqueIdent>, so the user must ensure
    // that the identifier is unique.
    public BooleanFormula exactlyOneSequence(List<BooleanFormula> formulas, String uniqueIdent) {
        final BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        if (formulas.size() <= 1) {
            return atLeastOne(formulas);
        }

        final String seqVarName = "seqVar_" + uniqueIdent + "#";
        final List<BooleanFormula> enc = new ArrayList<>(2*formulas.size() - 1);
        BooleanFormula lastSeqVar = formulas.get(0);
        for (int i = 1; i < formulas.size(); i++) {
            final BooleanFormula newSeqVar = bmgr.makeVariable(seqVarName + i);
            enc.add(bmgr.equivalence(newSeqVar, bmgr.or(lastSeqVar, formulas.get(i))));
            enc.add(bmgr.not(bmgr.and(formulas.get(i), lastSeqVar)));
            lastSeqVar = newSeqVar;
        }
        enc.add(lastSeqVar); // NOTE: without this line, we get an at-most-one encoding

        return bmgr.and(enc);
    }

    // -----------------------------------------------------------------------------------------------
    // Symmetry constraints

    /*
        Encodes that any assignment obeys "r1 <= r2" where the order is
        the lexicographic order based on "false < true".
        In other words, for all assignments to the variables of r1/r2,
        the first time r1(i) and r2(i) get different truth values,
        we will have r1(i) = FALSE and r2(i) = TRUE.

        NOTE: This method generates helper variables using <uniqueIdent>, so the user must ensure
              that the identifier is unique.
    */
    public BooleanFormula encodeLexLeader(List<BooleanFormula> r1, List<BooleanFormula> r2, String uniqueIdent) {
        Preconditions.checkArgument(r1.size() == r2.size());
        final BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        // Return TRUE if there is nothing to encode
        if (r1.isEmpty()) {
            return bmgr.makeTrue();
        }
        final int size = r1.size();
        final String helperVarName = "y_" + uniqueIdent + "#";

        // We interpret the variables of <ri> as x1(ri), ..., xn(ri).
        // We create helper variables y0, ..., y(n-1) (note the index shift compared to xi)
        // xi gets related to y(i-1) and yi

        final List<BooleanFormula> enc = new ArrayList<>(3 * size);
        BooleanFormula ylast = bmgr.makeVariable(helperVarName + 0); // y(i-1)
        enc.add(ylast);
        // From x1 to x(n-1)
        for (int i = 1; i < size; i++) {
            final BooleanFormula y = bmgr.makeVariable(helperVarName + i); // yi
            final BooleanFormula a = r1.get(i - 1); // xi(r1)
            final BooleanFormula b = r2.get(i - 1); // xi(r2)
            enc.add(bmgr.or(y, bmgr.not(ylast), bmgr.not(a))); // (see below)
            enc.add(bmgr.or(y, bmgr.not(ylast), b));           // "y(i-1) implies ((xi(r1) >= xi(r2))  =>  yi)"
            enc.add(bmgr.or(bmgr.not(ylast), bmgr.not(a), b)); // "y(i-1) implies (xi(r1) <= xi(r2))"
            // NOTE: yi = TRUE means the prefixes (x1, x2, ..., xi) of the rows r1/r2 are equal
            //       yi = FALSE means that no conditions are imposed on xi
            // The first point, where y(i-1) is TRUE but yi is FALSE, is the breaking point
            // where xi(r1) < xi(r2) holds (afterwards all yj (j >= i+1) are unconstrained and can be set to
            // FALSE by the solver)
            ylast = y;
        }
        // Final iteration for xn is handled differently as there is no variable yn anymore.
        final BooleanFormula a = r1.get(size - 1);
        final BooleanFormula b = r2.get(size - 1);
        enc.add(bmgr.or(bmgr.not(ylast), bmgr.not(a), b));

        return bmgr.and(enc);
    }


}
