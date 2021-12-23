package com.dat3m.dartagnan.exceptions;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.parsers.program.exception.*;
import com.dat3m.dartagnan.parsers.program.utils.*;
import com.dat3m.dartagnan.program.EventFactory;
import com.dat3m.dartagnan.program.EventFactory.*;
import com.dat3m.dartagnan.program.arch.linux.event.cond.RMWReadCond;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.memory.Address;

import static com.dat3m.dartagnan.program.EventFactory.newRMWStoreExclusive;

import org.junit.Test;

public class UnrollExceptionsTest {

    @Test(expected = UnrollException.class)
    public void RMWStore() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Address address = pb.getOrCreateLocation("X", 32).getAddress();
    	Load load = EventFactory.newRMWLoad(pb.getOrCreateRegister(0, "r1", 32), address, null);
		pb.addChild(0, EventFactory.newRMWStore(load, address, IConst.ONE, null));
    	pb.build().unroll(1, 0);
    }

    @Test(expected = UnrollException.class)
    public void RMWStoreCon() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Address address = pb.getOrCreateLocation("X", 32).getAddress();
    	RMWReadCond load = Linux.newRMWReadCondCmp(pb.getOrCreateRegister(0, "r1", 32), BConst.TRUE, address, null);
		pb.addChild(0, Linux.newRMWStoreCond(load, address, IConst.ONE, null));
    	pb.build().unroll(1, 0);
    }

    @Test(expected = UnrollException.class)
    public void RMWStoreExclusive() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	pb.addChild(0, EventFactory.newRMWStoreExclusive(pb.getOrCreateLocation("X", 32).getAddress(), IConst.ONE, null, true));
    	pb.build().unroll(1, 0);
    }

    @Test(expected = UnrollException.class)
    public void FenceCond() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Address address = pb.getOrCreateLocation("X", 32).getAddress();
    	RMWReadCond load = Linux.newRMWReadCondCmp(pb.getOrCreateRegister(0, "r1", 32), BConst.TRUE, address, null);
		pb.addChild(0, Linux.newConditionalBarrier(load, null));
    	pb.build().unroll(1, 0);
    }

    @Test(expected = UnrollException.class)
    public void ExecutionStatus() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Address address = pb.getOrCreateLocation("X", 32).getAddress();
        RMWStoreExclusive store = newRMWStoreExclusive(address, IConst.ONE, null);
		pb.addChild(0, EventFactory.newExecutionStatus(pb.getOrCreateRegister(0, "r1", 32), store));
    	pb.build().unroll(1, 0);
    }
}
