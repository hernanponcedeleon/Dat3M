package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.definition.*;
import com.google.common.collect.ImmutableSet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.*;
import java.util.function.BiFunction;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.OptionNames.ENABLE_ACTIVE_SETS;
import static com.dat3m.dartagnan.configuration.OptionNames.REDUCE_ACYCLICITY_ENCODE_SETS;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Verify.verify;

public class Wmm {

    @Options
    public static class Config {

        @Option(name = REDUCE_ACYCLICITY_ENCODE_SETS,
                description = "Omit adding transitively implied relationships to the encode set of an acyclic relation." +
                        " This option is only relevant if \"" + ENABLE_ACTIVE_SETS + "\" is set.",
                secure = true)
        private boolean reduceAcyclicityEncoding = true;

        public boolean isReduceAcyclicityEncoding() { return reduceAcyclicityEncoding; }
    }

    private static final Logger logger = LogManager.getLogger(Wmm.class);

    public final static ImmutableSet<String> BASE_RELATIONS = ImmutableSet.of(CO, RF, RMW);

    private final List<Constraint> constraints = new ArrayList<>();
    private final Map<String, Filter> filters = new HashMap<>();
    private final Set<Relation> relations = new HashSet<>();

    private final Config config = new Config();

    public Wmm() {
        BASE_RELATIONS.forEach(this::getRelation);
    }

    public Config getConfig() { return this.config; }

    /**
     * Inserts a constraint into this model.
     * @param constraint Constraint over relations in this model, to be inserted.
     */
    public void addConstraint(Constraint constraint) {
        if (constraint instanceof Definition def) {
            addDefinition(def);
        }
        Collection<? extends Relation> constrainedRelations = constraint.getConstrainedRelations();
        checkArgument(relations.containsAll(constrainedRelations),
                "Some untracked relation in %s", constrainedRelations);
        constraints.add(constraint);
    }

    public List<Constraint> getConstraints() {
        return Stream.concat(constraints.stream(), relations.stream().map(Relation::getDefinition)).toList();
    }

    /**
     * @return View of all axioms in this model in insertion order.
     */
    public List<Axiom> getAxioms() {
        return constraints.stream().filter(Axiom.class::isInstance).map(Axiom.class::cast).toList();
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
        Relation relation = new Relation(this);
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
        Relation relation = new Relation(this);
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

    public void addFilter(Filter filter) {
        filters.put(filter.getName(), filter);
    }

    public Filter getFilter(String name) {
        return filters.computeIfAbsent(name, Filter::byTag);
    }

    // ====================== Utility Methods ====================

    public void configureAll(Configuration config) throws InvalidConfigurationException {
        config.inject(this.config);
        for (Relation rel : getRelations()) {
            rel.configure(config);
        }

        for (Constraint c : constraints) {
            if (c instanceof Axiom axiom) {
                axiom.configure(config);
            }
        }

        logger.info("{}: {}", REDUCE_ACYCLICITY_ENCODE_SETS, this.config.isReduceAcyclicityEncoding());
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
        Stream<String> s = filters.values().stream().map(Filter::toString);
        return Stream.of(a, r, s).flatMap(Stream::sorted).collect(Collectors.joining("\n"));
    }

    private void simplifyAssociatives(Class<? extends Definition> cls, BiFunction<Relation, Relation[], Definition> constructor) {
        for (Relation r : List.copyOf(relations)) {
            if (!r.names.isEmpty() || !cls.isInstance(r.definition) ||
                    constraints.stream().anyMatch(c -> ((Axiom) c).getRelation().equals(r))) {
                continue;
            }
            List<Relation> parents = relations.stream().filter(x -> x.getDependencies().contains(r)).toList();
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
        return switch (name) {
            case PO -> new ProgramOrder(r, Filter.byTag(Tag.VISIBLE));
            case LOC -> new SameAddress(r);
            case ID -> new Identity(r, Filter.byTag(Tag.VISIBLE));
            case INT -> new SameThread(r);
            case EXT -> new DifferentThreads(r);
            case CO -> new Coherence(r);
            case RF -> new ReadFrom(r);
            case RMW -> new ReadModifyWrites(r);
            case CASDEP -> new CompareAndSwapDependency(r);
            case CRIT -> new CriticalSections(r);
            case IDD -> new DirectDataDependency(r);
            case ADDRDIRECT -> new DirectAddressDependency(r);
            case CTRLDIRECT -> new DirectControlDependency(r);
            case EMPTY -> new Empty(r);
            case RFINV -> {
                //FIXME: We don't need a name for "rf^-1", this is a normal relation!
                // This causes models that explicitly mention "rf^-1" to have two versions of the same relation!
                yield new Inverse(r, getRelation(RF));
            }
            case FR -> composition(r, getRelation(RFINV), getRelation(CO));
            case MM -> new CartesianProduct(r, Filter.byTag(Tag.MEMORY), Filter.byTag(Tag.MEMORY));
            case MV -> new CartesianProduct(r, Filter.byTag(Tag.MEMORY), Filter.byTag(Tag.VISIBLE));
            case IDDTRANS -> new TransitiveClosure(r, getRelation(IDD));
            case DATA -> intersection(r, getRelation(IDDTRANS), getRelation(MM));
            case ADDR -> {
                Relation addrdirect = getRelation(ADDRDIRECT);
                Relation comp = addDefinition(composition(newRelation(), getRelation(IDDTRANS), addrdirect));
                Relation union = addDefinition(union(newRelation(), addrdirect, comp));
                yield intersection(r, union, getRelation(MM));
            }
            case CTRL -> {
                Relation comp = addDefinition(composition(newRelation(), getRelation(IDDTRANS), getRelation(CTRLDIRECT)));
                yield intersection(r, comp, getRelation(MV));
            }
            case POLOC -> intersection(r, getRelation(PO), getRelation(LOC));
            case RFE ->  intersection(r, getRelation(RF), getRelation(EXT));
            case RFI -> intersection(r, getRelation(RF), getRelation(INT));
            case COE -> intersection(r, getRelation(CO), getRelation(EXT));
            case COI -> intersection(r, getRelation(CO), getRelation(INT));
            case FRE -> intersection(r, getRelation(FR), getRelation(EXT));
            case FRI -> intersection(r, getRelation(FR), getRelation(INT));
            case MFENCE -> fence(r, MFENCE);
            case ISH -> fence(r, ISH);
            case ISB -> fence(r, ISB);
            case SYNC -> fence(r, SYNC);
            case ISYNC -> fence(r, ISYNC);
            case LWSYNC -> fence(r, LWSYNC);
            case CTRLISYNC -> intersection(r, getRelation(CTRL), getRelation(ISYNC));
            case CTRLISB -> intersection(r, getRelation(CTRL), getRelation(ISB));
            case SR -> new SameScope(r);
            case SCTA -> new SameScope(r, Tag.PTX.CTA);
            case SSG -> new SameScope(r, Tag.Vulkan.SUB_GROUP);
            case SWG -> new SameScope(r, Tag.Vulkan.WORK_GROUP);
            case SQF -> new SameScope(r, Tag.Vulkan.QUEUE_FAMILY);
            case SSW -> new SyncWith(r);
            case SYNCBAR -> new SyncBar(r);
            case SYNC_BARRIER -> intersection(r, getRelation(SYNCBAR), getRelation(SCTA));
            case SYNC_FENCE -> new SyncFence(r);
            case VLOC -> new VirtualLocation(r);
            default ->
                    throw new RuntimeException(name + "is part of RelationNameRepository but it has no associated relation.");
        };
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
        return new Fences(r0, Filter.byTag(name));
    }
}
