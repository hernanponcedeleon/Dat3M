package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.HashSet;
import java.util.Set;

public class AtomicityPropagation implements ProgramProcessor {
	
    private AtomicityPropagation() { }

    public static AtomicityPropagation fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    public static AtomicityPropagation newInstance() {
        return new AtomicityPropagation();
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(program.isUnrolled(), "The program needs to be unrolled before atomicity propagation.");
        Preconditions.checkArgument(!program.isCompiled(), "Atomicity propagation needs to be run before compilation.");
        for(Thread thread : program.getThreads()) {
            run(thread);
        }
    }

	private void run(Thread thread) {
		
	    Set<IExpr> atomics = new HashSet<>();
	    atomics.addAll(thread.getProgram().getMemory().getObjects());
	    
        Event current = thread.getEntry();
        while (current != null) {
        	if(current instanceof Local) {
        		Local l = (Local)current;
        		if(atomics.contains(l.getExpr()) || 
        				l.getExpr() instanceof MemoryObject && ((MemoryObject)l.getExpr()).isAtomic()) {
        			atomics.add(l.getResultRegister());
        		}
        	}
            current.accept(new AtomicityPropagationVisitor(atomics));
            current = current.getSuccessor();
        }
        thread.updateExit(thread.getEntry());
        thread.clearCache();
	}

    private class AtomicityPropagationVisitor implements EventVisitor<Event> {

    	private final Set<IExpr> atomics;
    	
    	protected AtomicityPropagationVisitor(Set<IExpr> atomics) {
    		this.atomics = atomics;
    	}
    	
    	@Override
    	public Event visitEvent(Event e) {
    		return e;
    	};
    	
    	@Override
    	public Event visitMemEvent(MemEvent e) {
    		if(atomics.contains(e.getAddress())) {
    			e.addFilters(Tag.C11.ATOMIC);
    			// Accesses to an atomic object without a concrete mo are considered SC
    			if(e.canRace()) {
    				e.setMo(Tag.C11.MO_SC);
    			}
    		}
    		return e;
    	};
    }

}