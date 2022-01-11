package com.dat3m.dartagnan.exceptions;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.exception.*;
import com.dat3m.dartagnan.parsers.program.utils.*;
import com.dat3m.dartagnan.program.EventFactory;
import com.dat3m.dartagnan.program.EventFactory.*;
import com.dat3m.dartagnan.program.arch.linux.event.cond.RMWReadCond;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;

import static com.dat3m.dartagnan.program.EventFactory.newRMWStoreExclusive;

import org.junit.Test;

public class UnrollExceptionsTest {

	// These events cannot be unrolled. They are generated during compilation.
	
    @Test(expected = ProgramProcessingException.class)
    public void RMWStore() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Address address = pb.getOrCreateLocation("X").getAddress();
    	Load load = EventFactory.newRMWLoad(pb.getOrCreateRegister(0, "r1", 32), address, null);
		pb.addChild(0, EventFactory.newRMWStore(load, address, IConst.ONE, null));
    	LoopUnrolling processor = LoopUnrolling.newInstance();
    	processor.setUnrollingBound(2);
		processor.run(pb.build());
    }

    @Test(expected = ProgramProcessingException.class)
    public void RMWStoreCon() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Address address = pb.getOrCreateLocation("X").getAddress();
    	RMWReadCond load = Linux.newRMWReadCondCmp(pb.getOrCreateRegister(0, "r1", 32), BConst.TRUE, address, null);
		pb.addChild(0, Linux.newRMWStoreCond(load, address, IConst.ONE, null));
    	LoopUnrolling processor = LoopUnrolling.newInstance();
    	processor.setUnrollingBound(2);
		processor.run(pb.build());
    }

    @Test(expected = ProgramProcessingException.class)
    public void RMWStoreExclusive() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	pb.addChild(0, EventFactory.newRMWStoreExclusive(pb.getOrCreateLocation("X").getAddress(), IConst.ONE, null, true));
    	LoopUnrolling processor = LoopUnrolling.newInstance();
    	processor.setUnrollingBound(2);
		processor.run(pb.build());
    }

    @Test(expected = ProgramProcessingException.class)
    public void FenceCond() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Address address = pb.getOrCreateLocation("X").getAddress();
    	RMWReadCond load = Linux.newRMWReadCondCmp(pb.getOrCreateRegister(0, "r1", 32), BConst.TRUE, address, null);
		pb.addChild(0, Linux.newConditionalBarrier(load, null));
    	LoopUnrolling processor = LoopUnrolling.newInstance();
    	processor.setUnrollingBound(2);
		processor.run(pb.build());
    }

    @Test(expected = ProgramProcessingException.class)
    public void ExecutionStatus() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Address address = pb.getOrCreateLocation("X").getAddress();
        RMWStoreExclusive store = newRMWStoreExclusive(address, IConst.ONE, null);
		pb.addChild(0, EventFactory.newExecutionStatus(pb.getOrCreateRegister(0, "r1", 32), store));
    	LoopUnrolling processor = LoopUnrolling.newInstance();
    	processor.setUnrollingBound(2);
		processor.run(pb.build());
    }
}
