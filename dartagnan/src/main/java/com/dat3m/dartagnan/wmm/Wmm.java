package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;
import com.dat3m.dartagnan.wmm.relation.base.RelCrit;
import com.dat3m.dartagnan.wmm.relation.base.RelRMW;
import com.dat3m.dartagnan.wmm.relation.base.local.RelAddrDirect;
import com.dat3m.dartagnan.wmm.relation.base.local.RelCASDep;
import com.dat3m.dartagnan.wmm.relation.base.local.RelIdd;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelCo;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelLoc;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelRf;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelCartesian;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelCtrlDirect;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelEmpty;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelExt;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelFencerel;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelInt;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelPo;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelSetIdentity;
import com.dat3m.dartagnan.wmm.relation.binary.RelComposition;
import com.dat3m.dartagnan.wmm.relation.binary.RelIntersection;
import com.dat3m.dartagnan.wmm.relation.binary.RelUnion;
import com.dat3m.dartagnan.wmm.relation.unary.RelInverse;
import com.dat3m.dartagnan.wmm.relation.unary.RelTrans;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;
import static com.google.common.base.Preconditions.checkArgument;

public class Wmm {

    public final static ImmutableSet<String> BASE_RELATIONS = ImmutableSet.of(CO, RF, RMW);

    private int count;
    private final List<Axiom> axioms = new ArrayList<>();
    private final Map<String, FilterAbstract> filters = new HashMap<>();
    private final Map<String, Relation> relationMap = new HashMap<>();

    public Wmm() {
        BASE_RELATIONS.forEach(this::getRelation);
    }

    public void addAxiom(Axiom ax) {
        checkArgument(relationMap.containsValue(ax.getRelation()));
        axioms.add(ax);
    }

    public List<Axiom> getAxioms() {
        return axioms;
    }

    public Set<Relation> getRelations() {
        return Set.copyOf(relationMap.values());
    }

    /**
     * Queries a relation by name in this model.
     * @param name Uniquely identifies a relation in this model.
     * @return The relation in this model named {@code name}, or {@code null} if no such exists.
     */
    public Relation getRelation(String name) {
        Relation relation = relationMap.get(name);
        if (relation != null) {
            return relation;
        }
        if (!RelationNameRepository.contains(name)) {
            return null;
        }
        Definition definition = basicDefinition(name);
        assert definition.definedRelation.definition == null;
        definition.definedRelation.definition = definition;
        return definition.definedRelation;
    }

    public void addAlias(String name, Relation relation) {
        addName(name, relation);
    }

    public Relation newRelation() {
        return newRelation("_" + count++);
    }

    public Relation newRelation(String name) {
        Relation relation = new Relation(name);
        addName(name, relation);
        return relation;
    }

    /**
     * Inserts a definition to this model.
     * <p>
     * <b>NOTE</b>: This also adds the defined relation to this model, if not done already.
     * @param definition Constraints a subset of relations.
     * @return Relation inside this model, which is defined accordingly.  Usually the defined relation.
     */
    public Relation addDefinition(Definition definition) {
        checkArgument(definition.getConstrainedRelations().stream().allMatch(relationMap::containsValue));
        Relation find = relationMap.get(definition.term);
        if (find != null) {
            return find;
        }
        Relation relation = definition.getDefinedRelation();
        //TODO implement redefinition
        checkArgument(relation.definition == null);
        relation.definition = definition;
        addName(definition.term, relation);
        return relation;
    }

    public void addFilter(FilterAbstract filter) {
        filters.put(filter.getName(), filter);
    }

    public FilterAbstract getFilter(String name) {
        return filters.computeIfAbsent(name, FilterBasic::get);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();

        for (Axiom axiom : axioms) {
            sb.append(axiom).append("\n");
        }

        for (Relation relation : getRelations()) {
            sb.append(relation).append("\n");
        }

        for (Map.Entry<String, FilterAbstract> filter : filters.entrySet()) {
            sb.append(filter.getValue()).append("\n");
        }

        return sb.toString();
    }


    // ====================== Utility Methods ====================

    public void configureAll(Configuration config) throws InvalidConfigurationException {
        for (Relation rel : getRelations()) {
            rel.configure(config);
        }

        for (Axiom ax : axioms) {
            ax.configure(config);
        }
    }

    private void addName(String name, Relation relation) {
        Relation old = relationMap.putIfAbsent(name, relation);
        checkArgument(old == null, "already defined relation %s", name);
    }

    private Definition basicDefinition(String name) {
        Relation r = newRelation(name);
        switch (r.name) {
            case POWITHLOCALEVENTS:
                return new RelPo(r, FilterBasic.get(Tag.ANY));
            case PO:
                return new RelPo(r, FilterBasic.get(Tag.VISIBLE));
            case LOC:
                return new RelLoc(r);
            case ID:
                return new RelSetIdentity(r, FilterBasic.get(Tag.VISIBLE));
            case INT:
                return new RelInt(r);
            case EXT:
                return new RelExt(r);
            case CO:
                return new RelCo(r);
            case RF:
                return new RelRf(r);
            case RMW:
                return new RelRMW(r);
            case CASDEP:
                return new RelCASDep(r);
            case CRIT:
                return new RelCrit(r);
            case IDD:
                return new RelIdd(r);
            case ADDRDIRECT:
                return new RelAddrDirect(r);
            case CTRLDIRECT:
                return new RelCtrlDirect(r);
            case EMPTY:
                return new RelEmpty(r);
            case RFINV:
                return new RelInverse(r, getRelation(RF));
            case FR:
                return composition(r, getRelation(RFINV), getRelation(CO));
            case MM:
                return new RelCartesian(r, FilterBasic.get(Tag.MEMORY), FilterBasic.get(Tag.MEMORY));
            case MV:
                return new RelCartesian(r, FilterBasic.get(Tag.MEMORY), FilterBasic.get(Tag.VISIBLE));
            case IDDTRANS:
                return new RelTrans(r, getRelation(IDD));
            case DATA:
                return intersection(r, getRelation(IDDTRANS), getRelation(MM));
            case ADDR: {
                Relation addrdirect = getRelation(ADDRDIRECT);
                Relation comp = addDefinition(composition(newRelation(), getRelation(IDDTRANS), addrdirect));
                Relation union = addDefinition(union(newRelation(), addrdirect, comp));
                return intersection(r, union, getRelation(MM));
            }
            case CTRL: {
                Relation comp = addDefinition(composition(newRelation(), getRelation(IDDTRANS), getRelation(CTRLDIRECT)));
                return intersection(r, comp, getRelation(MV));
            }
            case POLOC:
                return intersection(r, getRelation(PO), getRelation(LOC));
            case RFE:
                return intersection(r, getRelation(RF), getRelation(EXT));
            case RFI:
                return intersection(r, getRelation(RF), getRelation(INT));
            case COE:
                return intersection(r, getRelation(CO), getRelation(EXT));
            case COI:
                return intersection(r, getRelation(CO), getRelation(INT));
            case FRE:
                return intersection(r, getRelation(FR), getRelation(EXT));
            case FRI:
                return intersection(r, getRelation(FR), getRelation(INT));
            case MFENCE:
                return fence(r, MFENCE);
            case ISH:
                return fence(r, ISH);
            case ISB:
                return fence(r, ISB);
            case SYNC:
                return fence(r, SYNC);
            case ISYNC:
                return fence(r, ISYNC);
            case LWSYNC:
                return fence(r, LWSYNC);
            case CTRLISYNC:
                return intersection(r, getRelation(CTRL), getRelation(ISYNC));
            case CTRLISB:
                return intersection(r, getRelation(CTRL), getRelation(ISB));
            default:
                throw new RuntimeException(name + "is part of RelationNameRepository but it has no associated relation.");
        }
    }

    private Definition union(Relation r0, Relation r1, Relation r2) {
        return new RelUnion(r0, r1, r2);
    }

    private Definition intersection(Relation r0, Relation r1, Relation r2) {
        return new RelIntersection(r0, r1, r2);
    }

    private Definition composition(Relation r0, Relation r1, Relation r2) {
        return new RelComposition(r0, r1, r2);
    }

    private Definition fence(Relation r0, String name) {
        return new RelFencerel(r0, FilterBasic.get(name));
    }
}
