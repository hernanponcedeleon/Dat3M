package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Alloc;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.List;
import java.util.stream.Stream;

/*
    This pass
        (1) collects all Alloc events in the program and generates a corresponding MemoryObject
        (2) for all MemoryObjects, it generates corresponding Init events if they are required
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
        createInitEvents(program);
    }

    private void processAllocations(Program program) {
        final ExpressionFactory expressions = ExpressionFactory.getInstance();
        // FIXME: We should probably initialize depending on the allocation type of the alloc
        final Expression zero = expressions.makeZero(TypeFactory.getInstance().getByteType());
        for (Alloc alloc : program.getThreadEvents(Alloc.class)) {
            final MemoryObject allocatedObject = program.getMemory().allocate(alloc);
            alloc.setAllocatedObject(allocatedObject);

            if (alloc.doesZeroOutMemory() || createInitsForDynamicAllocations) {
                for (int i = 0; i < allocatedObject.size(); i++) {
                    allocatedObject.setInitialValue(i, zero);
                }
            }
        }
    }

    private void createInitEvents(Program program) {
        final TypeFactory types = TypeFactory.getInstance();
        final FunctionType initThreadType = types.getFunctionType(types.getVoidType(), List.of());
        final List<String> paramNames = List.of();

        int nextThreadId = Stream.concat(program.getThreads().stream(), program.getFunctions().stream())
                .mapToInt(Function::getId).max().getAsInt() + 1;
        for(MemoryObject memObj : program.getMemory().getObjects()) {
            for(int field : memObj.getInitializedFields()) {
                // NOTE: We use different names to avoid symmetry detection treating all inits as symmetric.
                final String threadName = "Init_" + nextThreadId;
                final Thread thread = new Thread(threadName, initThreadType, paramNames, nextThreadId,
                        EventFactory.newThreadStart(null));
                thread.append(EventFactory.newInit(memObj, field));
                thread.append(EventFactory.newLabel("END_OF_T" + thread.getId()));
                program.addThread(thread);
                nextThreadId++;
            }
        }
    }
}
