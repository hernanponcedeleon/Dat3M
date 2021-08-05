package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import static com.dat3m.dartagnan.program.utils.EType.VISIBLE;

import java.util.*;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

/**
 *
 * @author Florian Furbach
 */
public class Acyclic extends Axiom {

	private static final Logger logger = LogManager.getLogger(Acyclic.class);

    public Acyclic(Relation rel) {
        super(rel);
    }

    @Override
    public TupleSet getEncodeTupleSet(){
        logger.info("Computing encodeTupleSet for " + this);
        // ====== Construct [Event -> Successor] mapping ======
        Map<Event, Collection<Event>> succMap = new HashMap<>();
        TupleSet relMaxTuple = rel.getMaxTupleSet();
        for (Tuple t : relMaxTuple) {
            succMap.computeIfAbsent(t.getFirst(), key -> new ArrayList<>()).add(t.getSecond());
        }

        // ====== Compute SCCs ======
        DependencyGraph<Event> depGraph = DependencyGraph.from(succMap.keySet(), succMap);
        TupleSet result = new TupleSet();
        for (Set<DependencyGraph<Event>.Node> scc : depGraph.getSCCs()) {
            for (DependencyGraph<Event>.Node node1 : scc) {
                Event e1 = node1.getContent();
                for (DependencyGraph<Event>.Node node2 : scc) {
                    Event e2 = node2.getContent();
                    Tuple t = new Tuple(e1,e2);
                    if (relMaxTuple.contains(t)) {
                        result.add(t);
                    }
                }
            }
        }
        if (GlobalSettings.ENABLE_DEBUG_OUTPUT) {
            for (Tuple t : result) {
                Event e1 = t.getFirst();
                Event e2 = t.getSecond();
                if (!e1.is(VISIBLE) || !e2.is(VISIBLE)) {
                    System.out.println(t + " is non-visible");
                }
            }
        }

        logger.info("encodeTupleSet size " + result.size());
        return result;
    }

    @Override
	public BooleanFormula consistent(SolverContext ctx) {
    	FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();

        BooleanFormula enc = bmgr.makeTrue();
        for(Tuple tuple : rel.getEncodeTupleSet()){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();
			enc = bmgr.and(enc, bmgr.implication(rel.getSMTVar(tuple, ctx),
									imgr.lessThan(
											Utils.intVar(rel.getName(), e1, ctx), 
											Utils.intVar(rel.getName(), e2, ctx))));
        }
        return enc;
    }

    @Override
    protected String _toString() {
        return "acyclic " + rel.getName();
    }
}