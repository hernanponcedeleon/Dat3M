package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.MemAlloc;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

/*
    This pass
        (1) collects all MemAlloc events in the program and generates a corresponding MemoryObject
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
        for (MemAlloc alloc : program.getThreadEvents(MemAlloc.class)) {
            final MemoryObject allocatedObject = program.getMemory().allocate(alloc);
            alloc.setAllocatedObject(allocatedObject);

            if (alloc.doesZeroOutMemory() || createInitsForDynamicAllocations) {
                Preconditions.checkState(allocatedObject.hasKnownSize(), "Cannot initialize dynamic allocation of unknown size.");
                for (int i = 0; i < allocatedObject.getKnownSize(); i++) {
                    allocatedObject.setInitialValue(i, zero);
                }
            }
        }
    }

    private void createInitEvents(Program program) {
        for(MemoryObject memObj : program.getMemory().getObjects()) {
            for(int field : memObj.getInitializedFields()) {
                program.addInit(memObj, field);
            }
        }
    }
}
