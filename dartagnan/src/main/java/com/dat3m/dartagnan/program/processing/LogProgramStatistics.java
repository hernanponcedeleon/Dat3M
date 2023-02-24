package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class LogProgramStatistics implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(LogProgramStatistics.class);

    private LogProgramStatistics() { }

    public static LogProgramStatistics newInstance() { return new LogProgramStatistics(); }

    @Override
    public void run(Program program) {
        if (!logger.isInfoEnabled()) {
            return;
        }

        int totalEventCount = 0;
        int storeCount = 0;
        int loadCount = 0;
        int initCount = 0;
        int fenceCount = 0;
        for (Event e : program.getEvents()) {
            totalEventCount++;
            if (e instanceof Store) {
                storeCount++;
            } else if (e instanceof Load) {
                loadCount++;
            } else if (e instanceof Init) {
                initCount++;
            } else if (e instanceof Fence) {
                fenceCount++;
            }
        }

        int numNonInitThreads = (int)program.getThreads().stream().filter(t -> !(t.getEntry() instanceof Init)).count();
        if (program.getFormat() == Program.SourceLanguage.BOOGIE) {
            numNonInitThreads--; // We subtract 1, because for Boogie code we always create an extra empty thread
            // TODO: Why do we do this?
        }

        int addressSpaceSize = program.getMemory().getObjects().stream().mapToInt(MemoryObject::size).sum();

        StringBuilder output = new StringBuilder();
        output.append("\n======== Program statistics ========").append("\n");
        output.append("#Threads: ").append(numNonInitThreads).append("\n")
                .append("#Events: ").append(totalEventCount).append("\n")
                .append("\t#Stores: ").append(storeCount).append("\n")
                .append("\t#Loads: ").append(loadCount).append("\n")
                .append("\t#Fences: ").append(fenceCount).append("\n")
                .append("\t#Init: ").append(initCount).append("\n")
                .append("#Allocated bytes: ").append(addressSpaceSize).append("\n");
        output.append("========================================");
        logger.info(output);
    }
}
