package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.program.expression.Literal;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.lang.std.Malloc;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.math.BigInteger;
import java.util.stream.IntStream;

import static com.google.common.base.Preconditions.checkArgument;

/*
    This pass collects all Malloc events in the program and for each of them it:
        (1) allocates a MemoryObject of appropriate size
        (2) creates Init events that initialize the allocated memory
            (TODO: If possible, only allocate subset of relevant init events)
        (3) replaces the Malloc event with a local register assignment, assigning the newly created MemoryObject
 */
public class MemoryAllocation implements ProgramProcessor {

    private MemoryAllocation() { }

    public static MemoryAllocation newInstance() { return new MemoryAllocation(); }

    @Override
    public void run(Program program) {
        processMallocs(program);
        moveAndAlignMemoryObjects(program.getMemory());
        createInitEvents(program);
    }

    private void processMallocs(Program program) {
        for (Malloc malloc : program.getEvents(Malloc.class)) {
            final MemoryObject allocatedObject = program.getMemory().allocate(getSize(malloc), false);
            final Local local = EventFactory.newLocal(malloc.getResultRegister(), allocatedObject);
            local.addFilters(Tag.Std.MALLOC);
            local.copyMetadataFrom(malloc);
            malloc.replaceBy(local);
        }
    }

    private int getSize(Malloc malloc) {
        if (!(malloc.getSizeExpr() instanceof Literal)) {
            throw new MalformedProgramException("Variable-sized malloc '" + malloc + "' is not supported");
        }
        return ((Literal) malloc.getSizeExpr()).getValueAsInt();
    }

    public void moveAndAlignMemoryObjects(Memory memory) {
        // Addresses are typically at least two byte aligned
        //      https://stackoverflow.com/questions/23315939/why-2-lsbs-of-32-bit-arm-instruction-address-not-used
        // Many algorithms rely on this assumption for correctness.
        // Many objects have even stricter alignment requirements and need up to 8-byte alignment.
        final BigInteger alignment = BigInteger.valueOf(8);
        BigInteger nextAddr = alignment;
        for(MemoryObject memObj : memory.getObjects()) {
            memObj.setAddress(nextAddr);

            // Compute next aligned address as follows:
            //  nextAddr = curAddr + size + padding = k*alignment   // Alignment requirement
            //  => padding = k*alignment - curAddr - size
            //  => padding mod alignment = (-size) mod alignment    // k*alignment and curAddr are 0 mod alignment.
            //  => padding = (-size) mod alignment                  // Because padding < alignment
            final BigInteger memObjSize = BigInteger.valueOf(memObj.size());
            final BigInteger padding = memObjSize.negate().mod(alignment);
            nextAddr = nextAddr.add(memObjSize).add(padding);
        }
    }

    private void createInitEvents(Program program) {
        final boolean isLitmus = program.getFormat() == Program.SourceLanguage.LITMUS;
        ExpressionFactory expressionFactory = ExpressionFactory.getInstance();

        for(MemoryObject memObj : program.getMemory().getObjects()) {
            // The last case "heuristically checks" if Smack generated initialization or not:
            // we expect at least every 8 bytes to be initialized.
            final boolean isStaticallyInitialized = !isLitmus
                    && memObj.isStaticallyAllocated()
                    && (memObj.getStaticallyInitializedFields().size() >= memObj.size() / 8);
            final Iterable<Integer> fieldsToInit = isStaticallyInitialized ?
                    memObj.getStaticallyInitializedFields() : IntStream.range(0, memObj.size()).boxed()::iterator;

            for(int i : fieldsToInit) {
                Literal offset = expressionFactory.makeValue(BigInteger.valueOf(i), memObj.getType());
                Event init = new Init(memObj, i, expressionFactory.makeBinary(memObj, IOpBin.PLUS, offset));
                final Thread thread = program.newThread(".INIT." + memObj + "." + i, init);
                thread.append(EventFactory.newLabel(thread.getEndLabelName()));
            }
        }
    }
}
