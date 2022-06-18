package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Collections;
import java.util.List;
import java.util.Objects;

/**
 *
 * @author Florian Furbach
 */
public abstract class Axiom implements Dependent<Relation> {

    protected final Relation rel;
    protected final boolean negated;
    protected final boolean flag;

    protected VerificationTask task;
    protected Context analysisContext;

    Axiom(Relation rel, boolean negated, boolean flag) {
        this.rel = rel;
        this.negated = negated;
        this.flag = flag;
    }

    public void initializeEncoding(SolverContext ctx) {
        Preconditions.checkState(this.task != null,
                "No available relation data to encode. Perform RelationAnalysis before encoding.");
    }

    public void initializeRelationAnalysis(VerificationTask task, Context context) {
        this.task = task;
        this.analysisContext = context;
    }

    @Override
    public List<Relation> getDependencies() {
        return Collections.singletonList(rel);
    }

    public Relation getRelation() {
        return rel;
    }

    public boolean isFlagged() {
        return flag;
    }

    @Override
    public abstract String toString();

    public abstract TupleSet getEncodeTupleSet();

    public abstract BooleanFormula consistent(SolverContext ctx);

    public BooleanFormula extractionVariable(SolverContext ctx) {
    	return ctx.getFormulaManager().getBooleanFormulaManager().makeVariable(this + " violation");
    };
    
    @Override
    public int hashCode() {
        return Objects.hash(rel);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || obj.getClass() != this.getClass()) {
            return false;
        }
        Axiom other = (Axiom)obj;
        return this.rel.equals(other.rel);
    }


    // ===================== Utility methods ===================
    
    public boolean isEmptiness() {
    	return this instanceof Empty;
    }
    
    public boolean isAcyclicity() {
    	return this instanceof Acyclic;
    }
    
    public boolean isIrreflexivity() {
    	return this instanceof Irreflexive;
    }
}