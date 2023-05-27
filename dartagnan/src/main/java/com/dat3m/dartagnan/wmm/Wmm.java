package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.definition.SameScope;
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
import static com.google.common.base.Verify.verify;

public class Wmm {

    private static final Logger logger = LogManager.getLogger(Wmm.class);

    public final static ImmutableSet<String> BASE_RELATIONS = ImmutableSet.of(CO, RF, RMW);

    private final List<Constraint> constraints = new ArrayList<>();
    private final Map<String, FilterAbstract> filters = new HashMap<>();
    private final Set<Relation> relations = new HashSet<>();

    public Wmm() {
        BASE_RELATIONS.forEach(this::getRelation);
    }

    /**
     * Inserts a constraint into this model.
     * @param constraint Constraint over relations in this model, to be inserted.
     */
    public void addConstraint(Constraint constraint) {
        if (constraint instanceof Definition) {
            addDefinition((Definition) constraint);
        }
        Collection<? extends Relation> constrainedRelations = constraint.getConstrainedRelations();
        checkArgument(relations.containsAll(constrainedRelations),
                "Some untracked relation in %s", constrainedRelations);
        constraints.add(constraint);
    }

    public List<Constraint> getConstraints() {
        return Stream.concat(constraints.stream(), relations.stream().map(Relation::getDefinition))
                .collect(Collectors.toList());
    }

    /**
     * @return View of all axioms in this model in insertion order.
     */
    public List<Axiom> getAxioms() {
        return constraints.stream()
                .filter(Axiom.class::isInstance).map(Axiom.class::cast)
                .collect(Collectors.toList());
    }

    /**
     * @return View of all relation objects in this model, excluding unused built-ins.
     * Contains at least {@code rf}, {@code co} and {@code rmw}.
     */
    public Set<Relation> getRelations() {
        return Set.copyOf(relations);
    }

    /**
     * Tests the namespace of relations.
     * @return {@code name} is a valid argument for {@link #getRelation(String)}.
     */
    public boolean containsRelation(String name) {
        return relations.stream().anyMatch(r -> r.hasName(name)) || RelationNameRepository.contains(name);
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
        checkArgument(RelationNameRepository.contains(name),
                "Undefined relation name %s.", name);
        Definition definition = basicDefinition(name);
        verify(definition.definedRelation.definition instanceof Definition.Undefined,
                "Already initialized built-in relation %s.", name);
        definition.definedRelation.definition = definition;
        return definition.definedRelation;
    }

    /**
     * Binds a name to a relation.
     * @param name Currently-unbound identifier, preferably devoid of special symbols.
     * @param relation Element to be named.
     */
    public void addAlias(String name, Relation relation) {
        checkArgument(relations.stream().noneMatch(r -> r.hasName(name)),
                "Already bound name %s.", name);
        relation.names.add(name);
    }

    /**
     * Instantiates a new unnamed and undefined element in this model.
     * @return The created relation.
     */
    public Relation newRelation() {
        Relation relation = new Relation();
        relations.add(relation);
        return relation;
    }

    /**
     * Instantiates a new undefined element in this model.
     * @param name Currently-unbound name for the new relation.
     * @return The created named relation.
     */
    public Relation newRelation(String name) {
        checkArgument(relations.stream().noneMatch(r -> r.hasName(name)),
                "Already bound name %s.", name);
        Relation relation = new Relation();
        relation.names.add(name);
        relations.add(relation);
        return relation;
    }

    /**
     * Removes a relation from this model, including all names bound to it.
     * @param relation Relation that participates in no constraint of this model.
     *                 Should no longer be used.
     */
    public void deleteRelation(Relation relation) {
        checkArgument(relation.definition instanceof Definition.Undefined,
                "Still defined relation %s.", relation);
        checkArgument(constraints.stream().noneMatch(c -> c instanceof Axiom && ((Axiom) c).getRelation().equals(relation)),
                "Some axiom constrains relation %s.", relation);
        checkArgument(relations.stream().noneMatch(r -> r.getDependencies().contains(relation)),
                "Some definition constrains relation %s.", relation);
        logger.trace("delete relation {}", relation);
        relations.remove(relation);
    }

    /**
     * Inserts a definition to this model.
     * <p>
     * <b>NOTE</b>: This also adds the defined relation to this model, if not done already.
     * @param definition Constraints a subset of relations that are tracked in this model.
     * @return Relation inside this model, which is defined accordingly.  Usually the defined relation.
     */
    public Relation addDefinition(Definition definition) {
        List<Relation> constrainedRelations = definition.getConstrainedRelations();
        checkArgument(relations.containsAll(constrainedRelations),
                "Some untracked relation in %s.", constrainedRelations);
        logger.trace("Add definition {}", definition);
        Relation relation = definition.getDefinedRelation();
        checkArgument(relation.definition instanceof Definition.Undefined,
                "Already defined relation %s.", relation);
        relation.definition = definition;
        return relation;
    }

    /**
     * Removes a single constraint from this model.
     * @param definedRelation Identifies the definition to be removed.
     */
    public void removeDefinition(Relation definedRelation) {
        checkArgument(!(definedRelation.definition instanceof Definition.Undefined),
                "Already undefined relation %s.", definedRelation);
        logger.trace("Remove definition {}", definedRelation.definition);
        definedRelation.definition = new Definition.Undefined(definedRelation);
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

        for (Constraint c : constraints) {
            if (c instanceof Axiom) {
                ((Axiom) c).configure(config);
            }
        }
    }

    public void simplify() {
        simplifyAssociatives(Union.class, Union::new);
        simplifyAssociatives(Intersection.class, Intersection::new);
    }

    @Override
    public String toString() {
        Stream<String> a = constraints.stream().map(Constraint::toString);
        Stream<String> r = relations.stream()
                .filter(x -> !x.names.isEmpty() && !(x.definition instanceof Definition.Undefined) && !x.hasName(x.definition.getTerm()))
                .map(x -> x.definition.toString());
        Stream<String> s = filters.values().stream().map(FilterAbstract::toString);
        return Stream.of(a, r, s).flatMap(Stream::sorted).collect(Collectors.joining("\n"));
    }

    private void simplifyAssociatives(Class<? extends Definition> cls, BiFunction<Relation, Relation[], Definition> constructor) {
        for (Relation r : List.copyOf(relations)) {
            if (!r.names.isEmpty() || !cls.isInstance(r.definition) ||
                    constraints.stream().anyMatch(c -> ((Axiom) c).getRelation().equals(r))) {
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
        switch (name) {
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
                return new Coherence(r);
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
            case SR:
                return new SameScope(r);
            case SCTA:
                return new SameScope(r, Tag.PTX.CTA);
            case SYNCBAR:
                return new SyncBar(r);
            case SYNC_BARRIER:
                return intersection(r, getRelation(SYNCBAR), getRelation(SCTA));
            case ALIAS:
                return new Alias(r);
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
