package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.lang.svcomp.LoopEnd;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.*;

@Options
public class FindSpinLoops implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(FindSpinLoops.class);
    
    private int spinloops = 0;

    // =========================== Configurables ===========================

    // =====================================================================

    private FindSpinLoops() { }

    private FindSpinLoops(Configuration config) throws InvalidConfigurationException {
        this();
        config.inject(this);
    }

    public static FindSpinLoops fromConfig(Configuration config) throws InvalidConfigurationException {
        return new FindSpinLoops(config);
    }

    public static FindSpinLoops newInstance() {
        return new FindSpinLoops();
    }


    @Override
    public void run(Program program) {
        Preconditions.checkArgument(!program.isUnrolled(), getClass().getSimpleName() + " should be performed before unrolling.");
        for(Thread thread : program.getThreads()){
            markSpinLoops(thread);
        }
        program.clearCache(false);

        logger.info("# of spinloops: {}", spinloops);
}

    private void markSpinLoops(Thread t){
    	Event pred = t.getEntry();
        Event curr = pred.getSuccessor();
        while (curr != null) {
        	if(curr instanceof LoopEnd) {
        		// This assume the following implementation of await_while
        		// #define await_while(cond)                                                  \
        	    // for (int tmp = (__VERIFIER_loop_begin(), 0); __VERIFIER_spin_start(),  \
        	    //     tmp = cond, __VERIFIER_spin_end(!tmp), tmp;)
        		Event spinloop = curr.getSuccessors().stream().filter(e -> e instanceof CondJump && ((CondJump)e).isGoto()).findFirst().get();
        		spinloop.addFilters(Tag.SPINLOOP);
        		spinloops++;
        	}
            curr = curr.getSuccessor();
        }

        t.clearCache();
        return;
    }
}