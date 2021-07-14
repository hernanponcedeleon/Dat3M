package com.dat3m.dartagnan.analysis;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.dat3m.dartagnan.wmm.utils.Utils.edge;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;

import java.math.BigInteger;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterMinus;

public class DataRaces {
	
	// This analysis assumes that CAT file defining the memory model has a happens-before 
	// relation named hb: it should contain the following axiom "acyclic hb"

    private static final Logger logger = LogManager.getLogger(DataRaces.class);

	public static Result checkForRaces(SolverContext ctx, VerificationTask task) {
        Result res = Result.UNKNOWN;
        ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);

		// TODO(HP): No program.simplify() ???
		task.unrollAndCompile();
		task.initialiseEncoding(ctx);
		
		try {
			prover.addConstraint(task.encodeProgram(ctx));
			prover.addConstraint(task.encodeWmmRelations(ctx));
	        prover.addConstraint(task.encodeWmmConsistency(ctx));
	        prover.push();
	        prover.addConstraint(encodeRaces(task.getProgram(), ctx));
	        
			BooleanFormula noBoundEventExec = task.getProgram().encodeNoBoundEventExec(ctx);
			
			if(prover.isUnsat()) {
	        	prover.pop();
				prover.addConstraint(ctx.getFormulaManager().getBooleanFormulaManager().not(noBoundEventExec));
	        	return prover.isUnsat() ? PASS : UNKNOWN;
	        } else {
	        	prover.addConstraint(noBoundEventExec);
				return prover.isUnsat() ? UNKNOWN : FAIL;
	        }
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return res;
    }
    
    private static BooleanFormula encodeRaces(Program p, SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
    	IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
    	
		BooleanFormula enc = bmgr.makeFalse();
    	for(Thread t1 : p.getThreads()) {
    		for(Thread t2 : p.getThreads()) {
    			if(t1.getId() == t2.getId()) {
    				continue;
    			}
    			for(Event e1 : t1.getCache().getEvents(FilterMinus.get(FilterBasic.get(EType.WRITE), FilterBasic.get(EType.INIT)))) {
    				MemEvent w = (MemEvent)e1;
    				for(Event e2 : t2.getCache().getEvents(FilterMinus.get(FilterBasic.get(EType.MEMORY), FilterBasic.get(EType.INIT)))) {
    					MemEvent m = (MemEvent)e2;
    					if(w.hasFilter(EType.RMW) && m.hasFilter(EType.RMW)) {
    						continue;
    					}
    					// TODO improve this: these events correspond to return statements
    					if(w.getMemValue() instanceof BConst && !((BConst)w.getMemValue()).getValue()) {
    						continue;
    					}
    					if(m.getMemValue() instanceof BConst && !((BConst)m.getMemValue()).getValue()) {
    						continue;
    					}
    					if(w.canRace() && m.canRace() && MemEvent.canAddressTheSameLocation(w, m)) {
    						BooleanFormula conflict = bmgr.and(m.exec(), w.exec(), imgr.equal(
    								(IntegerFormula)w.getMemAddressExpr(), 
    								(IntegerFormula)m.getMemAddressExpr()), 
        							edge("hb", m, w, ctx), imgr.equal(
        									intVar("hb", w, ctx), 
        									imgr.add(intVar("hb", m, ctx), imgr.makeNumber(BigInteger.ONE))));
    						enc = bmgr.or(enc, conflict);
    					}
    				}
    			}
    		}
    	}
    	return enc;
    }
}
