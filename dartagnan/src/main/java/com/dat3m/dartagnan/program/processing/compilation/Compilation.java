package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.processing.ProgramProcessor;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.List;

import static com.dat3m.dartagnan.configuration.OptionNames.*;

@Options
public class Compilation implements ProgramProcessor {


    private static final Logger logger = LogManager.getLogger(Compilation.class);

    // =========================== Configurables ===========================

    @Option(name = TARGET,
            description = "The target architecture to which the program shall be compiled to.",
            secure = true,
            toUppercase = true)
    private Arch target = Arch.C11;

    public Arch getTarget() { return target; }
    public void setTarget(Arch target) { this.target = target;}

    @Option(name = PRINT_PROGRAM_AFTER_COMPILATION,
            description = "Prints the program after compilation.",
            secure = true)
    private boolean print = false;

    // =====================================================================

    private Compilation() { }

    private Compilation(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
        Preconditions.checkNotNull(target);
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

        EventVisitor<List<Event>> visitor;
        switch(target) {
        	case C11:
            	visitor = new VisitorC11(); break;
        	case LKMM:
        		visitor = new VisitorLKMM(); break;
            case TSO:
                visitor = new VisitorTso(); break;
            case POWER:
                visitor = new VisitorPower(); break;
            case ARM8:
                visitor = new VisitorArm8(); break;
            case IMM:
                visitor = new VisitorIMM(); break;
            default:
                throw new UnsupportedOperationException(String.format("Compilation to %s is not supported.", target));
        }

        int nextId = 0;
        for(Thread thread : program.getThreads()){
            nextId = compileThread(thread, nextId, visitor);

            int fId = 0;
            for (Event e : thread.getEvents()) {
                e.setFId(fId++);
            }
        }

        program.setArch(target);
        program.clearCache(false);
        program.markAsCompiled();
        logger.info("Program compiled to {}", target);
        if(print) {
        	System.out.println("===== Program after compilation =====");
        	System.out.println(new Printer().print(program));
        	System.out.println("=====================================");
        }
    }

    private int compileThread(Thread thread, int nextId, EventVisitor<List<Event>> visitor) {
    	Event pred = thread.getEntry();
        Event toBeCompiled = pred.getSuccessor();
        pred.setCId(nextId++);

        while (toBeCompiled != null) {
			List<Event> compiledEvents = toBeCompiled.accept(visitor);
            for (Event e : compiledEvents) {
                e.setOId(toBeCompiled.getOId());
                e.setUId(toBeCompiled.getUId());
                e.setCId(nextId++);
                e.setThread(thread);
                e.setCLine(toBeCompiled.getCLine());
                e.setSourceCodeFile(toBeCompiled.getSourceCodeFile());
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