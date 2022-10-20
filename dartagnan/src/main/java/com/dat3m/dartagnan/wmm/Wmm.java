package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;
import com.dat3m.dartagnan.wmm.definition.*;
import com.google.common.collect.ImmutableSet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;
import java.util.function.BiFunction;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;
import static com.google.common.base.Preconditions.checkArgument;

public class Wmm {

    private static final Logger logger = LogManager.getLogger(Wmm.class);

    public final static ImmutableSet<String> BASE_RELATIONS = ImmutableSet.of(CO, RF, RMW);

    private int count;
    private final List<Axiom> axioms = new ArrayList<>();
    private final Map<String, FilterAbstract> filters = new HashMap<>();
    private final Set<Relation> relations = new HashSet<>();

    public Wmm() {
        BASE_RELATIONS.forEach(this::getRelation);
    }

    public void addAxiom(Axiom ax) {
        checkArgument(relations.contains(ax.getRelation()));
        axioms.add(ax);
    }

    public List<Axiom> getAxioms() {
        return axioms;
    }

    public Set<Relation> getRelations() {
        return Set.copyOf(relations);
    }

    /**
     * Queries a relation by name in this model.
     * @param name Uniquely identifies a relation in this model.
     * @return The relation in this model named {@code name}, or {@code null} if no such exists.
     */
    public Relation getRelation(String name) {
        for (Relation r : relations) {
            if (r.hasName(name)) {
                return r;
            }
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
        checkArgument(relations.stream().noneMatch(r -> r.hasName(name)),
                "name %s is already used, aliasing not possible", name);
        relation.aliases.add(name);
    }

    public Relation newRelation() {
        String name = "#" + count++;
        Relation relation = new Relation(name, false);
        relations.add(relation);
        return relation;
    }

    public Relation newRelation(String name) {
        checkArgument(!name.startsWith("#"),
                "invalid relation name %s", name);
        checkArgument(relations.stream().noneMatch(r -> r.hasName(name)),
                "name %s is already used, creation not possible", name);
        Relation relation = new Relation(name, true);
        relations.add(relation);
        return relation;
    }

    public void deleteRelation(Relation relation) {
        checkArgument(relation.definition == null,
                "relation %s is still defined", relation);
        checkArgument(axioms.stream().noneMatch(a -> a.getRelation().equals(relation)),
                "relation %s is constrained by some axiom", relation);
        checkArgument(relations.stream().noneMatch(r -> r.getDependencies().contains(relation)),
                "relation %s is constrained by some definition", relation);
        logger.debug("delete relation {}", relation.name);
        relations.remove(relation);
    }

    /**
     * Inserts a definition to this model.
     * <p>
     * <b>NOTE</b>: This also adds the defined relation to this model, if not done already.
     * @param definition Constraints a subset of relations.
     * @return Relation inside this model, which is defined accordingly.  Usually the defined relation.
     */
    public Relation addDefinition(Definition definition) {
        checkArgument(relations.containsAll(definition.getConstrainedRelations()));
        logger.debug("add definition {}", definition);
        Relation relation = definition.getDefinedRelation();
        checkArgument(relation.definition == null);
        relation.definition = definition;
        return relation;
    }

    public void removeDefinition(Relation definedRelation) {
        checkArgument(definedRelation.definition != null,
                "relation %s already undefined", definedRelation.name);
        logger.debug("remove definition {}", definedRelation.definition);
        definedRelation.definition = null;
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

    public void simplify() {
        simplifyAssociatives(Union.class, Union::new);
        simplifyAssociatives(Intersection.class, Intersection::new);
    }

    @Override
    public String toString() {
        Stream<String> a = axioms.stream().map(Axiom::toString);
        Stream<String> r = relations.stream()
                .filter(x -> x.named && x.definition != null && !x.definition.getTerm().equals(x.name))
                .map(x -> x.definition.toString());
        Stream<String> s = filters.values().stream().map(FilterAbstract::toString);
        return Stream.of(a, r, s).flatMap(Stream::sorted).collect(Collectors.joining("\n"));
    }

    private void simplifyAssociatives(Class<? extends Definition> cls, BiFunction<Relation, Relation[], Definition> constructor) {
        for (Relation r : List.copyOf(relations)) {
            if (r.named || !cls.isInstance(r.definition) ||
                    axioms.stream().anyMatch(a -> a.getRelation().equals(r))) {
                continue;
            }
            List<Relation> parents = relations.stream()
                    .filter(x -> x.getDependencies().contains(r))
                    .collect(Collectors.toList());
            Relation p = parents.size() == 1 ? parents.get(0) : null;
            if (p != null && cls.isInstance(p.definition)) {
                Relation[] o = Stream.of(r, p)
                        .flatMap(x -> x.getDependencies().stream())
                        .filter(x -> !r.equals(x))
                        .distinct()
                        .toArray(Relation[]::new);
                removeDefinition(p);
                Relation alternative = addDefinition(constructor.apply(p, o));
                if (alternative != p) {
                    logger.warn("relation {} becomes duplicate of {}", p, alternative);
                }
                removeDefinition(r);
                deleteRelation(r);
            }
        }
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
