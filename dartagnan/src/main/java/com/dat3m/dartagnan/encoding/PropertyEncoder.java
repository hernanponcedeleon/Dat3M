package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterMinus;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.Property.*;
import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.dat3m.dartagnan.program.event.Tag.INIT;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;
import static com.google.common.base.Preconditions.*;


@Options
public class PropertyEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(PropertyEncoder.class);

    private final EncodingContext context;
    private final Program program;
    private final Wmm memoryModel;
    private final ExecutionAnalysis exec;
    private final AliasAnalysis alias;
    private final RelationAnalysis ra;

    // =====================================================================

    private PropertyEncoder(EncodingContext c) {
        checkArgument(c.getTask().getProgram().isCompiled(),
                "The program must get compiled first before its properties can be encoded.");
        context = c;
        program = c.getTask().getProgram();
        memoryModel = c.getTask().getMemoryModel();
        exec = c.getAnalysisContext().requires(ExecutionAnalysis.class);
        alias = c.getAnalysisContext().requires(AliasAnalysis.class);
        ra = c.getAnalysisContext().requires(RelationAnalysis.class);
    }

    public static PropertyEncoder withContext(EncodingContext context) throws InvalidConfigurationException {
        PropertyEncoder encoder = new PropertyEncoder(context);
        context.getTask().getConfig().inject(encoder);
        return encoder;
    }

    @Override
    public void initializeEncoding(SolverContext context) { }

    public BooleanFormula encodeSpecification() {
        EnumSet<Property> property = context.getTask().getProperty();
    	BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
    	// We have a default property therefore this false will always be overwritten
    	BooleanFormula enc = bmgr.makeFalse();
    	if(property.contains(REACHABILITY)) {
    		enc = bmgr.or(enc, encodeAssertions());
    	}
    	if(property.contains(LIVENESS)) {
    		enc = bmgr.or(enc, encodeLiveness());
    	}
    	if(property.contains(RACES)) {
    		enc = bmgr.or(enc, encodeDataRaces());
    	}
    	if(property.contains(CAT)) {
    		enc = bmgr.or(enc, encodeCATProperties());
    	}
        if (program.getFormat().equals(LITMUS) || property.contains(LIVENESS)) {
            enc = bmgr.and(enc, encodeLastCoConstraints());
        }
    	return enc;
    }

    public BooleanFormula encodeBoundEventExec() {
        logger.info("Encoding bound events execution");
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        return program.getCache().getEvents(FilterMinus.get(FilterBasic.get(Tag.BOUND), FilterBasic.get(Tag.SPINLOOP)))
                .stream().map(context::execution).reduce(bmgr.makeFalse(), bmgr::or);
    }

    public BooleanFormula encodeAssertions() {
        logger.info("Encoding assertions");
        SolverContext ctx = context.getSolverContext();
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula assertionEncoding = program.getAss().encode(context);
        // We use the SMT variable to extract from the model if the property was violated
		BooleanFormula enc = bmgr.equivalence(REACHABILITY.getSMTVariable(ctx), assertionEncoding);
		// No need to use the SMT variable if the formula is trivially false 
        return bmgr.isFalse(assertionEncoding) ? assertionEncoding : bmgr.and(REACHABILITY.getSMTVariable(ctx), enc);
    }

    public BooleanFormula encodeCATProperties() {
        logger.info("Encoding CAT properties");
        SolverContext ctx = context.getSolverContext();
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula cat = bmgr.makeTrue();
        BooleanFormula one = bmgr.makeFalse();
    	for(Axiom ax : memoryModel.getAxioms()) {
    		// Only flagged axioms are encoded as properties
    		if(!ax.isFlagged()) {
    			continue;
    		}
            BooleanFormula v = CAT.getSMTVariable(ax, ctx);
			cat = bmgr.and(cat, bmgr.equivalence(v, ax.consistent(context)));
			one = bmgr.or(one, v);
    	}
		// No need to use the SMT variable if the formula is trivially false
        return bmgr.isFalse(one) ? one : bmgr.and(one, cat);
    }

    public BooleanFormula encodeLiveness() {

        // We assume a spinloop to consist of a tagged label and bound jump.
        // Further, we assume that the spinloops are indeed correct, i.e., side-effect free
        class SpinLoop {
            public List<Load> loads = new ArrayList<>();
            public Event bound;
        }

        logger.info("Encoding liveness");

        Map<Thread, List<SpinLoop>> spinloopsMap = new HashMap<>();
        // Find spinloops of all threads
        for (Thread t : program.getThreads()) {
            List<Event> spinStarts = t.getEvents().stream().filter(e -> e instanceof Label && e.is(Tag.SPINLOOP)).collect(Collectors.toList());
            List<SpinLoop> spinLoops = new ArrayList<>();
            spinloopsMap.put(t, spinLoops);

            Event cur = t.getEntry();
            List<Load> loads = new ArrayList<>();
            while(cur != null) {
            	if(spinStarts.contains(cur)) {
            		// A new loop started: we reset the load list
            		loads = new ArrayList<>();
            	}
                if(cur.is(Tag.READ)) {
                	// Update
                    loads.add((Load)cur);
                }
                if(cur.is(Tag.SPINLOOP) && !spinStarts.contains(cur)) {
                	// We found one possible end of the loop
                	// There might be others thus we keep the load list
                    SpinLoop loop = new SpinLoop();
                    loop.bound = cur;
                    loop.loads.addAll(loads);
                	spinLoops.add(loop);
                }
            	cur = cur.getSuccessor();
            }
        }

        SolverContext ctx = context.getSolverContext();
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        Relation rf = memoryModel.getRelation(RelationNameRepository.RF);
        final EncodingContext.EdgeEncoder edge = context.edge(rf);
        // Compute "stuckness": A thread is stuck if it reaches a spinloop bound event
        // while reading from a co-maximal write.
        Map<Thread, BooleanFormula> isStuckMap = new HashMap<>();
        for (Thread t : program.getThreads()) {
            List<SpinLoop> loops = spinloopsMap.get(t);
            if (loops.isEmpty()) {
                continue;
            }

            BooleanFormula isStuck = bmgr.makeFalse();
            for (SpinLoop pair : loops) {
                BooleanFormula allCoMaximalLoad = bmgr.makeTrue();
                for (Load load : pair.loads) {
                    BooleanFormula coMaximalLoad = bmgr.makeFalse();
                    for (Tuple rfEdge : ra.getKnowledge(rf).getMaySet().getBySecond(load)) {
                        coMaximalLoad = bmgr.or(coMaximalLoad, bmgr.and(edge.encode(rfEdge), lastCoVar(rfEdge.getFirst())));
                    }
                    allCoMaximalLoad = bmgr.and(allCoMaximalLoad, coMaximalLoad);
                }
                isStuck  = bmgr.or(isStuck, bmgr.and(context.execution(pair.bound), allCoMaximalLoad));
            }
            isStuckMap.put(t, isStuck);
        }

        // LivenessViolation <=> allStuckOrDone /\ atLeastOneStuck
        BooleanFormula allStuckOrDone = bmgr.makeTrue();
        BooleanFormula atLeastOneStuck = bmgr.makeFalse();
        for (Thread t : program.getThreads()) {
            BooleanFormula isStuck = isStuckMap.getOrDefault(t, bmgr.makeFalse());
            BooleanFormula pending = t.getCache().getEvents(FilterBasic.get(Tag.EARLYTERMINATION)).stream()
                    .map(context::execution).reduce(bmgr.makeFalse(), bmgr::or);

            atLeastOneStuck = bmgr.or(atLeastOneStuck, isStuck);
            allStuckOrDone = bmgr.and(allStuckOrDone, bmgr.or(isStuck, bmgr.not(pending)));
        }

        BooleanFormula livenessViolation = bmgr.and(allStuckOrDone, atLeastOneStuck);
        // We use the SMT variable to extract from the model if the property was violated
		BooleanFormula enc = bmgr.equivalence(LIVENESS.getSMTVariable(ctx), livenessViolation);
		// No need to use the SMT variable if the formula is trivially false 
        return bmgr.isFalse(enc) ? enc : bmgr.and(LIVENESS.getSMTVariable(ctx), enc);
    }

    public BooleanFormula encodeDataRaces() {
        final Relation hbRelation = memoryModel.getRelation("hb");
        final EncodingContext.EdgeEncoder hb = context.edge(hbRelation);
        checkState(memoryModel.getAxioms().stream().anyMatch(ax ->
                        ax.isAcyclicity() && ax.getRelation().equals(hbRelation)),
                "The provided WMM needs an 'acyclic(hb)' axiom to encode data races.");
        logger.info("Encoding data-races");
        SolverContext ctx = context.getSolverContext();
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
                            BooleanFormula conflict = bmgr.and(context.execution(m, w), hb.encode(m, w),
                                    context.sameAddress(w, m),
                                    imgr.equal(context.clockVariable("hb", w),
                                            imgr.add(context.clockVariable("hb", m), imgr.makeNumber(BigInteger.ONE))));
                            enc = bmgr.or(enc, conflict);
                        }
                    }
                }
            }
        }
        // We use the SMT variable to extract from the model if the property was violated
		enc = bmgr.equivalence(RACES.getSMTVariable(ctx), enc);
		// No need to use the SMT variable if the formula is trivially false 
        return bmgr.isFalse(enc) ? enc : bmgr.and(RACES.getSMTVariable(ctx), enc);
    }

    private BooleanFormula encodeLastCoConstraints() {
        final Relation co = memoryModel.getRelation(CO);
        SolverContext ctx = context.getSolverContext();
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final EncodingContext.EdgeEncoder edge = context.edge(co);
        final RelationAnalysis.Knowledge knowledge = ra.getKnowledge(co);
        final List<Event> initEvents = program.getCache().getEvents(FilterBasic.get(INIT));
        final List<Event> writes = program.getCache().getEvents(FilterBasic.get(WRITE));
        final boolean doEncodeFinalAddressValues = program.getFormat() == LITMUS;
        // Find transitively implied coherences. We can use these to reduce the encoding.
        final Set<Tuple> transCo = ra.findTransitivelyImpliedCo(co);
        // Find all writes that are never last, i.e., those that will always have a co-successor.
        final Set<Event> dominatedWrites = knowledge.getMustSet().stream()
                .filter(t -> exec.isImplied(t.getFirst(), t.getSecond()))
                .map(Tuple::getFirst).collect(Collectors.toSet());
        // ---- Construct encoding ----
        BooleanFormula enc = bmgr.makeTrue();
        for (Event writeEvent : writes) {
            MemEvent w1 = (MemEvent) writeEvent;
            if (dominatedWrites.contains(w1)) {
                enc = bmgr.and(enc, bmgr.not(lastCoVar(w1)));
                continue;
            }
            BooleanFormula isLast = context.execution(w1);
            // ---- Find all possibly overwriting writes ----
            for (Tuple t : knowledge.getMaySet().getByFirst(w1)) {
                if (transCo.contains(t)) {
                    // We can skip the co-edge (w1,w2), because there will be an intermediate write w3
                    // that already witnesses that w1 is not last.
                    continue;
                }
                Event w2 = t.getSecond();
                BooleanFormula isAfter = bmgr.not(knowledge.getMustSet().contains(t) ? context.execution(w2) : edge.encode(t));
                isLast = bmgr.and(isLast, isAfter);
            }
            BooleanFormula lastCoExpr = lastCoVar(w1);
            enc = bmgr.and(enc, bmgr.equivalence(lastCoExpr, isLast));
            if (doEncodeFinalAddressValues) {
                // ---- Encode final values of addresses ----
                for (Event initEvent : initEvents) {
                    Init init = (Init) initEvent;
                    if (!alias.mayAlias(w1, init)) {
                        continue;
                    }
                    BooleanFormula sameAddress = context.sameAddress(init, w1);
                    Formula v2 = init.getBase().getLastMemValueExpr(ctx, init.getOffset());
                    BooleanFormula sameValue = context.equal(context.value(w1), v2);
                    enc = bmgr.and(enc, bmgr.implication(bmgr.and(lastCoExpr, sameAddress), sameValue));
                }
            }
        }
        return enc;
    }

    private BooleanFormula lastCoVar(Event write) {
        return context.getBooleanFormulaManager().makeVariable("co_last(" + write.repr() + ")");
    }
}
