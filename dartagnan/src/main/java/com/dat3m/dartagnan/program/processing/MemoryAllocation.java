package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.lang.Alloc;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.math.BigInteger;
import java.util.List;
import java.util.stream.IntStream;
import java.util.stream.Stream;

/*
    This pass collects all Malloc events in the program and for each of them it:
        (1) allocates a MemoryObject of appropriate size
        (2) creates Init events that initialize the allocated memory
            (TODO: If possible, only allocate subset of relevant init events)
        (3) replaces the Malloc event with a local register assignment, assigning the newly created MemoryObject
 */
@Options
public class MemoryAllocation implements ProgramProcessor {

    // =========================== Configurables ===========================

    @Option(name = OptionNames.INIT_DYNAMIC_ALLOCATIONS,
            description = "Creates init events for all dynamic allocations. Those init events zero out the memory.",
            secure = true)
    private boolean createInitsForDynamicAllocations = false;

    // ======================================================================


    private MemoryAllocation() {
    }

    public static MemoryAllocation newInstance() {
        return new MemoryAllocation();
    }

    public static MemoryAllocation fromConfig(Configuration config) throws InvalidConfigurationException {
        final MemoryAllocation memAlloc = new MemoryAllocation();
        config.inject(memAlloc);
        return memAlloc;
    }

    @Override
    public void run(Program program) {
        processAllocations(program);
        moveAndAlignMemoryObjects(program.getMemory());
        createInitEvents(program);
    }

    private void processAllocations(Program program) {
        final ExpressionFactory expressions = ExpressionFactory.getInstance();
        // FIXME: We should probably initialize depending on the allocation type of the alloc
        final Expression zero = expressions.makeZero(TypeFactory.getInstance().getByteType());
        for (Alloc alloc : program.getThreadEvents(Alloc.class)) {
            final int size = getSize(alloc);
            final MemoryObject allocatedObject = program.getMemory().allocate(size, false);
            final Local local = EventFactory.newLocal(alloc.getResultRegister(), allocatedObject);
            local.addTags(Tag.Std.MALLOC);
            local.copyAllMetadataFrom(alloc);
            alloc.replaceBy(local);

            if (alloc.doesZeroOutMemory() || createInitsForDynamicAllocations) {
                for (int i = 0; i < size; i++) {
                    allocatedObject.setInitialValue(i, zero);
                }
            }
        }
    }

    private int getSize(Alloc alloc) {
        try {
            return ((IntLiteral)alloc.getAllocationSize()).getValueAsInt();
        } catch (Exception e) {
            final String error = String.format("Variable-sized alloc '%s' is not supported", alloc);
            throw new MalformedProgramException(error);
        }
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
        final TypeFactory types = TypeFactory.getInstance();
        final FunctionType initThreadType = types.getFunctionType(types.getVoidType(), List.of());

        int nextThreadId = Stream.concat(program.getThreads().stream(), program.getFunctions().stream())
                .mapToInt(Function::getId).max().getAsInt() + 1;
        for(MemoryObject memObj : program.getMemory().getObjects()) {
            final Iterable<Integer> fieldsToInit;
            if (isLitmus) {
                fieldsToInit = IntStream.range(0, memObj.size()).boxed()::iterator;
            } else {
                fieldsToInit = memObj.getInitializedFields();
            }

            for(int i : fieldsToInit) {
                final Event init = EventFactory.newInit(memObj, i);
                // NOTE: We use different names to avoid symmetry detection treating all inits as symmetric.
                final Thread thread = new Thread("Init_" + nextThreadId, initThreadType, List.of(), nextThreadId,
                        EventFactory.newThreadStart(null));
                thread.append(init);
                nextThreadId++;

                program.addThread(thread);
                thread.setProgram(program);
                thread.append(EventFactory.newLabel("END_OF_T" + thread.getId()));
            }
        }
    }
}
