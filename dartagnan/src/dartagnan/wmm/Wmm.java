/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dartagnan.wmm;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.program.Program;
import dartagnan.program.event.filter.FilterBasic;
import dartagnan.wmm.axiom.Axiom;
import dartagnan.wmm.relation.RelCartesian;
import dartagnan.wmm.relation.RelFencerel;
import dartagnan.wmm.relation.Relation;

import java.util.*;

/**
 *
 * @author Florian Furbach
 */
public class Wmm implements WmmInterface{

    // Map is used here instead of Set in order to avoid duplicates on ctrlisync and ctrlsibs
    // TODO: Change to Set when ctrlisync and ctrlsibs are encoded as derived relations
    private Map<String, RelFencerel> fenceRelations = new HashMap<String, RelFencerel>();

    private ArrayList<Axiom> axioms = new ArrayList<>();
    private final ArrayList<Relation> relations = new ArrayList<>();

    private Set<RelCartesian> cartesianRelations = new HashSet<>(Arrays.asList(
            new RelCartesian(new FilterBasic("I"), new FilterBasic("M"), "IM"),
            new RelCartesian(new FilterBasic("I"), new FilterBasic("R"), "IR"),
            new RelCartesian(new FilterBasic("I"), new FilterBasic("W"), "IW"),

            new RelCartesian(new FilterBasic("M"), new FilterBasic("I"), "MI"),
            new RelCartesian(new FilterBasic("R"), new FilterBasic("I"), "RI"),
            new RelCartesian(new FilterBasic("W"), new FilterBasic("I"), "WI"),

            new RelCartesian(new FilterBasic("R"), new FilterBasic("M"), "RM"),
            new RelCartesian(new FilterBasic("R"), new FilterBasic("R"), "RR"),
            new RelCartesian(new FilterBasic("R"), new FilterBasic("W"), "RW"),

            new RelCartesian(new FilterBasic("W"), new FilterBasic("M"), "WM"),
            new RelCartesian(new FilterBasic("W"), new FilterBasic("R"), "WR"),
            new RelCartesian(new FilterBasic("W"), new FilterBasic("W"), "WW")
    ));

    public void addAxiom(Axiom ax) {
        axioms.add(ax);
    }

    public void addRel(Relation rel) {
        relations.add(rel);
    }

    public void addFenceRelation(RelFencerel rel){
        if(!(fenceRelations.containsKey(rel.getName()))){
            fenceRelations.put(rel.getName(), rel);
        }
    }

    /**
     * Encodes  all relations in the model according to the predicate and approximate settings.
     * @param program
     * @param ctx
     * @return the encoding of the relations.
     * @throws Z3Exception
     */
    public BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception {

        BoolExpr enc = RelFencerel.encodeBatch(program, ctx, fenceRelations.values());

        if(program.hasRMWEvents()){
            cartesianRelations.addAll(Arrays.asList(
                    new RelCartesian(new FilterBasic("M"), new FilterBasic("A"), "MA"),
                    new RelCartesian(new FilterBasic("A"), new FilterBasic("M"), "AM")
            ));
            enc = ctx.mkAnd(enc, Domain.encodeRMW(program, ctx));
        }

        for(RelCartesian relation : cartesianRelations){
            enc = ctx.mkAnd(enc, relation.encode(program, ctx, null));
        }

        Set<String> encodedRels = new HashSet<>();
        for (Axiom ax : axioms) {
            enc = ctx.mkAnd(enc, ax.getRel().encode(program, ctx, encodedRels));
        }
        for (Relation relation : relations) {
            enc = ctx.mkAnd(enc, relation.encode(program, ctx, encodedRels));
        }
        return enc;
    }

    /**
     * 
     * @param program
     * @param ctx
     * @return encoding that ensures all axioms are satisfied and the execution is consistent.
     * @throws Z3Exception
     */
    public BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
        Set<Event> events = program.getMemEvents();
        BoolExpr expr = ctx.mkTrue();
        for (Axiom ax : axioms) {
            expr = ctx.mkAnd(expr, ax.Consistent(events, ctx));
        }
        return expr;
    }

    /**
     *
     * @param program
     * @param ctx
     * @return encoding that ensures one axiom is not satisfied and the execution is not consistent.
     * @throws Z3Exception
     */
    public BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
        Set<Event> events = program.getMemEvents();
        BoolExpr expr = ctx.mkFalse();
        for (Axiom ax : axioms) {
            expr = ctx.mkOr(expr, ax.Inconsistent(events, ctx));
        }
        return expr;
    }

    /**
     * A string representation of the model.
     * @return String
     */
    public String toString() {
        StringBuilder result = new StringBuilder();

        for (Axiom axiom : axioms) {
            result.append(axiom);
            result.append("\n");
        }

        for (Relation relation : relations) {
            if(relation.getIsNamed()){
                result.append(relation);
                result.append("\n");
            }
        }

        return result.toString();
    }
}
