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
import dartagnan.wmm.relation.utils.RelationRepository;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.*;

/**
 *
 * @author Florian Furbach
 */
public class Wmm implements WmmInterface{

    private ArrayList<Axiom> axioms = new ArrayList<>();
    private Map<String, FilterAbstract> filters = new HashMap<String, FilterAbstract>();
    private List<Set<RecursiveRelation>> recGroups = new ArrayList<>();
    private RelationRepository relationRepository = new RelationRepository();

    public void addAxiom(Axiom ax) {
        axioms.add(ax);
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

    public RelationRepository getRelationRepository(){
        return relationRepository;
    }

    public void addRecursiveGroup(Set<RecursiveRelation> group){
        Set<RecursiveRelation> newGroup = new HashSet<>(group);
        recGroups.add(newGroup);
    }

    public BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception {

        for(Relation relation : relationRepository.getRelations()){
            relation.initialise(program);
        }

        for(Set<RecursiveRelation> group : recGroups){
            boolean changed = true;
            while(changed){
                changed = false;
                for(RecursiveRelation relation : group){
                    relation.setIsActive();
                    int oldSize = relation.getMaxTupleSet().size();
                    if(oldSize != relation.getMaxTupleSetRecursive().size()){
                        changed = true;
                    }
                }
            }
        }

        Map<Relation, Set<Tuple>> map = new HashMap<>();
        for (Axiom ax : axioms) {
            map.put(ax.getRel(), ax.getRel().getMaxTupleSet());
        }

        for (Axiom ax : axioms) {
            ax.getRel().addEncodeTupleSet(map.get(ax.getRel()));
        }

        for(Set<RecursiveRelation> group : recGroups){
            Map<Relation, Integer> encodeSetSizes = new HashMap<>();
            for(Relation relation : group){
                encodeSetSizes.put(relation, 0);
            }

            boolean changed = true;
            while(changed){
                changed = false;
                for(RecursiveRelation relation : group){
                    relation.updateEncodeTupleSet();
                    int newSize = relation.getEncodeTupleSet().size();
                    if(newSize != encodeSetSizes.get(relation)){
                        encodeSetSizes.put(relation, newSize);
                        changed = true;
                    }
                }
            }
        }

        BoolExpr enc = ctx.mkTrue();
        for (Axiom ax : axioms) {
            enc = ctx.mkAnd(enc, ax.getRel().encode(ctx));
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

        for (Relation relation : relationRepository.getRelations()) {
            if(relation.getIsNamed()){
                result.append(relation);
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
