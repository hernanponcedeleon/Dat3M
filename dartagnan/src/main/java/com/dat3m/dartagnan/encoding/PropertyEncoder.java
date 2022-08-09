package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterMinus;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelCo;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelRf;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.Property.*;
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

    public BooleanFormula encodeSpecification(EnumSet<Property> property, SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
    	// We have a default property therefore this false will always be overwritten
    	BooleanFormula enc = bmgr.makeFalse();
    	if(property.contains(REACHABILITY)) {
    		enc = bmgr.or(enc, encodeAssertions(ctx));
    	}
    	if(property.contains(LIVENESS)) {
    		enc = bmgr.or(enc, encodeLiveness(ctx));
    	}
    	if(property.contains(RACES)) {
    		enc = bmgr.or(enc, encodeDataRaces(ctx));
    	}
    	if(property.contains(CAT)) {
    		enc = bmgr.or(enc, encodeCATProperties(ctx));
    	}
    	return enc;
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
        // We use the SMT variable to extract from the model if the property was violated
		BooleanFormula enc = bmgr.equivalence(REACHABILITY.getSMTVariable(ctx), assertionEncoding);
		// No need to use the SMT variable if the formula is trivially false 
        return bmgr.isFalse(assertionEncoding) ? assertionEncoding : bmgr.and(REACHABILITY.getSMTVariable(ctx), enc);
    }

    public BooleanFormula encodeCATProperties(SolverContext ctx) {
        logger.info("Encoding CAT properties");

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula cat = bmgr.makeTrue();
        BooleanFormula one = bmgr.makeFalse();
    	for(Axiom ax : memoryModel.getAxioms()) {
    		// Only flagged axioms are encoded as properties
    		if(!ax.isFlagged()) {
    			continue;
    		}
			cat = bmgr.and(cat, bmgr.equivalence(CAT.getSMTVariable(ax, ctx), ax.consistent(ctx)));
			one = bmgr.or(one, CAT.getSMTVariable(ax, ctx));
    	}
		// No need to use the SMT variable if the formula is trivially false
        return bmgr.isFalse(one) ? one : bmgr.and(one, cat);
    }

    public BooleanFormula encodeLiveness(SolverContext ctx) {

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

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        RelRf rf = (RelRf) memoryModel.getRelationRepository().getRelation(RelationNameRepository.RF);
        RelCo co = (RelCo) memoryModel.getRelationRepository().getRelation(RelationNameRepository.CO);
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
                    for (Tuple rfEdge : rf.getMaxTupleSet().getBySecond(load)) {
                        coMaximalLoad = bmgr.or(coMaximalLoad, bmgr.and(rf.getSMTVar(rfEdge, ctx), co.getLastCoVar(rfEdge.getFirst(), ctx)));
                    }
                    allCoMaximalLoad = bmgr.and(allCoMaximalLoad, coMaximalLoad);
                }
                isStuck  = bmgr.or(isStuck, bmgr.and(pair.bound.exec(), allCoMaximalLoad));
            }
            isStuckMap.put(t, isStuck);
        }

        // LivenessViolation <=> allStuckOrDone /\ atLeastOneStuck
        BooleanFormula allStuckOrDone = bmgr.makeTrue();
        BooleanFormula atLeastOneStuck = bmgr.makeFalse();
        for (Thread t : program.getThreads()) {
            BooleanFormula isStuck = isStuckMap.getOrDefault(t, bmgr.makeFalse());
            BooleanFormula isDone = t.getCache().getEvents(FilterBasic.get(Tag.EARLYTERMINATION)).stream()
                    .map(e -> bmgr.not(e.exec())).reduce(bmgr.makeTrue(), bmgr::and);

            atLeastOneStuck = bmgr.or(atLeastOneStuck, isStuck);
            allStuckOrDone = bmgr.and(allStuckOrDone, bmgr.or(isStuck, isDone));
        }

        BooleanFormula livenessViolation = bmgr.and(allStuckOrDone, atLeastOneStuck);
        // We use the SMT variable to extract from the model if the property was violated
		BooleanFormula enc = bmgr.equivalence(LIVENESS.getSMTVariable(ctx), livenessViolation);
		// No need to use the SMT variable if the formula is trivially false 
        return bmgr.isFalse(enc) ? enc : bmgr.and(LIVENESS.getSMTVariable(ctx), enc);
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
        // We use the SMT variable to extract from the model if the property was violated
		enc = bmgr.equivalence(RACES.getSMTVariable(ctx), enc);
		// No need to use the SMT variable if the formula is trivially false 
        return bmgr.isFalse(enc) ? enc : bmgr.and(RACES.getSMTVariable(ctx), enc);
    }
}
