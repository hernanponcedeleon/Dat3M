package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.Set;
import java.util.stream.Collectors;

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

        Set<IExpr> atomics = program.getMemory().getObjects().stream().filter(o -> o.isAtomic()).collect(Collectors.toSet());
        for(Thread thread : program.getThreads()) {
			run(thread, atomics);
        }
    }

	private void run(Thread thread, Set<IExpr> atomics) {
        AtomicityPropagationVisitor visitor = new AtomicityPropagationVisitor(atomics);		
	    Event current = thread.getEntry();
        while (current != null) {
        	if(current instanceof Local) {
        		Local l = (Local)current;
        		if(atomics.contains(l.getExpr())) {
        			atomics.add(l.getResultRegister());
        		}
        	}
			current.accept(visitor);
            current = current.getSuccessor();
        }
        thread.updateExit(thread.getEntry());
        thread.clearCache();
	}

    private class AtomicityPropagationVisitor implements EventVisitor<Void> {

    	private final Set<IExpr> atomics;
    	
    	protected AtomicityPropagationVisitor(Set<IExpr> atomics) {
    		this.atomics = atomics;
    	}
    	
    	@Override
    	public Void visitEvent(Event e) {
    		return null;
    	};
    	
    	@Override
    	public Void visitMemEvent(MemEvent e) {
			// Accesses to an atomic object without a concrete mo are considered SC
    		if(atomics.contains(e.getAddress()) && e.canRace()) {
    			e.setMo(Tag.C11.MO_SC);
    			e.addFilters(Tag.C11.ATOMIC);
    		}
    		return null;
    	};
    }

}