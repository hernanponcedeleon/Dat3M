package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;
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
import com.dat3m.dartagnan.wmm.relation.binary.BinaryRelation;
import com.dat3m.dartagnan.wmm.relation.binary.RelComposition;
import com.dat3m.dartagnan.wmm.relation.binary.RelIntersection;
import com.dat3m.dartagnan.wmm.relation.binary.RelUnion;
import com.dat3m.dartagnan.wmm.relation.unary.RelInverse;
import com.dat3m.dartagnan.wmm.relation.unary.RelTrans;
import com.dat3m.dartagnan.wmm.relation.unary.UnaryRelation;
import com.dat3m.dartagnan.wmm.utils.RecursiveGroup;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.*;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkState;

public class Wmm {

    public final static ImmutableSet<String> BASE_RELATIONS = ImmutableSet.of(CO, RF, RMW);


    private final List<Axiom> axioms = new ArrayList<>();
    private final Map<String, FilterAbstract> filters = new HashMap<>();
    private final Map<String, Relation> relationMap = new HashMap<>();
    private final List<RecursiveGroup> recursiveGroups = new ArrayList<>();

    public Wmm() {
        BASE_RELATIONS.forEach(this::getRelation);
    }

    public void addAxiom(Axiom ax) {
        axioms.add(ax);
    }

    public List<Axiom> getAxioms() {
        return axioms;
    }

    public Set<Relation> getRelations() {
        Set<Relation> set = new HashSet<>();
        for (Map.Entry<String, Relation> entry : relationMap.entrySet()) {
            if (!entry.getValue().getIsNamed() || entry.getValue().getName().equals(entry.getKey())) {
                set.add(entry.getValue());
            }
        }
        return set;
    }

    /**
     * Queries a relation by name in this model.
     * @param name Uniquely identifies a relation in this model.
     * @return The relation in this model named {@code name}, or {@code null} if no such exists.
     */
    public Relation getRelation(String name) {
        Relation relation = relationMap.get(name);
        if (relation == null) {
            if (RelationNameRepository.contains(name)) {
                relation = getBasicRelation(name).setName(name);
                addRelation(relation);
            }
        }
        return relation;
    }

    public Relation getRelation(Class<?> cls, Object... args) {
        Class<?>[] argClasses = getArgsForClass(cls);
        try {
            Method method = cls.getMethod("makeTerm", argClasses);
            String term = (String) method.invoke(null, args);
            Relation relation;
            if (relationMap.containsKey(term)) {
                relation = relationMap.get(term);
            } else {
                Constructor<?> constructor = cls.getConstructor(argClasses);
                relation = (Relation) constructor.newInstance(args);
                addRelation(relation);
            }
            return relation;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void addRelation(Relation relation) {
        relationMap.put(relation.getTerm(), relation);
        if (relation.getIsNamed()) {
            relationMap.put(relation.getName(), relation);
        }
    }

    public void addAlias(String alias, Relation relation) {
        relationMap.put(alias, relation);
    }

    public void updateRelation(Relation relation) {
        if (relation.getIsNamed()) {
            String name = relation.getName();
            checkState(!relationMap.containsKey(name), "Relation {} is already declared", name);
            relationMap.put(name, relation);
        }
    }

    public List<RecursiveGroup> getRecursiveGroups() {
        return recursiveGroups;
    }

    public void addFilter(FilterAbstract filter) {
        filters.put(filter.getName(), filter);
    }

    public FilterAbstract getFilter(String name) {
        return filters.computeIfAbsent(name, FilterBasic::get);
    }

    public void addRecursiveGroup(Set<RecursiveRelation> recursiveGroup) {
        recursiveGroups.add(new RecursiveGroup(recursiveGroup));
    }


    public String toString() {
        StringBuilder sb = new StringBuilder();

        for (Axiom axiom : axioms) {
            sb.append(axiom).append("\n");
        }

        for (Relation relation : getRelations()) {
            if (relation.getIsNamed()) {
                sb.append(relation).append("\n");
            }
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

    private Class<?>[] getArgsForClass(Class<?> cls){
        if(BinaryRelation.class.isAssignableFrom(cls)){
            return new Class<?>[]{Relation.class, Relation.class};
        } else if(UnaryRelation.class.isAssignableFrom(cls)){
            return new Class<?>[]{Relation.class};
        } else if(RelCartesian.class.isAssignableFrom(cls)){
            return new Class<?>[]{FilterAbstract.class, FilterAbstract.class};
        } else if(RelFencerel.class.isAssignableFrom(cls) || RelSetIdentity.class.isAssignableFrom(cls)){
            return new Class<?>[]{FilterAbstract.class};
        } else if(RecursiveRelation.class.isAssignableFrom(cls)) {
            return new Class<?>[]{String.class};
        }

        throw new UnsupportedOperationException("Method getArgsForClass is not implemented for " + cls.getName());
    }

    private Relation getBasicRelation(String name) {
        checkArgument(contains(name), "{} is not listed in RelationNameRepository.", name);
        switch (name) {
            case POWITHLOCALEVENTS:
                return new RelPo(true);
            case PO:
                return new RelPo();
            case LOC:
                return new RelLoc();
            case ID:
                return new RelSetIdentity(FilterBasic.get(Tag.VISIBLE));
            case INT:
                return new RelInt();
            case EXT:
                return new RelExt();
            case CO:
                return new RelCo();
            case RF:
                return new RelRf();
            case RMW:
                return new RelRMW();
            case CASDEP:
                return new RelCASDep();
            case CRIT:
                return new RelCrit();
            case IDD:
                return new RelIdd();
            case ADDRDIRECT:
                return new RelAddrDirect();
            case CTRLDIRECT:
                return new RelCtrlDirect();
            case EMPTY:
                return new RelEmpty();
            case RFINV:
                return getRelation(RelInverse.class, getRelation(RF));
            case FR:
                return composition(getRelation(RFINV), getRelation(CO));
            case MM:
                return getRelation(RelCartesian.class, FilterBasic.get(Tag.MEMORY), FilterBasic.get(Tag.MEMORY));
            case MV:
                return getRelation(RelCartesian.class, FilterBasic.get(Tag.MEMORY), FilterBasic.get(Tag.VISIBLE));
            case IDDTRANS:
                return getRelation(RelTrans.class, getRelation(IDD));
            case DATA:
                return intersection(getRelation(IDDTRANS), getRelation(MM));
            case ADDR: {
                Relation addrdirect = getRelation(ADDRDIRECT);
                return intersection(union(addrdirect, composition(getRelation(IDDTRANS), addrdirect)), getRelation(MM));
            }
            case CTRL:
                return intersection(composition(getRelation(IDDTRANS), getRelation(CTRLDIRECT)), getRelation(MV));
            case POLOC:
                return intersection(getRelation(PO), getRelation(LOC));
            case RFE:
                return intersection(getRelation(RF), getRelation(EXT));
            case RFI:
                return intersection(getRelation(RF), getRelation(INT));
            case COE:
                return intersection(getRelation(CO), getRelation(EXT));
            case COI:
                return intersection(getRelation(CO), getRelation(INT));
            case FRE:
                return intersection(getRelation(FR), getRelation(EXT));
            case FRI:
                return intersection(getRelation(FR), getRelation(INT));
            case MFENCE:
                return fence(MFENCE);
            case ISH:
                return fence(ISH);
            case ISB:
                return fence(ISB);
            case SYNC:
                return fence(SYNC);
            case ISYNC:
                return fence(ISYNC);
            case LWSYNC:
                return fence(LWSYNC);
            case CTRLISYNC:
                return intersection(getRelation(CTRL), getRelation(ISYNC));
            case CTRLISB:
                return intersection(getRelation(CTRL), getRelation(ISB));
            default:
                throw new RuntimeException(name + "is part of RelationNameRepository but it has no associated relation.");
        }
    }

    private Relation union(Relation r1, Relation r2) {
        return getRelation(RelUnion.class, r1, r2);
    }

    private Relation intersection(Relation r1, Relation r2) {
        return getRelation(RelIntersection.class, r1, r2);
    }

    private Relation composition(Relation r1, Relation r2) {
        return getRelation(RelComposition.class, r1, r2);
    }

    private Relation fence(String name) {
        return getRelation(RelFencerel.class, FilterBasic.get(name));
    }
}
