package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.relation.binary.BinaryRelation;
import com.dat3m.dartagnan.wmm.relation.unary.UnaryRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.List;

public abstract class Relation implements Dependent<Relation> {

    protected String name;

    public Relation(String name) {
        this.name = name;
    }

    public abstract Definition getDefinition();

    public abstract <T> T accept(Definition.Visitor<? extends T> visitor);

    public abstract BooleanFormula getSMTVar(Tuple tuple, EncodingContext context);

    public abstract String getTerm();

    @Override
    public List<Relation> getDependencies() {
        List<Relation> relations = getDefinition().getConstrainedRelations();
        // no copying required, as long as getConstrainedRelations() returns a new or unmodifiable list
        return relations.subList(1, relations.size());
    }

    public void configure(Configuration config) throws InvalidConfigurationException { }

    public String getName() {
        return name != null ? name : getTerm();
    }

    public Relation setName(String name){
        this.name = name;
        return this;
    }

    public boolean getIsNamed(){
        return name != null;
    }

    @Override
    public String toString(){
        if(name != null){
            return name + " := " + getTerm();
        }
        return getTerm();
    }

    @Override
    public int hashCode(){
        return getName().hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        return getName().equals(((Relation)obj).getName());
    }

    // ========================== Utility methods =========================

    public boolean isStaticRelation() {
    	return this instanceof StaticRelation;
    }

    public boolean isUnaryRelation() {
    	return this instanceof UnaryRelation;
    }

    public boolean isBinaryRelation() {
    	return this instanceof BinaryRelation;
    }

    public boolean isRecursiveRelation() {
    	return this instanceof RecursiveRelation;
    }

    public Relation getInner() {
        return (isUnaryRelation() || isRecursiveRelation()) ? getDependencies().get(0) : null;
    }

    public Relation getFirst() {
    	return isBinaryRelation() ? getDependencies().get(0) : null;
    }

    public Relation getSecond() {
    	return isBinaryRelation() ? getDependencies().get(1) : null;
    }
}
