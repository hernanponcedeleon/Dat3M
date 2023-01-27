package com.dat3m.dartagnan.exceptions;

import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import org.junit.Test;

import static com.dat3m.dartagnan.program.event.EventFactory.newRMWStoreExclusive;

public class UnrollExceptionsTest {

	// These events cannot be unrolled. They are generated during compilation.
	
    @Test(expected = ProgramProcessingException.class)
    public void RMWStore() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
    	pb.initThread(0);
        MemoryObject object = pb.getOrNewObject("X");
		Label start = pb.getOrCreateLabel("loopStart");
		pb.addChild(0, start);
        Load load = EventFactory.newRMWLoad(pb.getOrCreateRegister(0, "r1", 32), object, "");
        pb.addChild(0, EventFactory.newRMWStore(load, object, IValue.ONE, ""));
		pb.addChild(0, EventFactory.newGoto(start));
    	LoopUnrolling processor = LoopUnrolling.newInstance();
    	processor.setUnrollingBound(2);
		processor.run(pb.build());
    }

    @Test(expected = ProgramProcessingException.class)
    public void RMWStoreExclusive() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
    	pb.initThread(0);
		Label start = pb.getOrCreateLabel("loopStart");
		pb.addChild(0, start);
    	pb.addChild(0, newRMWStoreExclusive(pb.getOrNewObject("X"), IValue.ONE, "", true));
		pb.addChild(0, EventFactory.newGoto(start));
    	LoopUnrolling processor = LoopUnrolling.newInstance();
    	processor.setUnrollingBound(2);
		processor.run(pb.build());
    }

    @Test(expected = ProgramProcessingException.class)
    public void ExecutionStatus() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
    	pb.initThread(0);
		Label start = pb.getOrCreateLabel("loopStart");
		pb.addChild(0, start);
        MemoryObject object = pb.getOrNewObject("X");
        RMWStoreExclusive store = newRMWStoreExclusive(object, IValue.ONE, "");
		pb.addChild(0, EventFactory.newExecutionStatus(pb.getOrCreateRegister(0, "r1", 32), store));
		pb.addChild(0, EventFactory.newGoto(start));
    	LoopUnrolling processor = LoopUnrolling.newInstance();
    	processor.setUnrollingBound(2);
		processor.run(pb.build());
    }
}
