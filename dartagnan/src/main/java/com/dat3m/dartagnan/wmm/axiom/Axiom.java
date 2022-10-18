package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public abstract class Axiom implements Constraint {

    protected final Relation rel;
    protected final boolean negated;
    // Marks if the axiom should be use to report properties rather than filter consistency
    protected final boolean flag;
    protected String name;

    Axiom(Relation rel, boolean negated, boolean flag) {
        this.rel = rel;
        this.negated = negated;
        this.flag = flag;
    }

    public void configure(Configuration config) throws InvalidConfigurationException { }

    @Override
    public List<? extends Relation> getConstrainedRelations() {
        return Collections.singletonList(rel);
    }

    public Relation getRelation() {
        return rel;
    }

    /**
     * Users have the option to not enforce consistency checks, but rather 
     * to use axioms to report properties of the candidate execution. 
     * To do so, users must prefix the axioms they are interested in with 
     * the keyword flag.
     */
    public boolean isFlagged() {
        return flag;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNameOrTerm() {
        return name != null ? name : toString();
    }

    protected abstract Set<Tuple> getEncodeTupleSet(Context analysisContext);

    @Override
    public Map<Relation, Set<Tuple>> getEncodeTupleSets(VerificationTask task, Context analysisContext) {
        return Map.of(rel, getEncodeTupleSet(analysisContext));
    }

    @Override
    public abstract String toString();

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