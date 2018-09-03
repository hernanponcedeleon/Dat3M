package dartagnan.wmm;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.program.Program;
import dartagnan.program.event.filter.FilterAbstract;
import dartagnan.program.event.filter.FilterBasic;
import dartagnan.program.event.filter.FilterUtils;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.axiom.Axiom;
import dartagnan.wmm.relation.*;
import dartagnan.wmm.relation.basic.*;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.*;

/**
 *
 * @author Florian Furbach
 */
public class Wmm implements WmmInterface{


    private static Map<String, String> basicFenceRelations = new HashMap<String, String>();
    static {
        basicFenceRelations.put("mfence", "Mfence");
        basicFenceRelations.put("ish", "Ish");
        basicFenceRelations.put("isb", "Isb");
        basicFenceRelations.put("sync", "Sync");
        basicFenceRelations.put("lwsync", "Lwsync");
        basicFenceRelations.put("isync", "Isync");
    }

    private ArrayList<Axiom> axioms = new ArrayList<>();
    private Map<String, Relation> relations = new HashMap<String, Relation>();
    private Map<String, FilterAbstract> filters = new HashMap<String, FilterAbstract>();

    public void addAxiom(Axiom ax) {
        axioms.add(ax);
    }

    public void addRelation(Relation rel) {
        relations.put(rel.getTerm(), rel);
        relations.put(rel.getName(), rel);
    }

    public Relation getRelation(String name){
        Relation relation = relations.get(name);
        if(relation != null){
            return relation;
        }
        return resolveRelation(name);
    }

    public Relation getRelCartesian(FilterAbstract f1, FilterAbstract f2){
        String term = RelCartesian.makeTerm(f1, f2);
        Relation relation = relations.get(term);
        if(relation == null){
            relation = new RelCartesian(f1, f2);
            addRelation(relation);
        }
        return relation;
    }

    public Relation getRelSetIdentity(FilterAbstract f){
        String term = RelSetIdentity.makeTerm(f);
        Relation relation = relations.get(term);
        if(relation == null){
            relation = new RelSetIdentity(f);
            addRelation(relation);
        }
        return relation;
    }

    public Relation getRelComposition(Relation r1, Relation r2){
        String term = RelComposition.makeTerm(r1, r2);
        Relation relation = relations.get(term);
        if(relation == null){
            relation = new RelComposition(r1, r2);
            addRelation(relation);
        }
        return relation;
    }

    public Relation getRelIntersection(Relation r1, Relation r2){
        String term = RelIntersection.makeTerm(r1, r2);
        Relation relation = relations.get(term);
        if(relation == null){
            relation = new RelIntersection(r1, r2);
            addRelation(relation);
        }
        return relation;
    }

    public Relation getRelMinus(Relation r1, Relation r2){
        String term = RelMinus.makeTerm(r1, r2);
        Relation relation = relations.get(term);
        if(relation == null){
            relation = new RelMinus(r1, r2);
            addRelation(relation);
        }
        return relation;
    }

    public Relation getRelUnion(Relation r1, Relation r2){
        String term = RelUnion.makeTerm(r1, r2);
        Relation relation = relations.get(term);
        if(relation == null){
            relation = new RelUnion(r1, r2);
            addRelation(relation);
        }
        return relation;
    }

    public Relation getRelInverse(Relation r1){
        String term = RelInverse.makeTerm(r1);
        Relation relation = relations.get(term);
        if(relation == null){
            relation = new RelInverse(r1);
            addRelation(relation);
        }
        return relation;
    }

    public Relation getRelTrans(Relation r1){
        String term = RelTrans.makeTerm(r1);
        Relation relation = relations.get(term);
        if(relation == null){
            relation = new RelTrans(r1);
            addRelation(relation);
        }
        return relation;
    }

    public Relation getRelTransRef(Relation r1){
        String term = RelTransRef.makeTerm(r1);
        Relation relation = relations.get(term);
        if(relation == null){
            relation = new RelTransRef(r1);
            addRelation(relation);
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


    public BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception {
        Map<Relation, Set<Tuple>> map = new HashMap<>();
        for (Axiom ax : axioms) {
            map.put(ax.getRel(), ax.getRel().getMaxTupleSet(program));
        }

        for (Axiom ax : axioms) {
            ax.getRel().addEncodeTupleSet(map.get(ax.getRel()));
        }

        BoolExpr enc = ctx.mkTrue();
        Set<String> encodedRels = new HashSet<>();
        for (Axiom ax : axioms) {
            enc = ctx.mkAnd(enc, ax.getRel().encode(program, ctx, encodedRels));
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
        Set<Event> events = program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
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
        Set<Event> events = program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
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

    // TODO: Later these relations should come from included cat files, e.g., "stdlib.cat" or "fences.cat"
    private Relation resolveRelation(String name){
        Relation relation = null;

        if(basicFenceRelations.containsKey(name)) {
            relation = new RelFencerel(basicFenceRelations.get(name), name);

        } else {
            switch (name){
                case "po":
                    relation = new RelPo();
                    break;
                case "loc":
                    relation = new RelLoc();
                    break;
                case "id":
                    relation = new RelId();
                    break;
                case "int":
                    relation = new RelInt();
                    break;
                case "ext":
                    relation = new RelExt();
                    break;
                case "co":
                    relation = new RelCo();
                    break;
                case "rf":
                    relation = new RelRf();
                    break;
                case "rf^-1":
                    relation = new RelInverse(getRelation("rf"));
                    break;
                case "fr":
                    relation = new RelComposition(getRelation("rf^-1"), getRelation("co"), "fr");
                    break;
                case "rfe":
                    relation = new RelIntersection(getRelation("rf"), getRelation("ext"), "rfe");
                    break;
                case "rfi":
                    relation = new RelIntersection(getRelation("rf"), getRelation("int"), "rfi");
                    break;
                case "coe":
                    relation = new RelIntersection(getRelation("co"), getRelation("ext"), "coe");
                    break;
                case "coi":
                    relation = new RelIntersection(getRelation("co"), getRelation("int"), "coi");
                    break;
                case "fre":
                    relation = new RelIntersection(getRelation("fr"), getRelation("ext"), "fre");
                    break;
                case "fri":
                    relation = new RelIntersection(getRelation("fr"), getRelation("int"), "fri");
                    break;
                case "po-loc":
                    relation = new RelIntersection(getRelation("po"), getRelation("loc"), "po-loc");
                    break;
                case "addr":
                    relation = new EmptyRel("addr");
                    break;
                case "0":
                    relation = new EmptyRel("0");
                    break;
                case "(R*W)":
                    relation = new RelCartesian(new FilterBasic("R"), new FilterBasic("W"));
                    break;
                case "idd":
                    relation = new RelIdd();
                    break;
                case "idd^+":
                    relation = new RelTrans(getRelation("idd"));
                    break;
                case "data":
                    relation = new RelIntersection(getRelation("idd^+"), getRelation("(R*W)"), "data");
                    break;
                case "ctrl":
                    if(Relation.EncodeCtrlPo){
                        relation = new RelComposition(new RelComposition(getRelation("idd^+"), getRelation("ctrlDirect")), new RelUnion(getRelation("id"), getRelation("po")), "ctrl");
                    } else {
                        relation = new RelComposition(getRelation("idd^+"), getRelation("ctrlDirect"), "ctrl");
                    }
                    break;
                case "ctrlDirect":
                    relation = new RelCtrlDirect();
                    break;
                case "ctrlisync":
                    relation = new RelIntersection(getRelation("ctrl"), getRelation("isync"), "ctrlisync");
                    break;
                case "ctrlisb":
                    relation = new RelIntersection(getRelation("ctrl"), getRelation("isb"), "ctrlisync");
                    break;
                case "rmw":
                    relation = new RelRMW();
                    break;
                case "crit":
                    relation = new RelCrit();
                    break;
            }
        }

        if(relation != null){
            addRelation(relation);
        }
        return relation;
    }
}
