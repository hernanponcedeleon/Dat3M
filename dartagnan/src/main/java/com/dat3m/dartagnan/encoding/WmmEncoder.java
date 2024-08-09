package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.ControlBarrier;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.RMWStoreExclusive;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.EventGraph;
import com.dat3m.dartagnan.wmm.utils.Flag;
import com.google.common.collect.Iterables;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;

import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.ENABLE_ACTIVE_SETS;
import static com.dat3m.dartagnan.configuration.OptionNames.MEMORY_IS_ZEROED;
import static com.dat3m.dartagnan.program.event.Tag.*;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;
import static com.dat3m.dartagnan.wmm.utils.EventGraph.difference;
import static com.google.common.base.Verify.verify;
import static java.lang.Boolean.TRUE;

@Options
public class WmmEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(WmmEncoder.class);
    final Map<Relation, EventGraph> encodeSets = new HashMap<>();
    private final EncodingContext context;

    // =====================================================================
    @Option(name = ENABLE_ACTIVE_SETS,
            description = "Filters relationships relevant to the task before encoding.",
            secure = true)
    private boolean enableActiveSets = true;

    @Option(name = MEMORY_IS_ZEROED,
            description = "Assumes the whole memory is zeroed before the program runs." +
                    "In particular, if set to TRUE, reads from uninitialized memory will return zero." +
                    "Otherwise, uninitialized memory has a nondeterministic value.",
            secure = true)
    private boolean memoryIsZeroed = true;

    // =====================================================================

    private WmmEncoder(EncodingContext c) {
        context = c;
        c.getAnalysisContext().requires(RelationAnalysis.class);
    }

    public static WmmEncoder withContext(EncodingContext context) throws InvalidConfigurationException {
        WmmEncoder encoder = new WmmEncoder(context);
        context.getTask().getConfig().inject(encoder);
        logger.info("{}: {}", ENABLE_ACTIVE_SETS, encoder.enableActiveSets);
        logger.info("{}: {}", MEMORY_IS_ZEROED, encoder.memoryIsZeroed);
        long t0 = System.currentTimeMillis();
        if (encoder.enableActiveSets) {
            encoder.initializeEncodeSets();
        } else {
            encoder.initializeAlternative();
        }
        logger.info("Finished active sets in {}", Utils.toTimeString(System.currentTimeMillis() - t0));
        RelationAnalysis ra = context.getAnalysisContext().get(RelationAnalysis.class);
        logger.info("Number of unknown edges: {}", context.getTask().getMemoryModel().getRelations().stream()
                .filter(r -> !r.isInternal())
                .map(ra::getKnowledge)
                .mapToLong(k -> difference(k.getMaySet(), k.getMustSet()).size())
                .sum());
        logger.info("Number of encoded edges: {}", encoder.encodeSets.entrySet().stream()
                .filter(e -> !e.getKey().isInternal())
                .mapToLong(e -> e.getValue().size())
                .sum());
        return encoder;
    }

    public BooleanFormula encodeFullMemoryModel() {
        return context.getBooleanFormulaManager().and(
                encodeRelations(),
                encodeConsistency()
        );
    }

    // Initializes everything just like encodeAnarchicSemantics but also encodes all
    // relations that are needed for the axioms (but does NOT encode the axioms themselves yet)
    // NOTE: It avoids encoding relations that do NOT affect the axioms, i.e. unused relations
    public BooleanFormula encodeRelations() {
        logger.info("Encoding relations");
        Wmm memoryModel = context.getTask().getMemoryModel();
        final DependencyGraph<Relation> depGraph = DependencyGraph.from(
                Iterables.concat(
                        Iterables.transform(Wmm.ANARCHIC_CORE_RELATIONS, memoryModel::getRelation), // base relations
                        Iterables.transform(memoryModel.getAxioms(), Axiom::getRelation) // axiom relations
                )
        );
        RelationEncoder v = new RelationEncoder();
        for (Relation rel : depGraph.getNodeContents()) {
            logger.trace("Encoding relation '{}'", rel);
            rel.getDefinition().accept(v);
        }
        return v.bmgr.and(v.enc);
    }

    // Encodes all axioms. This should be called after <encodeRelations>
    public BooleanFormula encodeConsistency() {
        logger.info("Encoding consistency");
        Wmm memoryModel = context.getTask().getMemoryModel();
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        RelationAnalysis ra = context.getAnalysisContext().get(RelationAnalysis.class);
        List<BooleanFormula> enc = new ArrayList<>();
        for (Axiom a : memoryModel.getAxioms()) {
            if (!a.isFlagged()) {
                logger.trace("Encoding axiom '{}'", a);
                enc.addAll(a.consistent(context));
            }
        }
        ra.getContradictions()
                .apply((e1, e2) -> enc.add(bmgr.not(context.execution(e1, e2))));
        return bmgr.and(enc);
    }

    public EventGraph getEventGraph(Relation relation, Model model) {
        EncodingContext.EdgeEncoder edge = context.edge(relation);
        EventGraph encodeSet = encodeSets.getOrDefault(relation, EventGraph.empty())
                .filter((e1, e2) -> TRUE.equals(model.evaluate(edge.encode(e1, e2))));
        EventGraph mustEncodeSet = context.getAnalysisContext().get(RelationAnalysis.class).getKnowledge(relation).getMustSet()
                .filter((e1, e2) -> TRUE.equals(model.evaluate(context.execution(e1, e2))));
        encodeSet.addAll(mustEncodeSet);
        return encodeSet;
    }

    private final class RelationEncoder implements Constraint.Visitor<Void> {
        final Program program = context.getTask().getProgram();
        final RelationAnalysis ra = context.getAnalysisContext().requires(RelationAnalysis.class);
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final List<BooleanFormula> enc = new ArrayList<>();

        @Override
        public Void visitDefinition(Definition def) {
            final Relation rel = def.getDefinedRelation();
            EncodingContext.EdgeEncoder edge = context.edge(rel);
            encodeSets.get(rel).apply((e1, e2) -> enc.add(bmgr.equivalence(edge.encode(e1, e2), execution(e1, e2))));
            return null;
        }

        @Override
        public Void visitFree(Free def) {
            final Relation rel = def.getDefinedRelation();
            EncodingContext.EdgeEncoder edge = context.edge(rel);
            encodeSets.get(rel).apply((e1, e2) -> enc.add(bmgr.implication(edge.encode(e1, e2), execution(e1, e2))));
            return null;
        }

        @Override
        public Void visitUnion(Union union) {
            final Relation rel = union.getDefinedRelation();
            final List<Relation> operands = union.getOperands();
            EventGraph must = ra.getKnowledge(rel).getMustSet();
            EncodingContext.EdgeEncoder e0 = context.edge(rel);
            EncodingContext.EdgeEncoder[] encoders = operands.stream().map(context::edge).toArray(EncodingContext.EdgeEncoder[]::new);
            encodeSets.get(rel).apply((e1, e2) -> {
                BooleanFormula edge = e0.encode(e1, e2);
                if (must.contains(e1, e2)) {
                    enc.add(bmgr.equivalence(edge, execution(e1, e2)));
                } else {
                    List<BooleanFormula> opt = new ArrayList<>(operands.size());
                    for (EncodingContext.EdgeEncoder e : encoders) {
                        opt.add(e.encode(e1, e2));
                    }
                    enc.add(bmgr.equivalence(edge, bmgr.or(opt)));
                }
            });
            return null;
        }

        @Override
        public Void visitIntersection(Intersection inter) {
            final Relation rel = inter.getDefinedRelation();
            final List<Relation> operands = inter.getOperands();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            RelationAnalysis.Knowledge[] knowledges = operands.stream().map(ra::getKnowledge).toArray(RelationAnalysis.Knowledge[]::new);
            EncodingContext.EdgeEncoder e0 = context.edge(rel);
            EncodingContext.EdgeEncoder[] encoders = operands.stream().map(context::edge).toArray(EncodingContext.EdgeEncoder[]::new);
            encodeSets.get(rel).apply((e1, e2) -> {
                BooleanFormula edge = e0.encode(e1, e2);
                if (k.getMustSet().contains(e1, e2)) {
                    enc.add(bmgr.equivalence(edge, execution(e1, e2)));
                } else {
                    List<BooleanFormula> opt = new ArrayList<>(operands.size());
                    for (int i = 0; i < operands.size(); i++) {
                        if (!knowledges[i].getMustSet().contains(e1, e2)) {
                            opt.add(encoders[i].encode(e1, e2));
                        }
                    }
                    enc.add(bmgr.equivalence(edge, bmgr.and(opt)));
                }
            });
            return null;
        }

        @Override
        public Void visitDifference(Difference diff) {
            final Relation rel = diff.getDefinedRelation();
            final Relation r1 = diff.getMinuend();
            final Relation r2 = diff.getSubtrahend();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            EncodingContext.EdgeEncoder enc0 = context.edge(rel);
            EncodingContext.EdgeEncoder enc1 = context.edge(r1);
            EncodingContext.EdgeEncoder enc2 = context.edge(r2);
            encodeSets.get(rel).apply((e1, e2) -> {
                BooleanFormula edge = enc0.encode(e1, e2);
                if (k.getMustSet().contains(e1, e2)) {
                    enc.add(bmgr.equivalence(edge, execution(e1, e2)));
                } else {
                    BooleanFormula opt1 = enc1.encode(e1, e2);
                    BooleanFormula opt2 = bmgr.not(enc2.encode(e1, e2));
                    enc.add(bmgr.equivalence(edge, bmgr.and(opt1, opt2)));
                }
            });
            return null;
        }

        @Override
        public Void visitComposition(Composition comp) {
            final Relation rel = comp.getDefinedRelation();
            final Relation r1 = comp.getLeftOperand();
            final Relation r2 = comp.getRightOperand();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            final RelationAnalysis.Knowledge k1 = ra.getKnowledge(r1);
            final RelationAnalysis.Knowledge k2 = ra.getKnowledge(r2);
            EncodingContext.EdgeEncoder enc0 = context.edge(rel);
            EncodingContext.EdgeEncoder enc1 = context.edge(r1);
            EncodingContext.EdgeEncoder enc2 = context.edge(r2);
            final EventGraph a1 = EventGraph.union(encodeSets.get(r1), k1.getMustSet());
            final EventGraph a2 = EventGraph.union(encodeSets.get(r2), k2.getMustSet());
            Map<Event, Set<Event>> out = k1.getMaySet().getOutMap();
            encodeSets.get(rel).apply((e1, e2) -> {
                BooleanFormula expr = bmgr.makeFalse();
                if (k.getMustSet().contains(e1, e2)) {
                    expr = execution(e1, e2);
                } else {
                    for (Event e : out.getOrDefault(e1, Set.of())) {
                        if (k2.getMaySet().contains(e, e2)) {
                            verify(a1.contains(e1, e) && a2.contains(e, e2),
                                    "Failed to properly propagate active sets across composition at triple: (%s, %s, %s).", e1, e, e2);
                            expr = bmgr.or(expr, bmgr.and(enc1.encode(e1, e), enc2.encode(e, e2)));
                        }
                    }
                }
                enc.add(bmgr.equivalence(enc0.encode(e1, e2), expr));
            });
            return null;
        }

        @Override
        public Void visitDomainIdentity(DomainIdentity domId) {
            final Relation rel = domId.getDefinedRelation();
            final Relation r1 = domId.getOperand();
            Map<Event, Set<Event>> mayOut = ra.getKnowledge(r1).getMaySet().getOutMap();
            EncodingContext.EdgeEncoder enc0 = context.edge(rel);
            EncodingContext.EdgeEncoder enc1 = context.edge(r1);
            encodeSets.get(rel).apply((e1, e2) -> {
                BooleanFormula opt = bmgr.makeFalse();
                //TODO: Optimize using minSets (but no CAT uses this anyway)
                for (Event e2Alt : mayOut.getOrDefault(e1, Set.of())) {
                    opt = bmgr.or(opt, enc1.encode(e1, e2Alt));
                }
                enc.add(bmgr.equivalence(enc0.encode(e1, e2), opt));
            });
            return null;
        }

        @Override
        public Void visitRangeIdentity(RangeIdentity rangeId) {
            final Relation rel = rangeId.getDefinedRelation();
            final Relation r1 = rangeId.getOperand();
            Map<Event, Set<Event>> mayIn = ra.getKnowledge(r1).getMaySet().getInMap();
            EncodingContext.EdgeEncoder enc0 = context.edge(rel);
            EncodingContext.EdgeEncoder enc1 = context.edge(r1);
            //TODO: Optimize using minSets (but no CAT uses this anyway)
            encodeSets.get(rel).apply((e1, e2) -> {
                BooleanFormula opt = bmgr.makeFalse();
                for (Event e1Alt : mayIn.getOrDefault(e1, Set.of())) {
                    opt = bmgr.or(opt, enc1.encode(e1Alt, e2));
                }
                enc.add(bmgr.equivalence(enc0.encode(e1, e2), opt));
            });
            return null;
        }

        @Override
        public Void visitTransitiveClosure(TransitiveClosure trans) {
            final Relation rel = trans.getDefinedRelation();
            final Relation r1 = trans.getOperand();
            final EventGraph relMustSet = ra.getKnowledge(rel).getMustSet();
            final EventGraph relMaySet = ra.getKnowledge(rel).getMaySet();
            final EventGraph r1MaySet = ra.getKnowledge(r1).getMaySet();
            EncodingContext.EdgeEncoder enc0 = context.edge(rel);
            EncodingContext.EdgeEncoder enc1 = context.edge(r1);
            encodeSets.get(rel).apply((e1, e2) -> {
                BooleanFormula edge = enc0.encode(e1, e2);
                if (relMustSet.contains(e1, e2)) {
                    enc.add(bmgr.equivalence(edge, execution(e1, e2)));
                } else {
                    BooleanFormula orClause = bmgr.makeFalse();
                    if (r1MaySet.contains(e1, e2)) {
                        orClause = bmgr.or(orClause, enc1.encode(e1, e2));
                    }
                    for (Event e : r1MaySet.getRange(e1)) {
                        if (e.getGlobalId() != e1.getGlobalId() && e.getGlobalId() != e2.getGlobalId() && relMaySet.contains(e, e2)) {
                            BooleanFormula tVar = relMustSet.contains(e1, e) ? enc0.encode(e1, e) : enc1.encode(e1, e);
                            orClause = bmgr.or(orClause, bmgr.and(tVar, enc0.encode(e, e2)));

                        }
                    }
                    enc.add(bmgr.equivalence(edge, orClause));
                }
            });
            return null;
        }

        @Override
        public Void visitInverse(Inverse inv) {
            final Relation rel = inv.getDefinedRelation();
            final Relation r1 = inv.getOperand();
            EventGraph mustSet = ra.getKnowledge(rel).getMustSet();
            EncodingContext.EdgeEncoder enc0 = context.edge(rel);
            EncodingContext.EdgeEncoder enc1 = context.edge(r1);
            encodeSets.get(rel).apply((e1, e2) ->
                    enc.add(bmgr.equivalence(
                            enc0.encode(e1, e2),
                            mustSet.contains(e1, e2) ?
                                    execution(e1, e2) :
                                    enc1.encode(e2, e1))));
            return null;
        }

        @Override
        public Void visitFences(Fences fence) {
            final Relation rel = fence.getDefinedRelation();
            final Filter fenceSet = fence.getFilter();
            EventGraph mustSet = ra.getKnowledge(rel).getMustSet();
            List<Event> fences = program.getThreadEvents().stream().filter(fenceSet::apply).toList();
            EncodingContext.EdgeEncoder encoder = context.edge(rel);
            encodeSets.get(rel).apply((e1, e2) -> {
                BooleanFormula orClause;
                if (mustSet.contains(e1, e2)) {
                    orClause = bmgr.makeTrue();
                } else {
                    orClause = fences.stream()
                            .filter(f -> e1.getGlobalId() < f.getGlobalId() && f.getGlobalId() < e2.getGlobalId())
                            .map(context::execution).reduce(bmgr.makeFalse(), bmgr::or);
                }
                enc.add(bmgr.equivalence(
                        encoder.encode(e1, e2),
                        bmgr.and(execution(e1, e2), orClause)));
            });
            return null;
        }

        @Override
        public Void visitInternalDataDependency(DirectDataDependency idd) {
            return visitDirectDependency(idd.getDefinedRelation());
        }

        @Override
        public Void visitAddressDependency(DirectAddressDependency addrDirect) {
            return visitDirectDependency(addrDirect.getDefinedRelation());
        }

        private Void visitDirectDependency(Relation r) {
            Dependency dep = context.getAnalysisContext().get(Dependency.class);
            EncodingContext.EdgeEncoder edge = context.edge(r);
            encodeSets.get(r).apply((writer, reader) -> {
                if (!(writer instanceof RegWriter rw)) {
                    enc.add(bmgr.not(edge.encode(writer, reader)));
                } else {
                    Dependency.State s = dep.of(reader, rw.getResultRegister());
                    if (s.must.contains(writer)) {
                        enc.add(bmgr.equivalence(edge.encode(writer, reader), context.execution(writer, reader)));
                    } else if (!s.may.contains(writer)) {
                        enc.add(bmgr.not(edge.encode(writer, reader)));
                    }
                }
            });
            return null;
        }

        @Override
        public Void visitLinuxCriticalSections(LinuxCriticalSections rscsDef) {
            final Relation rscs = rscsDef.getDefinedRelation();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rscs);
            final Map<Event, Set<Event>> mayIn = k.getMaySet().getInMap();
            final Map<Event, Set<Event>> mayOut = k.getMaySet().getOutMap();
            EncodingContext.EdgeEncoder encoder = context.edge(rscs);
            encodeSets.get(rscs).apply((lock, unlock) -> {
                BooleanFormula relation = execution(lock, unlock);
                for (Event y : mayIn.getOrDefault(unlock, Set.of())) {
                    if (lock.getGlobalId() < y.getGlobalId() && y.getGlobalId() < unlock.getGlobalId()) {
                        relation = bmgr.and(relation, bmgr.not(encoder.encode(y, unlock)));
                    }
                }
                for (Event y : mayOut.getOrDefault(lock, Set.of())) {
                    if (lock.getGlobalId() < y.getGlobalId() && y.getGlobalId() < unlock.getGlobalId()) {
                        relation = bmgr.and(relation, bmgr.not(encoder.encode(lock, y)));
                    }
                }
                enc.add(bmgr.equivalence(encoder.encode(lock, unlock), relation));
            });
            return null;
        }

        @Override
        public Void visitReadModifyWrites(ReadModifyWrites rmwDef) {
            final Relation rmw = rmwDef.getDefinedRelation();
            BooleanFormula unpredictable = bmgr.makeFalse();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rmw);
            final Map<Event, Set<Event>> mayIn = k.getMaySet().getInMap();
            final Map<Event, Set<Event>> mayOut = k.getMaySet().getOutMap();

            // ----------  Encode matching for LL/SC-type RMWs ----------
            for (RMWStoreExclusive store : program.getThreadEvents(RMWStoreExclusive.class)) {
                BooleanFormula storeExec = bmgr.makeFalse();
                for (Event e : mayIn.getOrDefault(store, Set.of())) {
                    MemoryCoreEvent load = (MemoryCoreEvent) e;
                    BooleanFormula sameAddress = context.sameAddress(load, store);
                    // Encode if load and store form an exclusive pair
                    BooleanFormula isPair = exclPair(load, store);
                    List<BooleanFormula> pairingCond = new ArrayList<>();
                    pairingCond.add(context.execution(load));
                    pairingCond.add(context.controlFlow(store));
                    for (Event otherLoad : mayIn.getOrDefault(store, Set.of())) {
                        if (otherLoad.getGlobalId() > load.getGlobalId()) {
                            pairingCond.add(bmgr.not(context.execution(otherLoad)));
                        }
                    }
                    for (Event otherStore : mayOut.getOrDefault(load, Set.of())) {
                        if (otherStore.getGlobalId() < store.getGlobalId()) {
                            pairingCond.add(bmgr.not(context.controlFlow(otherStore)));
                        }
                    }
                    // For ARMv8, the store can be executed if addresses mismatch, but behaviour is "constrained unpredictable"
                    // The implementation does not include all possible unpredictable cases: in case of address
                    // mismatch, addresses of read and write are unknown, i.e. read and write can use any address.
                    // For RISCV and Power, addresses should match.
                    if (store.doesRequireMatchingAddresses()) {
                        pairingCond.add(sameAddress);
                    } else {
                        unpredictable = bmgr.or(unpredictable, bmgr.and(context.execution(store), isPair, bmgr.not(sameAddress)));
                    }
                    enc.add(bmgr.equivalence(isPair, bmgr.and(pairingCond)));
                    storeExec = bmgr.or(storeExec, isPair);
                }
                enc.add(bmgr.implication(context.execution(store), storeExec));
            }

            // ---------- Encode actual RMW relation ----------
            EncodingContext.EdgeEncoder edge = context.edge(rmw);
            encodeSets.get(rmw).apply((e1, e2) -> {
                MemoryCoreEvent load = (MemoryCoreEvent) e1;
                MemoryCoreEvent store = (MemoryCoreEvent) e2;
                if (!load.hasTag(Tag.EXCL) || !(store instanceof RMWStoreExclusive exclStore)) {
                    // Non-LL/SC type RMWs always hold
                    enc.add(bmgr.equivalence(edge.encode(load, store), context.execution(load, store)));
                } else {
                    // Note that if the pair RMWStore requires matching addresses, then we do NOT(!)
                    // add an address check, because the pairing condition already includes the address check.
                    BooleanFormula sameAddress = exclStore.doesRequireMatchingAddresses() ?
                            bmgr.makeTrue() : context.sameAddress(load, store);
                    enc.add(bmgr.equivalence(
                            edge.encode(load, store),
                            k.getMustSet().contains(load, store) ? execution(load, store) :
                                    // Relation between exclusive load and store
                                    bmgr.and(context.execution(store), exclPair(load, store), sameAddress)));
                }
            });
            enc.add(bmgr.equivalence(Flag.ARM_UNPREDICTABLE_BEHAVIOUR.repr(context.getFormulaManager()), unpredictable));
            return null;
        }

        private BooleanFormula exclPair(Event load, Event store) {
            return bmgr.makeVariable("excl(" + load.getGlobalId() + "," + store.getGlobalId() + ")");
        }

        @Override
        public Void visitSameLocation(SameLocation locDef) {
            final Relation loc = locDef.getDefinedRelation();
            EncodingContext.EdgeEncoder edge = context.edge(loc);
            encodeSets.get(loc).apply((e1, e2) ->
                    enc.add(bmgr.equivalence(edge.encode(e1, e2), bmgr.and(
                            execution(e1, e2),
                            context.sameAddress((MemoryCoreEvent) e1, (MemoryCoreEvent) e2)))));
            return null;
        }

        @Override
        public Void visitReadFrom(ReadFrom rfDef) {
            final Relation rf = rfDef.getDefinedRelation();
            Map<MemoryEvent, List<BooleanFormula>> edgeMap = new HashMap<>();
            final EncodingContext.EdgeEncoder edge = context.edge(rf);
            ra.getKnowledge(rf).getMaySet().apply((e1, e2) -> {
                MemoryCoreEvent w = (MemoryCoreEvent) e1;
                MemoryCoreEvent r = (MemoryCoreEvent) e2;
                BooleanFormula e = edge.encode(w, r);
                BooleanFormula sameAddress = context.sameAddress(w, r);
                BooleanFormula sameValue = context.equal(context.value(w), context.value(r));
                edgeMap.computeIfAbsent(r, key -> new ArrayList<>()).add(e);
                enc.add(bmgr.implication(e, bmgr.and(execution(w, r), sameAddress, sameValue)));
            });
            for (Load r : program.getThreadEvents(Load.class)) {
                final BooleanFormula uninit = getUninitReadVar(r);
                if (memoryIsZeroed) {
                    enc.add(bmgr.implication(uninit, context.equalZero(context.value(r))));
                }

                final List<BooleanFormula> rfEdges = edgeMap.getOrDefault(r, List.of());
                if (GlobalSettings.ALLOW_MULTIREADS) {
                    enc.add(bmgr.implication(context.execution(r), bmgr.or(bmgr.or(rfEdges), uninit)));
                    continue;
                }

                String rPrefix = "s(" + RF + ",E" + r.getGlobalId() + ",";
                BooleanFormula lastSeqVar = uninit;
                for (int i = 0; i < rfEdges.size(); i++) {
                    BooleanFormula newSeqVar = bmgr.makeVariable(rPrefix + i + ")");
                    enc.add(bmgr.equivalence(newSeqVar, bmgr.or(lastSeqVar, rfEdges.get(i))));
                    enc.add(bmgr.not(bmgr.and(rfEdges.get(i), lastSeqVar)));
                    lastSeqVar = newSeqVar;
                }
                enc.add(bmgr.implication(context.execution(r), lastSeqVar));
            }
            return null;
        }

        private BooleanFormula getUninitReadVar(Load load) {
            return bmgr.makeVariable("uninit_read " + load.getGlobalId());
        }

        @Override
        public Void visitCoherence(Coherence coDef) {
            final Relation co = coDef.getDefinedRelation();
            boolean idl = !context.useSATEncoding;
            List<MemoryCoreEvent> allWrites = program.getThreadEvents(MemoryCoreEvent.class).stream()
                    .filter(e -> e.hasTag(WRITE))
                    .sorted(Comparator.comparingInt(Event::getGlobalId))
                    .toList();
            EncodingContext.EdgeEncoder edge = context.edge(co);
            EventGraph maySet = ra.getKnowledge(co).getMaySet();
            EventGraph mustSet = ra.getKnowledge(co).getMustSet();
            EventGraph transCo = idl ? ra.findTransitivelyImpliedCo(co) : null;
            IntegerFormulaManager imgr = idl ? context.getFormulaManager().getIntegerFormulaManager() : null;
            if (idl) {
                // ---- Encode clock conditions (init = 0, non-init > 0) ----
                NumeralFormula.IntegerFormula zero = imgr.makeNumber(0);
                for (MemoryCoreEvent w : allWrites) {
                    NumeralFormula.IntegerFormula clock = context.memoryOrderClock(w);
                    enc.add(w.hasTag(INIT) ? imgr.equal(clock, zero) : imgr.greaterThan(clock, zero));
                }
            }
            // ---- Encode coherences ----
            for (int i = 0; i < allWrites.size() - 1; i++) {
                MemoryCoreEvent x = allWrites.get(i);
                for (MemoryCoreEvent z : allWrites.subList(i + 1, allWrites.size())) {
                    boolean forwardPossible = maySet.contains(x, z);
                    boolean backwardPossible = maySet.contains(z, x);
                    if (!forwardPossible && !backwardPossible) {
                        continue;
                    }
                    BooleanFormula execPair = execution(x, z);
                    BooleanFormula sameAddress = context.sameAddress(x, z);
                    BooleanFormula pairingCond = bmgr.and(execPair, sameAddress);
                    BooleanFormula coF = forwardPossible ? edge.encode(x, z) : bmgr.makeFalse();
                    BooleanFormula coB = backwardPossible ? edge.encode(z, x) : bmgr.makeFalse();
                    // Coherence is not total for some architectures
                    if (Arch.coIsTotal(program.getArch())) {
                        enc.add(bmgr.equivalence(pairingCond, bmgr.or(coF, coB)));
                    } else {
                        enc.add(bmgr.implication(bmgr.or(coF, coB), pairingCond));
                    }
                    if (idl) {
                        enc.add(bmgr.implication(coF, x.hasTag(INIT) || transCo.contains(x, z) ? bmgr.makeTrue()
                                : imgr.lessThan(context.memoryOrderClock(x), context.memoryOrderClock(z))));
                        enc.add(bmgr.implication(coB, z.hasTag(INIT) || transCo.contains(z, x) ? bmgr.makeTrue()
                                : imgr.lessThan(context.memoryOrderClock(z), context.memoryOrderClock(x))));
                    } else {
                        enc.add(bmgr.or(bmgr.not(coF), bmgr.not(coB)));
                        if (!mustSet.contains(x, z) && !mustSet.contains(z, x)) {
                            for (MemoryEvent y : allWrites) {
                                if (forwardPossible && maySet.contains(x, y) && maySet.contains(y, z)) {
                                    enc.add(bmgr.implication(bmgr.and(edge.encode(x, y), edge.encode(y, z)), coF));
                                }
                                if (backwardPossible && maySet.contains(y, x) && maySet.contains(z, y)) {
                                    enc.add(bmgr.implication(bmgr.and(edge.encode(y, x), edge.encode(z, y)), coB));
                                }
                            }
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitSyncBarrier(SyncBar syncBar) {
            final Relation rel = syncBar.getDefinedRelation();
            EncodingContext.EdgeEncoder encoder = context.edge(rel);
            EventGraph mustSet = ra.getKnowledge(rel).getMustSet();
            encodeSets.get(rel).apply((e1, e2) -> {
                ControlBarrier b1 = (ControlBarrier) e1;
                ControlBarrier b2 = (ControlBarrier) e2;
                BooleanFormula sameId;
                // If they are in must, they are guaranteed to have the same id
                if (mustSet.contains(b1, b2)) {
                    sameId = bmgr.makeTrue();
                } else {
                    Expression id1 = b1.getId();
                    Expression id2 = b2.getId();
                    sameId = context.equal(context.encodeExpressionAt(id1, b1),
                            context.encodeExpressionAt(id2, b2));
                }
                enc.add(bmgr.equivalence(
                        encoder.encode(b1, b2),
                        bmgr.and(execution(b1, b2), sameId)));
            });
            return null;
        }

        @Override
        public Void visitSyncFence(SyncFence syncFenceDef) {
            final Relation syncFence = syncFenceDef.getDefinedRelation();
            final boolean idl = !context.useSATEncoding;
            final String relName = syncFence.getName().orElseThrow(); // syncFence is base, it always has a name
            List<Event> allFenceSC = program.getThreadEventsWithAllTags(VISIBLE, FENCE, PTX.SC);
            allFenceSC.removeIf(e -> !e.getThread().hasScope());
            EncodingContext.EdgeEncoder edge = context.edge(syncFence);
            EventGraph maySet = ra.getKnowledge(syncFence).getMaySet();
            EventGraph mustSet = ra.getKnowledge(syncFence).getMustSet();
            IntegerFormulaManager imgr = idl ? context.getFormulaManager().getIntegerFormulaManager() : null;
            // ---- Encode syncFence ----
            for (int i = 0; i < allFenceSC.size() - 1; i++) {
                Event x = allFenceSC.get(i);
                for (Event z : allFenceSC.subList(i + 1, allFenceSC.size())) {
                    String scope1 = Tag.getScopeTag(x, program.getArch());
                    String scope2 = Tag.getScopeTag(z, program.getArch());
                    if (scope1.isEmpty() || scope2.isEmpty()) {
                        continue;
                    }
                    if (!x.getThread().getScopeHierarchy().canSyncAtScope((z.getThread().getScopeHierarchy()), scope1) ||
                            !z.getThread().getScopeHierarchy().canSyncAtScope((x.getThread().getScopeHierarchy()), scope2)) {
                        continue;
                    }
                    boolean forwardPossible = maySet.contains(x, z);
                    boolean backwardPossible = maySet.contains(z, x);
                    if (!forwardPossible && !backwardPossible) {
                        continue;
                    }
                    BooleanFormula pairingCond = execution(x, z);
                    BooleanFormula scF = forwardPossible ? edge.encode(x, z) : bmgr.makeFalse();
                    BooleanFormula scB = backwardPossible ? edge.encode(z, x) : bmgr.makeFalse();
                    enc.add(bmgr.equivalence(pairingCond, bmgr.or(scF, scB)));
                    if (idl) {
                        enc.add(bmgr.implication(scF, imgr.lessThan(context.clockVariable(relName, x), context.clockVariable(relName, z))));
                        enc.add(bmgr.implication(scB, imgr.lessThan(context.clockVariable(relName, z), context.clockVariable(relName, x))));
                    } else {
                        enc.add(bmgr.or(bmgr.not(scF), bmgr.not(scB)));
                        if (!mustSet.contains(x, z) && !mustSet.contains(z, x)) {
                            for (Event y : allFenceSC) {
                                if (forwardPossible && maySet.contains(x, y) && maySet.contains(y, z)) {
                                    enc.add(bmgr.implication(bmgr.and(edge.encode(x, y), edge.encode(y, z)), scF));
                                }
                                if (backwardPossible && maySet.contains(y, x) && maySet.contains(z, y)) {
                                    enc.add(bmgr.implication(bmgr.and(edge.encode(y, x), edge.encode(z, y)), scB));
                                }
                            }
                        }
                    }
                }
            }
            return null;
        }

        private BooleanFormula execution(Event e1, Event e2) {
            return context.execution(e1, e2);
        }
    }

    private void initializeAlternative() {
        RelationAnalysis ra = context.getAnalysisContext().get(RelationAnalysis.class);
        for (Relation r : context.getTask().getMemoryModel().getRelations()) {
            encodeSets.put(r, ra.getKnowledge(r).getMaySet());
        }
    }

    private void initializeEncodeSets() {
        logger.trace("Start");
        for (Relation r : context.getTask().getMemoryModel().getRelations()) {
            encodeSets.put(r, new EventGraph());
        }
        EncodeSets v = new EncodeSets(context.getAnalysisContext());
        Map<Relation, List<EventGraph>> queue = new HashMap<>();
        for (Axiom a : context.getTask().getMemoryModel().getAxioms()) {
            for (Map.Entry<Relation, EventGraph> e : a.getEncodeGraph(context.getTask(), context.getAnalysisContext()).entrySet()) {
                queue.computeIfAbsent(e.getKey(), k -> new ArrayList<>()).add(e.getValue());
            }
        }
        RelationAnalysis ra = context.getAnalysisContext().get(RelationAnalysis.class);
        ra.populateQueue(queue, context.getTask().getMemoryModel().getRelations());
        while (!queue.isEmpty()) {
            Relation r = queue.keySet().iterator().next();
            logger.trace("Update encode set of '{}'", r);
            EventGraph s = encodeSets.get(r);
            EventGraph c = new EventGraph();
            for (EventGraph news : queue.remove(r)) {
                news.filter(s::add).apply(c::add);
            }
            if (!c.isEmpty()) {
                v.news = c;
                for (Map.Entry<Relation, EventGraph> e : r.getDefinition().accept(v).entrySet()) {
                    queue.computeIfAbsent(e.getKey(), k -> new ArrayList<>()).add(e.getValue());
                }
            }
        }
        logger.trace("End");
    }
}
