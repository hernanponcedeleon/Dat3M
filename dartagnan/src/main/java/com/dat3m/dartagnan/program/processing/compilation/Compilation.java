package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.lang.pthread.Lock;
import com.dat3m.dartagnan.program.event.lang.pthread.Unlock;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.processing.ProgramProcessor;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.List;

import static com.dat3m.dartagnan.configuration.OptionNames.TARGET;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;
import static com.dat3m.dartagnan.program.event.EventFactory.newJump;
import static com.dat3m.dartagnan.program.event.EventFactory.newLoad;
import static com.dat3m.dartagnan.program.event.EventFactory.newStore;
import static com.dat3m.dartagnan.program.event.Tag.RMW;

@Options
public class Compilation implements ProgramProcessor {


    private static final Logger logger = LogManager.getLogger(Compilation.class);

    // =========================== Configurables ===========================

    @Option(name = TARGET,
            description = "The target architecture to which the program shall be compiled to.",
            secure = true,
            toUppercase = true)
    private Arch target = Arch.NONE;

    public Arch getTarget() { return target; }
    public void setTarget(Arch target) { this.target = target;}

    // =====================================================================

    private Compilation() { }

    private Compilation(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
    }

    public static Compilation fromConfig(Configuration config) throws InvalidConfigurationException {
        return new Compilation(config);
    }

    public static Compilation newInstance() {
        return new Compilation();
    }


    @Override
    public void run(Program program) {
        if (program.isCompiled()) {
            logger.warn("Skipped compilation: Program is already compiled to {}", program.getArch());
            return;
        }
        Preconditions.checkArgument(program.isUnrolled(), "The program needs to be unrolled before compilation.");

        int nextId = 0;
        for(Thread thread : program.getThreads()){
            nextId = compileThread(thread, nextId);

            int fId = 0;
            for (Event e : thread.getEvents()) {
                e.setFId(fId++);
            }
        }

        program.setArch(target);
        program.clearCache(false);
        program.markAsCompiled();
        logger.info("Program compiled to {}", target);
    }

    private int compileThread(Thread thread, int nextId) {
        EventVisitor<List<Event>> visitor = null;
        switch(target) {
	    	case NONE:
	    		visitor = new VisitorNone();
	    		break;
	    	case TSO:
	    		visitor = new VisitorTso();
	    		break;
	    	case POWER:
	    		visitor = new VisitorPower();
	    		break;
	    	case ARM8:
	    		visitor = new VisitorArm8();
	    		break;
	    	default:
	    		throw new UnsupportedOperationException("Compilation to %s is not supported.");
        }

    	Event pred = thread.getEntry();
        Event toBeCompiled = pred.getSuccessor();
        pred.setCId(nextId++);

        while (toBeCompiled != null) {
			List<Event> compiledEvents = toBeCompiled.accept(visitor);
            for (Event e : compiledEvents) {
                e.setOId(toBeCompiled.getOId());
                e.setUId(toBeCompiled.getUId());
                e.setCId(nextId++);
                e.setThread(thread);
                e.setCLine(toBeCompiled.getCLine());
                pred.setSuccessor(e);
                pred = e;
            }

            toBeCompiled = toBeCompiled.getSuccessor();
        }

        thread.updateExit(thread.getEntry());
        thread.clearCache();
        return nextId;
    }

    // =============================================================================================
    // =========================================== Common ==========================================
    // =============================================================================================

    public static List<Event> commonVisitLock(Lock e) {
        Register resultRegister = e.getResultRegister();
		String mo = e.getMo();
		
		List<Event> events = eventSequence(
                newLoad(resultRegister, e.getAddress(), mo),
                newJump(new Atom(resultRegister, NEQ, IConst.ZERO), e.getLabel()),
                newStore(e.getAddress(), IConst.ONE, mo)
        );
        
		for(Event child : events) {
            child.addFilters(C11.LOCK, RMW);
        }
        
		return events;
    }
    
	public static List<Event> commonVisitUnlock(Unlock e) {
        Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
		List<Event> events = eventSequence(
                newLoad(resultRegister, address, mo),
                newJump(new Atom(resultRegister, NEQ, IConst.ONE), e.getLabel()),
                newStore(address, IConst.ZERO, mo)
        );
        
		for(Event child : events) {
            child.addFilters(C11.LOCK, RMW);
        }
        
		return events;
	}
}