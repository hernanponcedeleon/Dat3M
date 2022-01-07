package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterMinus;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;

import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.wmm.utils.Utils.edge;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;

public class DataRaceEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(DataRaceEncoder.class);
    private VerificationTask task;

    private DataRaceEncoder() {
    }

    public static DataRaceEncoder fromConfig(Configuration config) throws InvalidConfigurationException {
        return new DataRaceEncoder();
    }

    @Override
    public void initializeEncoding(VerificationTask task, SolverContext context) {
    	this.task = task;
    }

    public BooleanFormula encodeDataRaces(SolverContext ctx) {
        Preconditions.checkState(task != null, "The encoder needs to get initialized.");
        logger.info("Encoding data-races");

        Program program = task.getProgram();
		AliasAnalysis alias = task.getAliasAnalysis();
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
    	IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
    	
		BooleanFormula enc = bmgr.makeFalse();
    	for(Thread t1 : program.getThreads()) {
    		for(Thread t2 : program.getThreads()) {
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
    					if(w.canRace() && m.canRace() && alias.mayAlias(w, m)) {
    						BooleanFormula conflict = bmgr.and(m.exec(), w.exec(), edge("hb", m, w, ctx),  
    								generalEqual(w.getMemAddressExpr(), m.getMemAddressExpr(), ctx), 
        							imgr.equal(intVar("hb", w, ctx), 
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