package com.dat3m.dartagnan.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterMinus;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.math.BigInteger;

import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.wmm.utils.Utils.edge;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;

public class DataRaces {
	
	// This analysis assumes that CAT file defining the memory model has a happens-before 
	// relation named hb: it should contain the following axiom "acyclic hb"

    private static final Logger logger = LogManager.getLogger(DataRaces.class);

	public static Result checkForRaces(SolverContext ctx, VerificationTask task) {

		task.preProcessProgram();
		task.initialiseEncoding(ctx);
		
		try (ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS)) {
			prover.addConstraint(task.encodeProgram(ctx));
			prover.addConstraint(task.encodeWmmRelations(ctx));
	        prover.addConstraint(task.encodeWmmConsistency(ctx));
	        prover.push();
	        prover.addConstraint(encodeRaces(task.getProgram(), ctx));
	        
			BooleanFormula noBoundEventExec = task.getProgramEncoder().encodeNoBoundEventExec(ctx);
			
			if(prover.isUnsat()) {
	        	prover.pop();
				prover.addConstraint(noBoundEventExec);
	        	return prover.isUnsat() ? PASS : UNKNOWN;
	        } else {
	        	prover.addConstraint(noBoundEventExec);
				return prover.isUnsat() ? UNKNOWN : FAIL;
	        }
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return UNKNOWN;
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