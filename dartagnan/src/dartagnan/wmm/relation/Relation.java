/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public abstract class Relation {

    /**
     * Describes whether the encoding process uses an over-approximation which is only suitable for checking consistency, NOT inconsistency.
     */
    public static boolean Approx = false;
    public static boolean CloseApprox = false;
    public static boolean PostFixApprox = false;

    protected String name;
    protected String term;
    protected boolean containsRec;
    protected boolean isNamed;
    protected Set<Relation> namedRelations = new HashSet<>();

    /**
     * Creates a relation with an automatically generated identifier.
     * @param name
     */
    public Relation(String name) {
        this.name = name;
        this.term = name;
    }

    /**
     * Creates a relation that is explicitly named either for recursion or readability.
     * @param name (manually chosen)
     * @param term (automatically generated)
     */
    public Relation(String name, String term) {
        namedRelations.add(this);
        this.name = name;
        this.term = term;
        isNamed = true;
    }

    /**
     * @return boolean
     */
    public boolean getIsNamed(){
        return isNamed;
    }

    /**
     *
     * @return all named relations that this relation revers to.
     */
    public Set<Relation> getNamedRelations() {
        return namedRelations;
    }

    /**
     *
     * @return the name of the relation (with a prefix if that was set for aramis)
     */
    public String getName() {
        return name;
    }

    /**
     * This is only used by the parser where a relation is defined and named later.
     * Only use this method before relations depending on this one are encoded!!!
     * @param name
     */
    public void setName(String name){
        this.name=name;
        if (!namedRelations.contains(this))namedRelations.add(this);
        isNamed = true;
    }

    /**
     * The term that defines the relation.
     * @return String
     */
    public String toString(){
        if(isNamed) return String.format("%s := %s", name, term);
        else return String.format("%s", name);
    }
    
    /**
     * Recursively encodes this relation and all its children according to the predicate and approximate settings.
     * @param program
     * @param ctx
     * @param encodedRels contains all relations that were already encoded.
     * @return the encoding of this relation and all its children.
     * @throws Z3Exception
     */
    public abstract BoolExpr encode(Program program, Context ctx, Set<String> encodedRels) throws Z3Exception;
    
    /**
     * 
     * @param program
     * @param ctx
     * @return the enooding of 
     * @throws Z3Exception this relation only.
     */
    protected abstract BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception;
    
    /**
     * 
     * @param program
     * @param ctx
     * @return the approximate encoding of this relation only.
     * @throws Z3Exception
     */
    public BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception{
        return this.encodeBasic(program, ctx);
    }
    
    /**
     * 
     * @param program
     * @param ctx
     * @return the predicate based encoding of this relation only.
     * @throws Z3Exception
     */
    protected abstract BoolExpr encodePredicateBasic(Program program, Context ctx) throws Z3Exception;

    /**
     *
     * @param program
     * @param ctx
     * @return the approximate predicate based encoding of this relation only.
     * @throws Z3Exception
     */
    protected abstract BoolExpr encodePredicateApprox(Program program, Context ctx) throws Z3Exception;

}
