package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;
import com.dat3m.dartagnan.wmm.definition.*;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

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
        String name = "_" + count++;
        Relation relation = new Relation(name, false);
        addName(name, relation);
        return relation;
    }

    public Relation newRelation(String name) {
        Relation relation = new Relation(name, true);
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
        List<Relation> l = definition.getConstrainedRelations();
        Object[] o = l.subList(1, l.size()).stream().map(x -> x.name).toArray();
        String term = String.format(definition.term, o);
        Relation find = relationMap.get(term);
        if (find != null) {
            return find;
        }
        Relation relation = definition.getDefinedRelation();
        //TODO implement redefinition
        checkArgument(relation.definition == null);
        relation.definition = definition;
        addName(term, relation);
        return relation;
    }

    public void addFilter(FilterAbstract filter) {
        filters.put(filter.getName(), filter);
    }

    public FilterAbstract getFilter(String name) {
        return filters.computeIfAbsent(name, FilterBasic::get);
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

    @Override
    public String toString() {
        Stream<String> a = axioms.stream().map(Axiom::toString);
        Stream<String> r = relationMap.values().stream().distinct()
                .filter(x -> x.named && x.definition != null && !x.definition.getTerm().equals(x.name))
                .map(x -> x.definition.toString());
        Stream<String> s = filters.values().stream().map(FilterAbstract::toString);
        return Stream.of(a, r, s).flatMap(Stream::sorted).collect(Collectors.joining("\n"));
    }

    private void addName(String name, Relation relation) {
        Relation old = relationMap.putIfAbsent(name, relation);
        checkArgument(old == null, "already defined relation %s", name);
    }

    private Definition basicDefinition(String name) {
        Relation r = newRelation(name);
        switch (r.name) {
            case POWITHLOCALEVENTS:
                return new ProgramOrder(r, FilterBasic.get(Tag.ANY));
            case PO:
                return new ProgramOrder(r, FilterBasic.get(Tag.VISIBLE));
            case LOC:
                return new SameAddress(r);
            case ID:
                return new Identity(r, FilterBasic.get(Tag.VISIBLE));
            case INT:
                return new SameThread(r);
            case EXT:
                return new DifferentThreads(r);
            case CO:
                return new MemoryOrder(r);
            case RF:
                return new ReadFrom(r);
            case RMW:
                return new ReadModifyWrites(r);
            case CASDEP:
                return new CompareAndSwapDependency(r);
            case CRIT:
                return new CriticalSections(r);
            case IDD:
                return new DirectDataDependency(r);
            case ADDRDIRECT:
                return new DirectAddressDependency(r);
            case CTRLDIRECT:
                return new DirectControlDependency(r);
            case EMPTY:
                return new Empty(r);
            case RFINV:
                return new Inverse(r, getRelation(RF));
            case FR:
                return composition(r, getRelation(RFINV), getRelation(CO));
            case MM:
                return new CartesianProduct(r, FilterBasic.get(Tag.MEMORY), FilterBasic.get(Tag.MEMORY));
            case MV:
                return new CartesianProduct(r, FilterBasic.get(Tag.MEMORY), FilterBasic.get(Tag.VISIBLE));
            case IDDTRANS:
                return new TransitiveClosure(r, getRelation(IDD));
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
        return new Union(r0, r1, r2);
    }

    private Definition intersection(Relation r0, Relation r1, Relation r2) {
        return new Intersection(r0, r1, r2);
    }

    private Definition composition(Relation r0, Relation r1, Relation r2) {
        return new Composition(r0, r1, r2);
    }

    private Definition fence(Relation r0, String name) {
        return new Fences(r0, FilterBasic.get(name));
    }
}
