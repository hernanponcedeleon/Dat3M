package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.configuration.Arch;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.List;

import static com.dat3m.dartagnan.configuration.OptionNames.TARGET;

@Options
public class Compilation implements ProgramProcessor {


    private static final Logger logger = LogManager.getLogger(Compilation.class);

    // =========================== Configurables ===========================

    @Option(name = TARGET,
            description = "The target architecture to which the program shall be compiled to.",
            secure = true,
            toUppercase = true)
    private Arch target = Arch.NONE;

    public Arch getTarget() { return target; }
    public void setTarget(Arch target) { this.target = target;}

    // =====================================================================

    private Compilation() { }

    private Compilation(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
    }

    public static Compilation fromConfig(Configuration config) throws InvalidConfigurationException {
        return new Compilation(config);
    }

    public static Compilation newInstance() {
        return new Compilation();
    }


    @Override
    public void run(Program program) {
        if (program.isCompiled()) {
            logger.warn("Skipped compilation: Program is already compiled to {}", program.getArch());
            return;
        }
        Preconditions.checkArgument(program.isUnrolled(), "The program needs to be unrolled before compilation.");

        int nextId = 0;
        for(Thread thread : program.getThreads()){
            nextId = compileThread(thread, nextId);

            int fId = 0;
            for (Event e : thread.getEvents()) {
                e.setFId(fId++);
            }
        }

        program.setArch(target);
        program.clearCache(false);
        program.markAsCompiled();
        logger.info("Program compiled to {}", target);
    }

    private int compileThread(Thread thread, int nextId) {
        Event pred = thread.getEntry();
        Event toBeCompiled = pred.getSuccessor();
        pred.setCId(nextId++);

        while (toBeCompiled != null) {
            List<Event> compiledEvents = toBeCompiled.compile(target);
            for (Event e : compiledEvents) {
                e.setOId(toBeCompiled.getOId());
                e.setUId(toBeCompiled.getUId());
                e.setCId(nextId++);
                e.setThread(thread);
                e.setCLine(toBeCompiled.getCLine());
                pred.setSuccessor(e);
                pred = e;
            }

            toBeCompiled = toBeCompiled.getSuccessor();
        }

        thread.updateExit(thread.getEntry());
        thread.clearCache();
        return nextId;
    }
}