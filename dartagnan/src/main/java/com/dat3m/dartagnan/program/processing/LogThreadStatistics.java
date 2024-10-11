package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;

public class LogThreadStatistics implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(LogThreadStatistics.class);

    private LogThreadStatistics() { }

    public static LogThreadStatistics newInstance() { return new LogThreadStatistics(); }

    @Override
    public void run(Program program) {
        if (!logger.isInfoEnabled()) {
            return;
        }
        final List<Thread> threads = program.getThreads();

        int totalEventCount = 0;
        int storeCount = 0;
        int loadCount = 0;
        int initCount = 0;
        int otherVisibleCount = 0;
        int annotationCount = 0;
        for (Thread thread : threads) {
            for (Event e : thread.getEvents()) {
                totalEventCount++;
                if (e instanceof Init) {
                    initCount++;
                } else if (e instanceof Store) {
                    storeCount++;
                } else if (e instanceof Load) {
                    loadCount++;
                } else if (e instanceof GenericVisibleEvent) {
                    otherVisibleCount++;
                } else if (e instanceof CodeAnnotation) {
                    annotationCount++;
                }
            }
        }

        int numNonInitThreads = (int)threads.stream().filter(t -> !(t.getEntry().getSuccessor() instanceof Init)).count();
        int staticAddressSpaceSize = program.getMemory().getObjects().stream()
                .filter(m -> m.isStaticallyAllocated() && m.hasKnownSize()).mapToInt(MemoryObject::getKnownSize).sum();
        int dynamicAddressSpaceSize = program.getMemory().getObjects().stream()
                .filter(m -> m.isDynamicallyAllocated() && m.hasKnownSize()).mapToInt(MemoryObject::getKnownSize).sum();
        int totalAddressSpaceSize = dynamicAddressSpaceSize + staticAddressSpaceSize;
        int numUnknownSizedAllocations = Math.toIntExact(program.getMemory().getObjects().stream()
                .filter(m -> !m.hasKnownSize()).count());

        StringBuilder output = new StringBuilder();
        output.append("\n======== Program statistics ========").append("\n");
        output.append("#Threads: ").append(numNonInitThreads).append("\n")
                .append("#Events: ").append(totalEventCount).append("\n")
                .append("\t#Annotations: ").append(annotationCount).append("\n")
                .append("\t#Stores: ").append(storeCount).append("\n")
                .append("\t#Loads: ").append(loadCount).append("\n")
                .append("\t#Inits: ").append(initCount).append("\n")
                .append("\t#Others: ").append(otherVisibleCount).append("\n")
                .append("#Allocated bytes: ").append(totalAddressSpaceSize).append("\n")
                .append("\tStatically allocated: ").append(staticAddressSpaceSize).append("\n")
                .append("\tDynamically allocated: ").append(dynamicAddressSpaceSize).append("\n")
                .append("\t#Unknown allocations: ").append(numUnknownSizedAllocations).append("\n");
        output.append("========================================");
        logger.info(output);
    }
}
