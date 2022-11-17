package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterIntersection;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.utils.Flag;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.google.common.collect.Iterables;
import com.google.common.collect.Sets;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.OptionNames.ENABLE_ACTIVE_SETS;
import static com.dat3m.dartagnan.program.event.Tag.INIT;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RF;
import static com.google.common.base.Preconditions.checkState;
import static com.google.common.base.Verify.verify;
import static com.google.common.collect.Sets.difference;
import static java.lang.Boolean.TRUE;
import static java.util.stream.Collectors.toList;

@Options
public class WmmEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(WmmEncoder.class);

    private final EncodingContext context;
    final Map<Relation, Set<Tuple>> encodeSets = new HashMap<>();

    // =====================================================================

    @Option(name = ENABLE_ACTIVE_SETS,
            description = "Filters relationships relevant to the task before encoding.",
            secure = true)
    private boolean enableActiveSets = true;

    // =====================================================================

    private WmmEncoder(EncodingContext c) {
        context = c;
        c.getAnalysisContext().requires(RelationAnalysis.class);
    }

    public static WmmEncoder withContext(EncodingContext context) throws InvalidConfigurationException {
        WmmEncoder encoder = new WmmEncoder(context);
        context.getTask().getConfig().inject(encoder);
        logger.info("{}: {}", ENABLE_ACTIVE_SETS, encoder.enableActiveSets);
        long t0 = System.currentTimeMillis();
        if (encoder.enableActiveSets) {
            encoder.initializeEncodeSets();
        } else {
            encoder.initializeAlternative();
        }
        logger.info("Finished active sets in {}ms", System.currentTimeMillis() - t0);
        RelationAnalysis ra = context.getAnalysisContext().get(RelationAnalysis.class);
        logger.info("Number of unknown tuples: {}", context.getTask().getMemoryModel().getRelations().stream()
                .filter(r -> !r.isInternal())
                .map(ra::getKnowledge)
                .mapToLong(k -> difference(k.getMaySet(), k.getMustSet()).size())
                .sum());
        logger.info("Number of encoded tuples: {}", encoder.encodeSets.entrySet().stream()
                .filter(e -> !e.getKey().isInternal())
                .mapToLong(e -> e.getValue().size())
                .sum());
        return encoder;
    }

    @Override
    public void initializeEncoding(SolverContext ctx) {
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
                        Iterables.transform(Wmm.BASE_RELATIONS, memoryModel::getRelation), // base relations
                        Iterables.transform(memoryModel.getAxioms(), Axiom::getRelation) // axiom relations
                )
        );
        RelationEncoder v = new RelationEncoder();
        BooleanFormula enc = v.bmgr.makeTrue();
        for (Relation rel : depGraph.getNodeContents()) {
            enc = v.bmgr.and(enc, rel.getDefinition().accept(v));
        }
        return enc;
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
                enc.add(a.consistent(context));
            }
        }
        for (Tuple t : ra.getMutuallyExclusiveTuples()) {
            enc.add(bmgr.not(context.execution(t.getFirst(), t.getSecond())));
        }
        return bmgr.and(enc);
    }

    public Set<Tuple> getTuples(Relation relation, Model model) {
        Set<Tuple> result = new HashSet<>();
        EncodingContext.EdgeEncoder edge = context.edge(relation);
        for (Tuple t : encodeSets.getOrDefault(relation, Set.of())) {
            if (TRUE.equals(model.evaluate(edge.encode(t)))) {
                result.add(t);
            }
        }
        for (Tuple t : context.getAnalysisContext().get(RelationAnalysis.class).getKnowledge(relation).getMustSet()) {
            if (TRUE.equals(model.evaluate(context.execution(t.getFirst(), t.getSecond())))) {
                result.add(t);
            }
        }
        return result;
    }

    private final class RelationEncoder implements Definition.Visitor<BooleanFormula> {
        final Program program = context.getTask().getProgram();
        final RelationAnalysis ra = context.getAnalysisContext().requires(RelationAnalysis.class);
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        @Override
        public BooleanFormula visitDefinition(Relation rel, List<? extends Relation> dependencies) {
            BooleanFormula enc = bmgr.makeTrue();
            for (Tuple tuple : encodeSets.get(rel)) {
                enc = bmgr.and(enc, bmgr.equivalence(edge(rel, tuple), execution(tuple)));
            }
            return enc;
        }
        @Override
        public BooleanFormula visitUnion(Relation rel, Relation... r) {
            BooleanFormula enc = bmgr.makeTrue();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            for (Tuple tuple : encodeSets.get(rel)) {
                BooleanFormula edge = edge(rel, tuple);
                if (k.containsMust(tuple)) {
                    enc = bmgr.and(enc, bmgr.equivalence(edge, execution(tuple)));
                    continue;
                }
                List<BooleanFormula> opt = new ArrayList<>(r.length);
                for (Relation relation : r) {
                    opt.add(edge(relation, tuple));
                }
                enc = bmgr.and(enc, bmgr.equivalence(edge, bmgr.or(opt)));
            }
            return enc;
        }
        @Override
        public BooleanFormula visitIntersection(Relation rel, Relation... r) {
            BooleanFormula enc = bmgr.makeTrue();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            RelationAnalysis.Knowledge[] knowledges = Stream.of(r).map(ra::getKnowledge).toArray(RelationAnalysis.Knowledge[]::new);
            EncodingContext.EdgeEncoder[] encoders = Stream.of(r).map(context::edge).toArray(EncodingContext.EdgeEncoder[]::new);
            for (Tuple tuple : encodeSets.get(rel)) {
                BooleanFormula edge = edge(rel, tuple);
                if (k.containsMust(tuple)) {
                    enc = bmgr.and(enc, bmgr.equivalence(edge, execution(tuple)));
                    continue;
                }
                List<BooleanFormula> opt = new ArrayList<>(r.length);
                for (int i = 0; i < r.length; i++) {
                    if (!knowledges[i].containsMust(tuple)) {
                        opt.add(encoders[i].encode(tuple));
                    }
                }
                enc = bmgr.and(enc, bmgr.equivalence(edge, bmgr.and(opt)));
            }
            return enc;
        }
        @Override
        public BooleanFormula visitDifference(Relation rel, Relation r1, Relation r2) {
            BooleanFormula enc = bmgr.makeTrue();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            for (Tuple tuple : encodeSets.get(rel)) {
                BooleanFormula edge = edge(rel, tuple);
                if (k.containsMust(tuple)) {
                    enc = bmgr.and(enc, bmgr.equivalence(edge, execution(tuple)));
                    continue;
                }
                BooleanFormula opt1 = edge(r1, tuple);
                BooleanFormula opt2 = bmgr.not(edge(r2, tuple));
                enc = bmgr.and(enc, bmgr.equivalence(edge, bmgr.and(opt1, opt2)));
            }
            return enc;
        }
        @Override
        public BooleanFormula visitComposition(Relation rel, Relation r1, Relation r2) {
            BooleanFormula enc = bmgr.makeTrue();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            final RelationAnalysis.Knowledge k1 = ra.getKnowledge(r1);
            final RelationAnalysis.Knowledge k2 = ra.getKnowledge(r2);
            final Set<Tuple> a1 = Sets.union(encodeSets.get(r1), k1.getMustSet());
            final Set<Tuple> a2 = Sets.union(encodeSets.get(r2), k2.getMustSet());
            final Function<Event, Collection<Tuple>> out = k1.getMayOut();
            for (Tuple tuple : encodeSets.get(rel)) {
                BooleanFormula expr = bmgr.makeFalse();
                if (k.containsMust(tuple)) {
                    expr = execution(tuple);
                } else {
                    Event x = tuple.getFirst();
                    Event z = tuple.getSecond();
                    for (Tuple t1 : out.apply(x)) {
                        Event y = t1.getSecond();
                        Tuple t2 = new Tuple(y, z);
                        if (k2.containsMay(t2)) {
                            verify(a1.contains(t1) && a2.contains(t2),
                                    "Failed to properly propagate active sets across composition at triple: (%s, %s, %s).", x, y, z);
                            expr = bmgr.or(expr, bmgr.and(edge(r1, t1), edge(r2, t2)));
                        }
                    }
                }
                enc = bmgr.and(enc, bmgr.equivalence(edge(rel, tuple), expr));
            }
            return enc;
        }
        @Override
        public BooleanFormula visitDomainIdentity(Relation rel, Relation r1) {
            BooleanFormula enc = bmgr.makeTrue();
            final Function<Event, Collection<Tuple>> mayOut = ra.getKnowledge(r1).getMayOut();
            for (Tuple tuple : encodeSets.get(rel)) {
                Event e = tuple.getFirst();
                BooleanFormula opt = bmgr.makeFalse();
                //TODO: Optimize using minSets (but no CAT uses this anyway)
                for (Tuple t : mayOut.apply(e)) {
                    opt = bmgr.or(opt, edge(r1, t));
                }
                enc = bmgr.and(enc, bmgr.equivalence(edge(rel, tuple), opt));
            }
            return enc;
        }
        @Override
        public BooleanFormula visitRangeIdentity(Relation rel, Relation r1) {
            BooleanFormula enc = bmgr.makeTrue();
            final Function<Event, Collection<Tuple>> mayIn = ra.getKnowledge(r1).getMayIn();
            //TODO: Optimize using minSets (but no CAT uses this anyway)
            for (Tuple tuple : encodeSets.get(rel)) {
                Event e = tuple.getFirst();
                BooleanFormula opt = bmgr.makeFalse();
                for (Tuple t : mayIn.apply(e)) {
                    opt = bmgr.or(opt, edge(r1, t));
                }
                enc = bmgr.and(enc, bmgr.equivalence(edge(rel, tuple), opt));
            }
            return enc;
        }
        @Override
        public BooleanFormula visitTransitiveClosure(Relation rel, Relation r1) {
            BooleanFormula enc = bmgr.makeTrue();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            final RelationAnalysis.Knowledge k1 = ra.getKnowledge(r1);
            final Function<Event, Collection<Tuple>> out = k1.getMayOut();
            for (Tuple tuple : encodeSets.get(rel)) {
                BooleanFormula edge = edge(rel, tuple);
                if (k.containsMust(tuple)) {
                    enc = bmgr.and(enc, bmgr.equivalence(edge, execution(tuple)));
                    continue;
                }
                BooleanFormula orClause = bmgr.makeFalse();
                Event e1 = tuple.getFirst();
                Event e2 = tuple.getSecond();
                if (k1.containsMay(tuple)) {
                    orClause = bmgr.or(orClause, edge(r1, tuple));
                }
                for (Tuple t : out.apply(e1)) {
                    Event e3 = t.getSecond();
                    if (e3.getGlobalId() != e1.getGlobalId() && e3.getGlobalId() != e2.getGlobalId() && k.containsMay(new Tuple(e3, e2))) {
                        BooleanFormula tVar = k.containsMust(t) ? edge(rel, t) : edge(r1, t);
                        orClause = bmgr.or(orClause, bmgr.and(tVar, edge(rel, new Tuple(e3, e2))));
                    }
                }
                enc = bmgr.and(enc, bmgr.equivalence(edge, orClause));
            }
            return enc;
        }
        @Override
        public BooleanFormula visitInverse(Relation rel, Relation r1) {
            BooleanFormula enc = bmgr.makeTrue();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            for (Tuple tuple : encodeSets.get(rel)) {
                enc = bmgr.and(enc, bmgr.equivalence(
                        edge(rel, tuple),
                        k.containsMust(tuple) ?
                                execution(tuple) :
                                edge(r1, tuple.getInverse())));
            }
            return enc;
        }
        @Override
        public BooleanFormula visitFences(Relation rel, FilterAbstract fenceSet) {
            BooleanFormula enc = bmgr.makeTrue();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            List<Event> fences = program.getCache().getEvents(fenceSet);
            for (Tuple tuple : encodeSets.get(rel)) {
                Event e1 = tuple.getFirst();
                Event e2 = tuple.getSecond();
                BooleanFormula orClause;
                if (k.containsMust(tuple)) {
                    orClause = bmgr.makeTrue();
                } else {
                    orClause = fences.stream()
                            .filter(f -> e1.getGlobalId() < f.getGlobalId() && f.getGlobalId() < e2.getGlobalId())
                            .map(context::execution).reduce(bmgr.makeFalse(), bmgr::or);
                }
                enc = bmgr.and(enc, bmgr.equivalence(
                        edge(rel, tuple),
                        bmgr.and(execution(tuple), orClause)));
            }
            return enc;
        }

        @Override
        public BooleanFormula visitInternalDataDependency(Relation idd) {
            return visitDirectDependency(idd);
        }

        @Override
        public BooleanFormula visitAddressDependency(Relation addrDirect) {
            return visitDirectDependency(addrDirect);
        }

        private BooleanFormula visitDirectDependency(Relation r) {
            List<BooleanFormula> enc = new ArrayList<>();
            Dependency dep = context.getAnalysisContext().get(Dependency.class);
            EncodingContext.EdgeEncoder edge = context.edge(r);
            for (Tuple t : encodeSets.get(r)) {
                Event writer = t.getFirst();
                Event reader = t.getSecond();
                if (!(writer instanceof RegWriter)) {
                    enc.add(bmgr.not(edge.encode(t)));
                } else {
                    Dependency.State s = dep.of(reader, ((RegWriter) writer).getResultRegister());
                    if (s.must.contains(writer)) {
                        enc.add(bmgr.equivalence(edge.encode(t), context.execution(writer, reader)));
                    } else if (!s.may.contains(writer)) {
                        enc.add(bmgr.not(edge.encode(t)));
                    }
                }
            }
            return bmgr.and(enc);
        }

        @Override
        public BooleanFormula visitCriticalSections(Relation rscs) {
            BooleanFormula enc = bmgr.makeTrue();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rscs);
            final Function<Event, Collection<Tuple>> mayIn = k.getMayIn();
            final Function<Event, Collection<Tuple>> mayOut = k.getMayOut();
            for (Tuple tuple : encodeSets.get(rscs)) {
                Event lock = tuple.getFirst();
                Event unlock = tuple.getSecond();
                BooleanFormula relation = execution(tuple);
                for (Tuple t : mayIn.apply(unlock)) {
                    Event y = t.getFirst();
                    if (lock.getGlobalId() < y.getGlobalId() && y.getGlobalId() < unlock.getGlobalId()) {
                        relation = bmgr.and(relation, bmgr.not(edge(rscs, t)));
                    }
                }
                for (Tuple t : mayOut.apply(lock)) {
                    Event y = t.getSecond();
                    if (lock.getGlobalId() < y.getGlobalId() && y.getGlobalId() < unlock.getGlobalId()) {
                        relation = bmgr.and(relation, bmgr.not(edge(rscs, t)));
                    }
                }
                enc = bmgr.and(enc, bmgr.equivalence(edge(rscs, tuple), relation));
            }
            return enc;
        }
        @Override
        public BooleanFormula visitReadModifyWrites(Relation rmw) {
            BooleanFormula enc = bmgr.makeTrue();
            BooleanFormula unpredictable = bmgr.makeFalse();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rmw);
            final Function<Event, Collection<Tuple>> mayIn = k.getMayIn();
            final Function<Event, Collection<Tuple>> mayOut = k.getMayOut();
            for (Event store : program.getCache().getEvents(
                    FilterIntersection.get(FilterBasic.get(Tag.WRITE), FilterBasic.get(Tag.EXCL)))) {
                checkState(store instanceof MemEvent, "non-memory event participating in '" + rmw.getNameOrTerm() + "'");
                BooleanFormula storeExec = bmgr.makeFalse();
                for (Tuple t : mayIn.apply(store)) {
                    MemEvent load = (MemEvent) t.getFirst();
                    BooleanFormula sameAddress = context.sameAddress(load, (MemEvent) store);
                    // Encode if load and store form an exclusive pair
                    BooleanFormula isPair = exclPair(load, store);
                    BooleanFormula pairingCond = pairingCond(load, store, mayIn, mayOut);
                    // For ARMv8, the store can be executed if addresses mismatch, but behaviour is "constrained unpredictable"
                    // The implementation does not include all possible unpredictable cases: in case of address
                    // mismatch, addresses of read and write are unknown, i.e. read and write can use any address.
                    // For RISCV and Power, addresses should match.
                    if (store.is(Tag.MATCHADDRESS)) {
                        pairingCond = bmgr.and(pairingCond, sameAddress);
                    } else {
                        unpredictable = bmgr.or(unpredictable, bmgr.and(context.execution(store), isPair, bmgr.not(sameAddress)));
                    }
                    enc = bmgr.and(enc, bmgr.equivalence(isPair, pairingCond));
                    storeExec = bmgr.or(storeExec, isPair);
                }
                enc = bmgr.and(enc, bmgr.implication(context.execution(store), storeExec));
            }
            for (Tuple tuple : encodeSets.get(rmw)) {
                MemEvent load = (MemEvent) tuple.getFirst();
                MemEvent store = (MemEvent) tuple.getSecond();
                if (!load.is(Tag.EXCL) || !store.is(Tag.EXCL)) {
                    enc = bmgr.and(enc, bmgr.equivalence(edge(rmw, tuple), context.execution(load, store)));
                    continue;
                }
                BooleanFormula sameAddress = store.is(Tag.MATCHADDRESS) ? bmgr.makeTrue() : context.sameAddress(load, store);
                enc = bmgr.and(enc, bmgr.equivalence(
                        edge(rmw, tuple),
                        k.containsMust(tuple) ? execution(tuple) :
                                // Relation between exclusive load and store
                                bmgr.and(context.execution(store), exclPair(load, store), sameAddress)));
            }
            return bmgr.and(enc, bmgr.equivalence(Flag.ARM_UNPREDICTABLE_BEHAVIOUR.repr(context.getFormulaManager()), unpredictable));
        }

        private BooleanFormula exclPair(Event load, Event store) {
            return bmgr.makeVariable("excl(" + load.getGlobalId() + "," + store.getGlobalId() + ")");
        }

        private BooleanFormula pairingCond(Event load, Event store, Function<Event, Collection<Tuple>> mayIn, Function<Event, Collection<Tuple>> mayOut) {
            BooleanFormula pairingCond = bmgr.and(context.execution(load), context.controlFlow(store));
            for (Tuple t : mayIn.apply(store)) {
                Event otherLoad = t.getFirst();
                if (otherLoad.getGlobalId() > load.getGlobalId()) {
                    pairingCond = bmgr.and(pairingCond, bmgr.not(context.execution(otherLoad)));
                }
            }
            for (Tuple t : mayOut.apply(load)) {
                Event otherStore = t.getSecond();
                if (otherStore.getGlobalId() < store.getGlobalId()) {
                    pairingCond = bmgr.and(pairingCond, bmgr.not(context.controlFlow(otherStore)));
                }
            }
            return pairingCond;
        }

        @Override
        public BooleanFormula visitSameAddress(Relation loc) {
            BooleanFormula enc = bmgr.makeTrue();
            for (Tuple tuple : encodeSets.get(loc)) {
                BooleanFormula rel = edge(loc, tuple);
                enc = bmgr.and(enc, bmgr.equivalence(rel, bmgr.and(
                        execution(tuple),
                        context.sameAddress((MemEvent) tuple.getFirst(), (MemEvent) tuple.getSecond())
                )));
            }
            return enc;
        }
        @Override
        public BooleanFormula visitReadFrom(Relation rf) {
            BooleanFormula enc = bmgr.makeTrue();
            Map<MemEvent, List<BooleanFormula>> edgeMap = new HashMap<>();
            for (Tuple tuple : ra.getKnowledge(rf).getMaySet()) {
                MemEvent w = (MemEvent) tuple.getFirst();
                MemEvent r = (MemEvent) tuple.getSecond();
                BooleanFormula edge = edge(rf, tuple);
                BooleanFormula sameAddress = context.sameAddress(w, r);
                BooleanFormula sameValue = context.equal(context.value(w), context.value(r));
                edgeMap.computeIfAbsent(r, key -> new ArrayList<>()).add(edge);
                enc = bmgr.and(enc, bmgr.implication(edge, bmgr.and(execution(tuple), sameAddress, sameValue)));
            }
            for (MemEvent r : edgeMap.keySet()) {
                enc = bmgr.and(enc, encodeEdgeSeq(r, edgeMap.get(r)));
            }
            return enc;
        }

        private BooleanFormula encodeEdgeSeq(Event read, List<BooleanFormula> edges) {
            if (GlobalSettings.ALLOW_MULTIREADS) {
                return bmgr.implication(context.execution(read), bmgr.or(edges));
            }
            int num = edges.size();
            int readId = read.getGlobalId();
            BooleanFormula lastSeqVar = mkSeqVar(readId, 0);
            BooleanFormula newSeqVar = lastSeqVar;
            BooleanFormula atMostOne = bmgr.equivalence(lastSeqVar, edges.get(0));
            for (int i = 1; i < num; i++) {
                newSeqVar = mkSeqVar(readId, i);
                atMostOne = bmgr.and(atMostOne, bmgr.equivalence(newSeqVar, bmgr.or(lastSeqVar, edges.get(i))));
                atMostOne = bmgr.and(atMostOne, bmgr.not(bmgr.and(edges.get(i), lastSeqVar)));
                lastSeqVar = newSeqVar;
            }
            BooleanFormula atLeastOne = bmgr.or(newSeqVar, edges.get(edges.size() - 1));
            atLeastOne = bmgr.implication(context.execution(read), atLeastOne);
            return bmgr.and(atMostOne, atLeastOne);
        }

        private BooleanFormula mkSeqVar(int readId, int i) {
            return bmgr.makeVariable("s(" + RF + ",E" + readId + "," + i + ")");
        }

        @Override
        public BooleanFormula visitMemoryOrder(Relation co) {
            List<BooleanFormula> enc = new ArrayList<>();
            boolean idl = !context.useSATEncoding;
            List<MemEvent> allWrites = program.getCache().getEvents(FilterBasic.get(WRITE)).stream()
                    .map(MemEvent.class::cast)
                    .sorted(Comparator.comparingInt(Event::getCId))
                    .collect(toList());
            RelationAnalysis.Knowledge k = ra.getKnowledge(co);
            Set<Tuple> transCo = idl ? ra.findTransitivelyImpliedCo(co) : null;
            IntegerFormulaManager imgr = idl ? context.getFormulaManager().getIntegerFormulaManager() : null;
            if (idl) {
                // ---- Encode clock conditions (init = 0, non-init > 0) ----
                NumeralFormula.IntegerFormula zero = imgr.makeNumber(0);
                for (MemEvent w : allWrites) {
                    NumeralFormula.IntegerFormula clock = context.memoryOrderClock(w);
                    enc.add(w.is(INIT) ? imgr.equal(clock, zero) : imgr.greaterThan(clock, zero));
                }
            }
            // ---- Encode coherences ----
            for (int i = 0; i < allWrites.size() - 1; i++) {
                MemEvent x = allWrites.get(i);
                for (MemEvent z : allWrites.subList(i + 1, allWrites.size())) {
                    Tuple xz = new Tuple(x, z);
                    Tuple zx = xz.getInverse();
                    boolean forwardPossible = k.containsMay(xz);
                    boolean backwardPossible = k.containsMay(zx);
                    if (!forwardPossible && !backwardPossible) {
                        continue;
                    }
                    BooleanFormula execPair = execution(xz);
                    BooleanFormula sameAddress = context.sameAddress(x, z);
                    BooleanFormula pairingCond = bmgr.and(execPair, sameAddress);
                    BooleanFormula coF = forwardPossible ? edge(co, xz) : bmgr.makeFalse();
                    BooleanFormula coB = backwardPossible ? edge(co, zx) : bmgr.makeFalse();
                    enc.add(bmgr.equivalence(pairingCond, bmgr.or(coF, coB)));
                    if (idl) {
                        enc.add(bmgr.implication(coF, x.is(INIT) || transCo.contains(xz) ? bmgr.makeTrue() :
                                imgr.lessThan(context.memoryOrderClock(x), context.memoryOrderClock(z))));
                        enc.add(bmgr.implication(coB, z.is(INIT) || transCo.contains(zx) ? bmgr.makeTrue() :
                                imgr.lessThan(context.memoryOrderClock(z), context.memoryOrderClock(x))));
                    } else {
                        enc.add(bmgr.or(bmgr.not(coF), bmgr.not(coB)));
                        if (!k.containsMust(xz) && !k.containsMust(zx)) {
                            for (MemEvent y : allWrites) {
                                Tuple xy = new Tuple(x, y);
                                Tuple yz = new Tuple(y, z);
                                if (forwardPossible && k.containsMay(xy) && k.containsMay(yz)) {
                                    enc.add(bmgr.implication(bmgr.and(edge(co, xy), edge(co, yz)), coF));
                                }
                                Tuple yx = xy.getInverse();
                                Tuple zy = yz.getInverse();
                                if (backwardPossible && k.containsMay(yx) && k.containsMay(zy)) {
                                    enc.add(bmgr.implication(bmgr.and(edge(co, yx), edge(co, zy)), coB));
                                }
                            }
                        }
                    }
                }
            }
            return bmgr.and(enc);
        }

        private BooleanFormula edge(Relation relation, Tuple tuple) {
            return context.edge(relation, tuple);
        }
        private BooleanFormula execution(Tuple tuple) {
            return context.execution(tuple.getFirst(), tuple.getSecond());
        }
    }

    private void initializeAlternative() {
        RelationAnalysis ra = context.getAnalysisContext().get(RelationAnalysis.class);
        for (Relation r : context.getTask().getMemoryModel().getRelations()) {
            encodeSets.put(r, ra.getKnowledge(r).getMaySet());
        }
    }

    private void initializeEncodeSets() {
        for (Relation r : context.getTask().getMemoryModel().getRelations()) {
            encodeSets.put(r, new HashSet<>());
        }
        EncodeSets v = new EncodeSets(context.getAnalysisContext());
        Map<Relation, List<Stream<Tuple>>> queue = new HashMap<>();
        for (Axiom a : context.getTask().getMemoryModel().getAxioms()) {
            for (Map.Entry<Relation, Set<Tuple>> e : a.getEncodeTupleSets(context.getTask(), context.getAnalysisContext()).entrySet()) {
                queue.computeIfAbsent(e.getKey(), k -> new ArrayList<>()).add(e.getValue().stream());
            }
        }
        RelationAnalysis ra = context.getAnalysisContext().get(RelationAnalysis.class);
        RelationAnalysis.Propagator p = ra.new Propagator();
        for (Relation r : context.getTask().getMemoryModel().getRelations()) {
            Set<Tuple> may = new HashSet<>();
            Set<Tuple> must = new HashSet<>();
            if (r.getDependencies().isEmpty()) {
                continue;
            }
            for (Relation c : r.getDependencies()) {
                p.source = c;
                p.may = ra.getKnowledge(p.source).getMaySet();
                p.must = ra.getKnowledge(p.source).getMustSet();
                RelationAnalysis.Delta s = r.getDefinition().accept(p);
                may.addAll(s.may);
                must.addAll(s.must);
            }
            may.removeAll(ra.getKnowledge(r).getMaySet());
            Set<Tuple> must2 = difference(ra.getKnowledge(r).getMustSet(), must);
            queue.computeIfAbsent(r, k -> new ArrayList<>()).add(Stream.concat(may.stream(), must2.stream()));
        }
        while (!queue.isEmpty()) {
            Relation r = queue.keySet().iterator().next();
            Set<Tuple> s = encodeSets.get(r);
            List<Tuple> c = new ArrayList<>();
            for (Stream<Tuple> news : queue.remove(r)) {
                news.filter(s::add).forEach(c::add);
            }
            if (!c.isEmpty()) {
                v.news = c;
                for (Map.Entry<Relation, Stream<Tuple>> e : r.getDefinition().accept(v).entrySet()) {
                    queue.computeIfAbsent(e.getKey(), k -> new ArrayList<>()).add(e.getValue());
                }
            }
        }
    }
}
