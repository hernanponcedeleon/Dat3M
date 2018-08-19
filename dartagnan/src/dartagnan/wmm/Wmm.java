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
import dartagnan.wmm.relation.basic.RelCrit;
import dartagnan.wmm.relation.basic.RelRMW;

import java.util.*;

/**
 *
 * @author Florian Furbach
 */
public class Wmm implements WmmInterface{

    private static Set<String> basicRelations = new HashSet<String>(Arrays.asList(
            "id", "int", "ext", "loc", "po",
            "rf", "fr", "co",
            "idd", "ctrlDirect", "ctrl"
    ));

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
        relations.put(rel.getName(), rel);
    }

    public Relation getRelation(String name){
        Relation relation = relations.get(name);
        if(relation != null){
            return relation;
        }

        if(basicRelations.contains(name)) {
            return new BasicRelation(name);
        }

        return resolveRelation(name);
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
                case "rfe":
                    relation = new RelInterSect(new BasicRelation("rf"), new BasicRelation("ext"), "rfe");
                    break;
                case "rfi":
                    relation = new RelInterSect(new BasicRelation("rf"), new BasicRelation("int"), "rfi");
                    break;
                case "coe":
                    relation = new RelInterSect(new BasicRelation("co"), new BasicRelation("ext"), "coe");
                    break;
                case "coi":
                    relation = new RelInterSect(new BasicRelation("co"), new BasicRelation("int"), "coi");
                    break;
                case "fre":
                    relation = new RelInterSect(new BasicRelation("fr"), new BasicRelation("ext"), "fre");
                    break;
                case "fri":
                    relation = new RelInterSect(new BasicRelation("fr"), new BasicRelation("int"), "fri");
                    break;
                case "po-loc":
                    relation = new RelInterSect(new BasicRelation("po"), new BasicRelation("loc"), "po-loc");
                    break;
                case "addr":
                    relation = new EmptyRel("addr");
                    break;
                case "0":
                    relation = new EmptyRel("0");
                    break;
                case "data":
                    Relation RW = new RelCartesian(new FilterBasic("R"), new FilterBasic("W"));
                    Relation iddInv = new RelTrans(new BasicRelation("idd")).setEventMask(EventRepository.EVENT_MEMORY | EventRepository.EVENT_LOCAL | EventRepository.EVENT_IF);
                    addRelation(RW);
                    addRelation(iddInv);
                    relation = new RelInterSect(iddInv, RW, "data");
                    break;
                case "ctrlisync":
                    Relation isync = new RelFencerel("Isync", "isync");
                    addRelation(isync);
                    relation = new RelInterSect(new BasicRelation("ctrl"), isync, "ctrlisync");
                    break;
                case "ctrlisb":
                    Relation isb = new RelFencerel("Isb", "isb");
                    addRelation(isb);
                    relation = new RelInterSect(new BasicRelation("ctrl"), isb, "ctrlisb");
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
