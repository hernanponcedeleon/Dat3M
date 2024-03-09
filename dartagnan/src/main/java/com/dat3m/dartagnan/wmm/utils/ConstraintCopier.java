package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.wmm.Assumption;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.axiom.*;
import com.dat3m.dartagnan.wmm.definition.*;
import com.google.common.base.Preconditions;

import java.util.Collection;
import java.util.Map;

public final class ConstraintCopier implements Constraint.Visitor<Constraint> {

    private final Map<Relation, Relation> relationMap;

    public ConstraintCopier(Map<Relation, Relation> relMap) {
        this.relationMap = relMap;
    }

    private Relation translate(Relation relation) {
        Preconditions.checkArgument(relationMap.get(relation) != null,
                "Source relation `%s` has no associated mapping.", relation);
        return relationMap.get(relation);
    }

    private Relation[] translate(Collection<? extends Relation> relations) {
        final Relation[] translation = new Relation[relations.size()];
        int i = 0;
        for (Relation rel : relations) {
            translation[i++] = translate(rel);
        }
        return translation;
    }

    private <T extends Axiom> T copyName(T original, T copy) {
        copy.setName(original.getName());
        return copy;
    }

    @Override
    public Emptiness visitEmptiness(Emptiness axiom) {
        return copyName(axiom, new Emptiness(translate(axiom.getRelation()), axiom.isNegated(), axiom.isFlagged()));
    }

    @Override
    public Irreflexivity visitIrreflexivity(Irreflexivity axiom) {
        return copyName(axiom, new Irreflexivity(translate(axiom.getRelation()), axiom.isNegated(), axiom.isFlagged()));
    }

    @Override
    public Acyclicity visitAcyclicity(Acyclicity axiom) {
        return copyName(axiom, new Acyclicity(translate(axiom.getRelation()), axiom.isNegated(), axiom.isFlagged()));
    }

    @Override
    public Assumption visitAssumption(Assumption assume) {
        return new Assumption(translate(assume.getRelation()), assume.getMaySet(), assume.getMustSet());
    }

    @Override
    public ForceEncodeAxiom visitForceEncodeAxiom(ForceEncodeAxiom forceEncode) {
        return new ForceEncodeAxiom(translate(forceEncode.getRelation()), forceEncode.isNegated(), forceEncode.isFlagged());
    }

    @Override
    public Constraint visitFree(Free def) {
        return new Free(translate(def.getDefinedRelation()));
    }

    @Override
    public Union visitUnion(Union def) {
        return new Union(translate(def.getDefinedRelation()), translate(def.getOperands()));
    }

    @Override
    public Intersection visitIntersection(Intersection def) {
        return new Intersection(translate(def.getDefinedRelation()), translate(def.getOperands()));
    }

    @Override
    public Difference visitDifference(Difference def) {
        return new Difference(translate(def.getDefinedRelation()),
                translate(def.getMinuend()), translate(def.getSubtrahend()));
    }

    @Override
    public Composition visitComposition(Composition def) {
        return new Composition(translate(def.getDefinedRelation()),
                translate(def.getLeftOperand()), translate(def.getRightOperand()));
    }

    @Override
    public DomainIdentity visitDomainIdentity(DomainIdentity def) {
        return new DomainIdentity(translate(def.getDefinedRelation()), translate(def.getOperand()));
    }

    @Override
    public RangeIdentity visitRangeIdentity(RangeIdentity def) {
        return new RangeIdentity(translate(def.getDefinedRelation()), translate(def.getOperand()));
    }

    @Override
    public Inverse visitInverse(Inverse def) {
        return new Inverse(translate(def.getDefinedRelation()), translate(def.getOperand()));
    }

    @Override
    public TransitiveClosure visitTransitiveClosure(TransitiveClosure def) {
        return new TransitiveClosure(translate(def.getDefinedRelation()), translate(def.getOperand()));
    }

    @Override
    public SetIdentity visitSetIdentity(SetIdentity def) {
        return new SetIdentity(translate(def.getDefinedRelation()), def.getFilter());
    }

    @Override
    public CartesianProduct visitProduct(CartesianProduct def) {
        return new CartesianProduct(translate(def.getDefinedRelation()), def.getFirstFilter(), def.getSecondFilter());
    }

    @Override
    public Fences visitFences(Fences fence) {
        return new Fences(translate(fence.getDefinedRelation()), fence.getFilter());
    }

    @Override
    public Definition.Undefined visitUndefined(Definition.Undefined def) {
        return new Definition.Undefined(translate(def.getDefinedRelation()));
    }

    @Override
    public Empty visitEmpty(Empty def) {
        return new Empty(translate(def.getDefinedRelation()));
    }

    @Override
    public ProgramOrder visitProgramOrder(ProgramOrder po) {
        return new ProgramOrder(translate(po.getDefinedRelation()), po.getFilter());
    }

    @Override
    public External visitExternal(External ext) {
        return new External(translate(ext.getDefinedRelation()));
    }

    @Override
    public Internal visitInternal(Internal def) {
        return new Internal(translate(def.getDefinedRelation()));
    }

    @Override
    public DirectDataDependency visitInternalDataDependency(DirectDataDependency idd) {
        return new DirectDataDependency(translate(idd.getDefinedRelation()));
    }

    @Override
    public DirectControlDependency visitControlDependency(DirectControlDependency ctrlDirect) {
        return new DirectControlDependency(translate(ctrlDirect.getDefinedRelation()));
    }

    @Override
    public DirectAddressDependency visitAddressDependency(DirectAddressDependency addrDirect) {
        return new DirectAddressDependency(translate(addrDirect.getDefinedRelation()));
    }

    @Override
    public ReadModifyWrites visitReadModifyWrites(ReadModifyWrites rmw) {
        return new ReadModifyWrites(translate(rmw.getDefinedRelation()));
    }

    @Override
    public Coherence visitCoherence(Coherence co) {
        return new Coherence(translate(co.getDefinedRelation()));
    }

    @Override
    public SameLocation visitSameLocation(SameLocation loc) {
        return new SameLocation(translate(loc.getDefinedRelation()));
    }

    @Override
    public ReadFrom visitReadFrom(ReadFrom rf) {
        return new ReadFrom(translate(rf.getDefinedRelation()));
    }

    @Override
    public CASDependency visitCASDependency(CASDependency casDep) {
        return new CASDependency(translate(casDep.getDefinedRelation()));
    }

    @Override
    public LinuxCriticalSections visitLinuxCriticalSections(LinuxCriticalSections rscs) {
        return new LinuxCriticalSections(translate(rscs.getDefinedRelation()));
    }

    @Override
    public SameVirtualLocation visitSameVirtualLocation(SameVirtualLocation vloc) {
        return new SameVirtualLocation(translate(vloc.getDefinedRelation()));
    }

    @Override
    public SameScope visitSameScope(SameScope sc) {
        return new SameScope(translate(sc.getDefinedRelation()), sc.getSpecificScope());
    }

    @Override
    public SyncBar visitSyncBarrier(SyncBar syncBar) {
        return new SyncBar(translate(syncBar.getDefinedRelation()));
    }

    @Override
    public SyncFence visitSyncFence(SyncFence syncFence) {
        return new SyncFence(translate(syncFence.getDefinedRelation()));
    }

    @Override
    public SyncWith visitSyncWith(SyncWith syncWith) {
        return new SyncWith(translate(syncWith.getDefinedRelation()));
    }
}
