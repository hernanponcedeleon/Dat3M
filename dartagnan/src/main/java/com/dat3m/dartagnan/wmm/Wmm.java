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
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.OptionNames.ENABLE_ACTIVE_SETS;
import static com.dat3m.dartagnan.configuration.OptionNames.REDUCE_ACYCLICITY_ENCODE_SETS;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;
import static com.google.common.base.Preconditions.checkArgument;

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

    // These relations are part of every memory model (even the "empty" one) because they are
    // necessary to specify the anarchic program semantics.
    public final static ImmutableSet<String> ANARCHIC_CORE_RELATIONS = ImmutableSet.of(CO, RF, RMW);

    private final List<Constraint> constraints = new ArrayList<>(); // NOTE: Stores only non-defining constraints
    private final Set<Relation> relations = new HashSet<>();
    private final Map<String, Filter> filters = new HashMap<>();

    private final Config config = new Config();

    public Wmm() {
        ANARCHIC_CORE_RELATIONS.forEach(this::getOrCreatePredefinedRelation);
    }

    public Config getConfig() { return this.config; }

    public List<Constraint> getConstraints() {
        return Stream.concat(constraints.stream(), relations.stream().map(Relation::getDefinition)).toList();
    }

    public List<Axiom> getAxioms() {
        return constraints.stream().filter(Axiom.class::isInstance).map(Axiom.class::cast).toList();
    }

    public Set<Relation> getRelations() {
        return Set.copyOf(relations);
    }

    public boolean containsRelation(String name) {
        return relations.stream().anyMatch(r -> r.hasName(name));
    }

    public Relation getRelation(String name) {
        return relations.stream().filter(r -> r.hasName(name)).findFirst().orElse(null);
    }

    public Relation getOrCreatePredefinedRelation(String name) {
        checkArgument(RelationNameRepository.contains(name), "Undefined relation name %s.", name);
        final Relation rel = getRelation(name);
        return rel != null ? rel : makePredefinedRelation(name);

    }

    public void addAlias(String name, Relation relation) {
        checkArgument(!containsRelation(name), "Already bound name %s.", name);
        relation.names.add(name);
    }

    public Relation newRelation() {
        final Relation relation = new Relation(this);
        relations.add(relation);
        return relation;
    }

    public Relation newRelation(String name) {
        checkArgument(!containsRelation(name), "Already bound name %s.", name);
        final Relation relation = new Relation(this);
        relation.names.add(name);
        relations.add(relation);
        return relation;
    }

    public void deleteRelation(Relation relation) {
        checkArgument(relation.definition instanceof Definition.Undefined,
                "Still defined relation %s.", relation);
        checkArgument(constraints.stream().noneMatch(c -> c instanceof Axiom && ((Axiom) c).getRelation().equals(relation)),
                "Some axiom constrains relation %s.", relation);
        checkArgument(relations.stream().noneMatch(r -> r.getDependencies().contains(relation)),
                "Some definition constrains relation %s.", relation);
        logger.trace("Delete relation {}", relation);
        relations.remove(relation);
    }

    public void addConstraint(Constraint constraint) {
        if (constraint instanceof Definition def) {
            addDefinition(def);
        } else {
            final Collection<? extends Relation> constrainedRelations = constraint.getConstrainedRelations();
            checkArgument(relations.containsAll(constrainedRelations),
                    "Some untracked relation in %s", constrainedRelations);
            constraints.add(constraint);
        }
    }

    public void removeConstraint(Constraint constraint) {
        if (constraint instanceof Definition def) {
            removeDefinition(def.definedRelation);
        } else {
            constraints.remove(constraint);
        }
    }

    public Relation addDefinition(Definition definition) {
        final List<Relation> constrainedRelations = definition.getConstrainedRelations();
        checkArgument(relations.containsAll(constrainedRelations),
                "Some untracked relation in %s.", constrainedRelations);
        logger.trace("Add definition {}", definition);
        final Relation relation = definition.getDefinedRelation();
        checkArgument(relation.definition instanceof Definition.Undefined,
                "Already defined relation %s.", relation);
        relation.definition = definition;
        return relation;
    }

    public void removeDefinition(Relation definedRelation) {
        if (!(definedRelation.getDefinition() instanceof Definition.Undefined)) {
            logger.trace("Remove definition {}", definedRelation.getDefinition());
            definedRelation.definition = new Definition.Undefined(definedRelation);
        }
    }

    public void addFilter(Filter filter) {
        filters.put(filter.getName(), filter);
    }

    public Filter getFilter(String name) {
        return filters.computeIfAbsent(name, Filter::byTag);
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

    // ========================================== Utility Methods ========================================

    public void configureAll(Configuration config) throws InvalidConfigurationException {
        config.inject(this.config);
        for (Axiom ax : getAxioms()) {
            ax.configure(config);
        }

        logger.info("{}: {}", REDUCE_ACYCLICITY_ENCODE_SETS, this.config.isReduceAcyclicityEncoding());
    }

    private Relation makePredefinedRelation(String name) {
        /*
            WARNING: The code has possibly unexpected behaviour:
             - If a relation like `ext` is already defined (different from the standard definition),
               constructing e.g. `rfe` will refer to this new definition.
             - When constructing derived relations like fr, the intermediately defined relations like rf^-1
               will get constructed even if they already exist in the model.
             TODO: Clarify what the intended behaviour should be.
         */
        final Relation r = newRelation(name);
        final Definition def = switch (name) {
            case PO -> new ProgramOrder(r, Filter.byTag(Tag.VISIBLE));
            case LOC -> new SameLocation(r);
            case ID -> new SetIdentity(r, Filter.byTag(Tag.VISIBLE));
            case INT -> new Internal(r);
            case EXT -> new External(r);
            case CO -> new Coherence(r);
            case RF -> new ReadFrom(r);
            case RMW -> new ReadModifyWrites(r);
            case CASDEP -> new CASDependency(r);
            case CRIT -> new LinuxCriticalSections(r);
            case IDD -> new DirectDataDependency(r);
            case ADDRDIRECT -> new DirectAddressDependency(r);
            case CTRLDIRECT -> new DirectControlDependency(r);
            case EMPTY -> new Empty(r);
            case FR ->  {
                // rf^-1;co
                final Relation rfinv = addDefinition(new Inverse(newRelation(), getOrCreatePredefinedRelation(RF)));
                final Relation co = getOrCreatePredefinedRelation(CO);
                final Relation frStandard = addDefinition(composition(newRelation(), rfinv, co));

                // ([R] \ [range(rf)]);loc;[W]
                final Relation reads = addDefinition(new SetIdentity(newRelation(), getFilter(Tag.READ)));
                final Relation rfRange = addDefinition(new RangeIdentity(newRelation(), getOrCreatePredefinedRelation(RF)));
                final Relation loc = getOrCreatePredefinedRelation(LOC);
                final Relation writes = addDefinition(new SetIdentity(newRelation(), Filter.byTag(Tag.WRITE)));
                final Relation ur = addDefinition(new Difference(newRelation(), reads, rfRange));
                final Relation urloc = addDefinition(composition(newRelation(), ur, loc));
                final Relation urlocwrites = addDefinition(composition(newRelation(), urloc, writes));

                // let fr = rf^-1;co | ([R] \ [range(rf)]);loc;[W]
                yield union(r, frStandard, urlocwrites);
            }
            case IDDTRANS -> new TransitiveClosure(r, getOrCreatePredefinedRelation(IDD));
            case DATA -> intersection(r,
                    getOrCreatePredefinedRelation(IDDTRANS),
                    addDefinition(product(newRelation(), Tag.MEMORY, Tag.MEMORY))
            );
            case ADDR -> {
                Relation addrdirect = getOrCreatePredefinedRelation(ADDRDIRECT);
                Relation comp = addDefinition(composition(newRelation(), getOrCreatePredefinedRelation(IDDTRANS), addrdirect));
                Relation union = addDefinition(union(newRelation(), addrdirect, comp));
                Relation mm = addDefinition(product(newRelation(), Tag.MEMORY, Tag.MEMORY));
                yield intersection(r, union, mm);
            }
            case CTRL -> {
                Relation comp = addDefinition(composition(newRelation(), getOrCreatePredefinedRelation(IDDTRANS),
                        getOrCreatePredefinedRelation(CTRLDIRECT)));
                Relation mv = addDefinition(product(newRelation(), Tag.MEMORY, Tag.VISIBLE));
                yield intersection(r, comp, mv);
            }
            case POLOC -> intersection(r, getOrCreatePredefinedRelation(PO), getOrCreatePredefinedRelation(LOC));
            case RFE ->  intersection(r, getOrCreatePredefinedRelation(RF), getOrCreatePredefinedRelation(EXT));
            case RFI -> intersection(r, getOrCreatePredefinedRelation(RF), getOrCreatePredefinedRelation(INT));
            case COE -> intersection(r, getOrCreatePredefinedRelation(CO), getOrCreatePredefinedRelation(EXT));
            case COI -> intersection(r, getOrCreatePredefinedRelation(CO), getOrCreatePredefinedRelation(INT));
            case FRE -> intersection(r, getOrCreatePredefinedRelation(FR), getOrCreatePredefinedRelation(EXT));
            case FRI -> intersection(r, getOrCreatePredefinedRelation(FR), getOrCreatePredefinedRelation(INT));
            case MFENCE -> fence(r, MFENCE);
            case ISH -> fence(r, ISH);
            case ISB -> fence(r, ISB);
            case SYNC -> fence(r, SYNC);
            case ISYNC -> fence(r, ISYNC);
            case LWSYNC -> fence(r, LWSYNC);
            case CTRLISYNC -> intersection(r, getOrCreatePredefinedRelation(CTRL), getOrCreatePredefinedRelation(ISYNC));
            case CTRLISB -> intersection(r, getOrCreatePredefinedRelation(CTRL), getOrCreatePredefinedRelation(ISB));
            case SR -> new SameScope(r);
            case SCTA -> new SameScope(r, Tag.PTX.CTA);
            case SSG -> new SameScope(r, Tag.Vulkan.SUB_GROUP);
            case SWG -> new SameScope(r, Tag.Vulkan.WORK_GROUP);
            case SQF -> new SameScope(r, Tag.Vulkan.QUEUE_FAMILY);
            case SSW -> new SyncWith(r);
            case SYNCBAR -> new SyncBar(r);
            case SYNC_BARRIER -> intersection(r, getOrCreatePredefinedRelation(SYNCBAR), getOrCreatePredefinedRelation(SCTA));
            case SYNC_FENCE -> new SyncFence(r);
            case VLOC -> new SameVirtualLocation(r);
            default ->
                    throw new RuntimeException(name + "is part of RelationNameRepository but it has no associated relation.");
        };
        return addDefinition(def);
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

    private Definition product(Relation r0, String tag1, String tag2) {
        return new CartesianProduct(r0, Filter.byTag(tag1), Filter.byTag(tag2));
    }
}
