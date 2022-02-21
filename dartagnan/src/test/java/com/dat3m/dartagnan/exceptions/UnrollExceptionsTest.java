package com.dat3m.dartagnan.exceptions;

import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.EventFactory.Linux;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.lang.linux.cond.RMWReadCond;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import org.junit.Test;

import static com.dat3m.dartagnan.program.event.EventFactory.newRMWStoreExclusive;

public class UnrollExceptionsTest {

	// These events cannot be unrolled. They are generated during compilation.
	
    @Test(expected = ProgramProcessingException.class)
    public void RMWStore() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
        MemoryObject object = pb.getOrNewObject("X");
        Load load = EventFactory.newRMWLoad(pb.getOrCreateRegister(0, "r1", 32), object, null);
        pb.addChild(0, EventFactory.newRMWStore(load, object, IValue.ONE, null));
    	LoopUnrolling processor = LoopUnrolling.newInstance();
    	processor.setUnrollingBound(2);
		processor.run(pb.build());
    }

    @Test(expected = ProgramProcessingException.class)
    public void RMWStoreCon() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
        MemoryObject object = pb.getOrNewObject("X");
        RMWReadCond load = Linux.newRMWReadCondCmp(pb.getOrCreateRegister(0, "r1", 32), BConst.TRUE, object, null);
        pb.addChild(0, Linux.newRMWStoreCond(load, object, IValue.ONE, null));
    	LoopUnrolling processor = LoopUnrolling.newInstance();
    	processor.setUnrollingBound(2);
		processor.run(pb.build());
    }

    @Test(expected = ProgramProcessingException.class)
    public void RMWStoreExclusive() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	pb.addChild(0, EventFactory.newRMWStoreExclusive(pb.getOrNewObject("X"), IValue.ONE, null, true));
    	LoopUnrolling processor = LoopUnrolling.newInstance();
    	processor.setUnrollingBound(2);
		processor.run(pb.build());
    }

    @Test(expected = ProgramProcessingException.class)
    public void FenceCond() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
        MemoryObject object = pb.getOrNewObject("X");
        RMWReadCond load = Linux.newRMWReadCondCmp(pb.getOrCreateRegister(0, "r1", 32), BConst.TRUE, object, null);
		pb.addChild(0, Linux.newConditionalBarrier(load, null));
    	LoopUnrolling processor = LoopUnrolling.newInstance();
    	processor.setUnrollingBound(2);
		processor.run(pb.build());
    }

    @Test(expected = ProgramProcessingException.class)
    public void ExecutionStatus() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
        MemoryObject object = pb.getOrNewObject("X");
        RMWStoreExclusive store = newRMWStoreExclusive(object, IValue.ONE, null);
		pb.addChild(0, EventFactory.newExecutionStatus(pb.getOrCreateRegister(0, "r1", 32), store));
    	LoopUnrolling processor = LoopUnrolling.newInstance();
    	processor.setUnrollingBound(2);
		processor.run(pb.build());
    }
}
