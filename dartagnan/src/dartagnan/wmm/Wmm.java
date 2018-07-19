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
import dartagnan.program.event.filter.FilterAbstract;
import dartagnan.program.event.filter.FilterBasic;
import dartagnan.program.event.filter.FilterUtils;
import dartagnan.wmm.axiom.Axiom;
import dartagnan.wmm.relation.*;

import java.util.*;

/**
 *
 * @author Florian Furbach
 */
public class Wmm implements WmmInterface{

    private ArrayList<Axiom> axioms = new ArrayList<>();
    protected Map<String, Relation> relations = new HashMap<String, Relation>();
    protected Map<String, FilterAbstract> filters = new HashMap<String, FilterAbstract>();

    public void addAxiom(Axiom ax) {
        axioms.add(ax);
    }

    public void addRelation(Relation rel) {
        relations.put(rel.getName(), rel);
    }

    public Relation getRelation(String name){
        Relation relation = relations.get(name);
        if(relation == null){
            if(WmmUtils.basicRelations.contains(name)) {
                relation = new BasicRelation(name);

                // TODO: Temporary dirty solution
                if(name.equals("ctrlisync")){
                    addRelation(new RelFencerel("Isync", "isync"));
                }
                if(name.equals("ctrlisb")){
                    addRelation(new RelFencerel("Isb", "isb"));
                }

                // TODO: Temporary dirty solution
            } else if(WmmUtils.basicFenceRelations.containsKey(name)){
                relation = new RelFencerel(WmmUtils.basicFenceRelations.get(name), name);

                // TODO: Temporary dirty solution
            } else if(name.equals("rmw")){
                return new RelRMW();

                // TODO: Temporary dirty solution
            } else if(name.equals("addr") || name.equals("0")){
                return new EmptyRel(name);

                // TODO: Temporary dirty solution
            } else if(name.equals("data")){
                addRelation(new RelCartesian(new FilterBasic("R"), new FilterBasic("W")));
                return new RelInterSect(new RelLocTrans(new BasicRelation("idd")), new BasicRelation("RW"), "data");
            }
        }
        return relation;
    }

    public void addFilter(FilterAbstract filter) {
        filters.put(filter.getName(), filter);
    }

    public FilterAbstract getFilter(String name){
        FilterAbstract filter = filters.get(name);
        if(filter == null){
            name = FilterUtils.resolve(name);
            if(name != null){
                filter = new FilterBasic(name);
            }
        }
        return filter;
    }

    /**
     * Encodes  all relations in the model according to the predicate and approximate settings.
     * @param program
     * @param ctx
     * @return the encoding of the relations.
     * @throws Z3Exception
     */
    public BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception {

        BoolExpr enc = ctx.mkTrue();

        Set<String> encodedRels = new HashSet<>();
        for (Axiom ax : axioms) {
            enc = ctx.mkAnd(enc, ax.getRel().encode(program, ctx, encodedRels));
        }
        for (Map.Entry<String, Relation> relation : relations.entrySet()){
            enc = ctx.mkAnd(enc, relation.getValue().encode(program, ctx, encodedRels));
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

        for (Map.Entry<String, Relation> relation : relations.entrySet()) {
            if(relation.getValue().getIsNamed()){
                result.append(relation.getValue());
                result.append("\n");
            }
        }

        for (Map.Entry<String, FilterAbstract> filter : filters.entrySet()){
            result.append(filter.getValue());
            result.append("\n");
        }

        return result.toString();
    }
}
