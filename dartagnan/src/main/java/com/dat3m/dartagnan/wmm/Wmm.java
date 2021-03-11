package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelCo;
import com.dat3m.dartagnan.wmm.utils.*;
import com.dat3m.dartagnan.wmm.utils.alias.AliasAnalysis;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;

import java.util.*;

/**
 *
 * @author Florian Furbach
 */
public class Wmm {

    private final static ImmutableSet<String> baseRelations = ImmutableSet.of("co", "rf", "idd", "addrDirect");

    private final List<Axiom> axioms = new ArrayList<>();
    private final Map<String, FilterAbstract> filters = new HashMap<>();
    private final RelationRepository relationRepository;
    private final List<RecursiveGroup> recursiveGroups = new ArrayList<>();

    private Program program;

    public Wmm() {
        relationRepository = new RelationRepository();
    }

    public void addAxiom(Axiom ax) {
        axioms.add(ax);
    }

    public List<Axiom> getAxioms() {
        return axioms;
    }

    public void addFilter(FilterAbstract filter) {
        filters.put(filter.getName(), filter);
    }

    public FilterAbstract getFilter(String name){
        FilterAbstract filter = filters.get(name);
        if(filter == null){
            filter = FilterBasic.get(name);
        }
        return filter;
    }

    public RelationRepository getRelationRepository(){
        return relationRepository;
    }

    public void addRecursiveGroup(Set<RecursiveRelation> recursiveGroup){
        int id = 1 << recursiveGroups.size();
        if(id < 0){
            throw new RuntimeException("Exceeded maximum number of recursive relations");
        }
        recursiveGroups.add(new RecursiveGroup(id, recursiveGroup));
    }

    // Encodes the memory models relations as if co was empty (but not the axioms yet)
    // NOTE: The call to <consistent> for encoding the axioms does not see co as empty anymore
    // This is done to get a correct computation for the active set.
    public BoolExpr encodeEmptyCo(VerificationTask task, Context ctx) {
        RelCo co = ((RelCo)getRelationRepository().getRelation("co"));
        co.setDoEncode(false);
        BoolExpr enc = encode(task, ctx);
        //co.setDoEncode(true);
        return enc;
    }

    // Encodes only the base relations of the memory model without co!
    // This should be (almost) equivalent to encoding the empty memory model
    // A call to <consistent> should not be performed afterwards.
    public BoolExpr encodeCore(VerificationTask task, Context ctx) {
        this.program = task.getProgram();
        new AliasAnalysis().calculateLocationSets(task.getProgram(), task.getSettings().getAlias());

        for(String relName : baseRelations){
            relationRepository.getRelation(relName);
        }

        for(FilterAbstract filter : filters.values()){
            filter.initialise();
        }

        for(Relation relation : relationRepository.getRelations()){
            relation.initialise(task);
        }

        /*for (Axiom ax : axioms) {
            ax.getRel().getMaxTupleSet();
        }*/

        for(String relName : baseRelations){
            relationRepository.getRelation(relName).getMaxTupleSet();
        }

        // NOT SUPPORTED FOR NOW
        /*if(settings.getDrawGraph()){
            for(String relName : settings.getGraphRelations()){
                Relation relation = relationRepository.getWrappedRelation(relName);
                if(relation != null){
                    relation.addEncodeTupleSet(relation.getMaxTupleSet());
                }
            }
        }*/

        //TODO: Can be removed if the reworked EdgeSets are used
        // Right now we need may sets/active sets to populate EdgeSetStatic

        /*for (Axiom ax : axioms) {
            ax.getRel().addEncodeTupleSet(ax.getEncodeTupleSet());
        }*/

        // Encode all base relations except co (essentially encodes rf and po)
        BoolExpr enc = ctx.mkTrue();
        for(String relName : baseRelations){
            if (relName.equals("co"))
                continue;
            relationRepository.getRelation(relName).getMaxTupleSet();
            enc = ctx.mkAnd(enc, relationRepository.getRelation(relName).encode(ctx));
        }

        return enc;
    }

    // This methods initializes all relations and encodes all base relations
    // and recursive groups (why recursive groups?)
    // It also triggers the computation of may and active sets!
    // It does NOT encode the axioms nor any non-base relation yet!
    public BoolExpr encodeBase(VerificationTask task, Context ctx) {
        this.program = task.getProgram();
        Settings settings = task.getSettings();
        new AliasAnalysis().calculateLocationSets(this.program, settings.getAlias());

        for(String relName : baseRelations){
            relationRepository.getRelation(relName);
        }

        for (Axiom ax : axioms) {
            ax.getRel().updateRecursiveGroupId(ax.getRel().getRecursiveGroupId());
        }

        for(RecursiveGroup recursiveGroup : recursiveGroups){
            recursiveGroup.setDoRecurse();
        }

        for(FilterAbstract filter : filters.values()){
            filter.initialise();
        }

        for(Relation relation : relationRepository.getRelations()){
            relation.initialise(task);
        }

        for(RecursiveGroup recursiveGroup : recursiveGroups){
            recursiveGroup.initMaxTupleSets();
        }

        for (Axiom ax : axioms) {
            ax.getRel().getMaxTupleSet();
        }

        for(String relName : baseRelations){
            relationRepository.getRelation(relName).getMaxTupleSet();
        }

        if(settings.getDrawGraph()){
            for(String relName : settings.getGraphRelations()){
                Relation relation = relationRepository.getRelation(relName);
                if(relation != null){
                    relation.addEncodeTupleSet(relation.getMaxTupleSet());
                }
            }
        }

        for (Axiom ax : axioms) {
            ax.getRel().addEncodeTupleSet(ax.getEncodeTupleSet());
        }

        Collections.reverse(recursiveGroups);
        for(RecursiveGroup recursiveGroup : recursiveGroups){
            recursiveGroup.updateEncodeTupleSets();
        }

        BoolExpr enc = ctx.mkTrue();
        for(String relName : baseRelations){
            enc = ctx.mkAnd(enc, relationRepository.getRelation(relName).encode(ctx));
        }

        if(settings.getMode() == Mode.KLEENE){
            for(RecursiveGroup group : recursiveGroups){
                enc = ctx.mkAnd(enc, group.encode(ctx));
            }
        }

        return enc;
    }

    // Initalizes everything just like encodeBase but also encodes all
    // relations that are needed for the axioms (but does NOT encode the axioms themselves yet)
    public BoolExpr encode(VerificationTask task, Context ctx) {
        BoolExpr enc = encodeBase(task, ctx);
        for (Axiom ax : axioms) {
            enc = ctx.mkAnd(enc, ax.getRel().encode(ctx));
        }
        return enc;
    }

    // Encodes all axioms. This should be called after <encode>
    public BoolExpr consistent(Program program, Context ctx) {
        if(this.program != program){
            throw new RuntimeException("Wmm relations must be encoded before consistency predicate");
        }
        BoolExpr expr = ctx.mkTrue();
        for (Axiom ax : axioms) {
            expr = ctx.mkAnd(expr, ax.consistent(ctx));
        }
        return expr;
    }

    public BoolExpr inconsistent(Program program, Context ctx) {
        if(this.program != program){
            throw new RuntimeException("Wmm relations must be encoded before inconsistency predicate");
        }
        BoolExpr expr = ctx.mkFalse();
        for (Axiom ax : axioms) {
            expr = ctx.mkOr(expr, ax.inconsistent(ctx));
        }
        return expr;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();

        for (Axiom axiom : axioms) {
            sb.append(axiom).append("\n");
        }

        for (Relation relation : relationRepository.getRelations()) {
            if(relation.getIsNamed()){
                sb.append(relation).append("\n");
            }
        }

        for (Map.Entry<String, FilterAbstract> filter : filters.entrySet()){
            sb.append(filter.getValue()).append("\n");
        }

        return sb.toString();
    }
}
