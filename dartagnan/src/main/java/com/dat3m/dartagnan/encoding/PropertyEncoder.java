package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.lang.svcomp.LoopStart;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterMinus;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelCo;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelRf;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.google.common.base.Verify;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.wmm.utils.Utils.edge;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;
import static com.google.common.base.Preconditions.*;


@Options
public class PropertyEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(PropertyEncoder.class);

    private final Program program;
    private final Wmm memoryModel;
    private final AliasAnalysis alias;

    @Option(
            name = OptionNames.PROPERTY,
            description = "The property to check for.")
    private Property property = Property.getDefault();

    // =====================================================================

    private PropertyEncoder(Program program, Wmm wmm, Context context, Configuration config) throws InvalidConfigurationException {
        checkArgument(program.isCompiled(),
                "The program must get compiled first before its properties can be encoded.");
        this.program = checkNotNull(program);
        this.memoryModel = checkNotNull(wmm);
        this.alias = context.requires(AliasAnalysis.class);
        config.inject(this);
    }

    public static PropertyEncoder fromConfig(Program program, Wmm wmm, Context context, Configuration config) throws InvalidConfigurationException {
        return new PropertyEncoder(program, wmm, context, config);
    }

    @Override
    public void initializeEncoding(SolverContext context) { }

    public BooleanFormula encodeSpecification(SolverContext ctx) {
        switch (property) {
            case REACHABILITY:
                return encodeAssertions(ctx);
            case LIVENESS:
                return encodeLiveness(ctx);
            case RACES:
                return encodeDataRaces(ctx);
            default:
                throw new IllegalStateException("Unrecognized specification: " + property);
        }
    }

    public BooleanFormula encodeBoundEventExec(SolverContext ctx){
        logger.info("Encoding bound events execution");

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        return program.getCache().getEvents(FilterMinus.get(FilterBasic.get(Tag.BOUND), FilterBasic.get(Tag.SPINLOOP)))
                .stream().map(Event::exec).reduce(bmgr.makeFalse(), bmgr::or);
    }

    public BooleanFormula encodeAssertions(SolverContext ctx) {
        logger.info("Encoding assertions");

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula assertionEncoding = program.getAss().encode(ctx);
        if (program.getAssFilter() != null) {
            assertionEncoding = bmgr.and(assertionEncoding, program.getAssFilter().encode(ctx));
        }
        return assertionEncoding;
    }

    public BooleanFormula encodeLiveness(SolverContext ctx) {

        // We assume a spinloop has exactly one load it performs
        // The pair is the load + the bound event (which is reached if the spinloop does not terminate)
        class SpinPair {
            public final Load load;
            public final Event bound;
            public SpinPair(Load load, Event bound) {
                this.load = load;
                this.bound = bound;
            }
        }
        logger.info("Encoding liveness");

        Map<Thread, List<SpinPair>> spinloopsMap = new HashMap<>();

        // Find spin pairs of all threads
        for (Thread t : program.getThreads()) {
            List<Event> spinStarts = t.getEvents().stream().filter(e -> e instanceof LoopStart).collect(Collectors.toList());
            List<SpinPair> spinPairs = new ArrayList<>();
            for (Event start : spinStarts) {
                Load load = null;
                Event cur = start;
                while (!cur.is(Tag.SPINLOOP)) {
                    cur = cur.getSuccessor();
                    if (cur.is(Tag.READ)) {
                        // Todo: Multiple loads are no problem in principle: all of them have to return a co-maximal write.
                        Verify.verify(load == null, "Found two loads in a single spinloop.");
                        load = (Load)cur;
                    } else if (cur.is(Tag.MEMORY)) {
                        throw new IllegalStateException("Spinloop contains a non-read memory event?!");
                    }
                }
                spinPairs.add(new SpinPair(load, cur));
            }
            spinloopsMap.put(t, spinPairs);
        }

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        RelRf rf = (RelRf) memoryModel.getRelationRepository().getRelation(RelationNameRepository.RF);
        RelCo co = (RelCo) memoryModel.getRelationRepository().getRelation(RelationNameRepository.CO);
        // Compute "stuckness": A thread is stuck if it reaches a spinloop bound event
        // while reading from a co-maximal write.
        Map<Thread, BooleanFormula> isStuckMap = new HashMap<>();
        for (Thread t : program.getThreads()) {
            List<SpinPair> pairs = spinloopsMap.get(t);
            if (pairs.isEmpty()) {
                continue;
            }

            BooleanFormula isStuck = bmgr.makeFalse();
            for (SpinPair pair : pairs) {
                Event bound = pair.bound;
                Load load = pair.load;
                BooleanFormula coMaximalLoad = bmgr.makeFalse();
                for (Tuple rfEdge : rf.getMaxTupleSet().getBySecond(load)) {
                    coMaximalLoad = bmgr.or(coMaximalLoad, bmgr.and(rf.getSMTVar(rfEdge, ctx), co.getLastCoVar(rfEdge.getFirst(), ctx)));
                }
                isStuck  = bmgr.or(isStuck, bmgr.and(bound.exec(), coMaximalLoad));
            }
            isStuckMap.put(t, isStuck);
        }

        // Encode liveness: We have a liveness violation if there exists a thread t such that
        // t is stuck and all other threads are either stuck or finished their execution
        BooleanFormula livenessViolation = bmgr.makeFalse();
        for (Thread t : isStuckMap.keySet()) {
            BooleanFormula isStuck = isStuckMap.get(t);
            BooleanFormula othersStuckOrDone = bmgr.makeTrue();
            for (Thread t2 : isStuckMap.keySet()) {
                if (t2 == t) {
                    continue;
                }
                BooleanFormula otherStuck = isStuckMap.get(t2);
                // There are two ways to define "done":
                // (1) isDone <=> no spin loop bound was reached
                // (2) isDone <=> no loop bound was reached
                // We use the second definition for now

                /*BooleanFormula isDone = spinloopsMap.get(t2).stream().map(pair -> bmgr.not(pair.bound.exec()))
                        .reduce(bmgr.makeTrue(), bmgr::and);*/
                BooleanFormula isDone = t2.getCache().getEvents(FilterBasic.get(Tag.BOUND)).stream().map(e -> bmgr.not(e.exec()))
                        .reduce(bmgr.makeTrue(), bmgr::and);
                othersStuckOrDone = bmgr.and(othersStuckOrDone, bmgr.or(otherStuck, isDone));
            }
            livenessViolation = bmgr.or(livenessViolation, bmgr.and(isStuck, othersStuckOrDone));
        }

        return livenessViolation;
    }

    public BooleanFormula encodeDataRaces(SolverContext ctx) {
        final String hb = "hb";
        checkState(memoryModel.getAxioms().stream().anyMatch(ax ->
                        ax.isAcyclicity() && ax.getRelation().getName().equals(hb)),
                "The provided WMM needs an 'acyclic(hb)' axiom to encode data races.");
        logger.info("Encoding data-races");

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();

        BooleanFormula enc = bmgr.makeFalse();
        for(Thread t1 : program.getThreads()) {
            for(Thread t2 : program.getThreads()) {
                if(t1.getId() == t2.getId()) {
                    continue;
                }
                for(Event e1 : t1.getCache().getEvents(FilterMinus.get(FilterBasic.get(Tag.WRITE), FilterBasic.get(Tag.INIT)))) {
                    MemEvent w = (MemEvent)e1;
                    for(Event e2 : t2.getCache().getEvents(FilterMinus.get(FilterBasic.get(Tag.MEMORY), FilterBasic.get(Tag.INIT)))) {
                        MemEvent m = (MemEvent)e2;
                        if(w.hasFilter(Tag.RMW) && m.hasFilter(Tag.RMW)) {
                            continue;
                        }
                        if(w.canRace() && m.canRace() && alias.mayAlias(w, m)) {
                            BooleanFormula conflict = bmgr.and(m.exec(), w.exec(), edge(hb, m, w, ctx),
                                    generalEqual(w.getMemAddressExpr(), m.getMemAddressExpr(), ctx),
                                    imgr.equal(intVar(hb, w, ctx),
                                            imgr.add(intVar(hb, m, ctx), imgr.makeNumber(BigInteger.ONE))));
                            enc = bmgr.or(enc, conflict);
                        }
                    }
                }
            }
        }
        return enc;
    }


}
