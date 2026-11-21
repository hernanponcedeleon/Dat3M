package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.processing.IdReassignment;
import com.dat3m.dartagnan.program.processing.ProgramProcessor;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.List;

public class Compilation implements ProgramProcessor {

    private static final Logger logger = LoggerFactory.getLogger(Compilation.class);

    private final Compiler compiler;

    private Compilation(Compiler compiler) {
        this.compiler = compiler;
    }

    public static Compilation fromConfig(Configuration config) throws InvalidConfigurationException {
        return new Compilation(Compiler.fromConfig(config));
    }

    public static Compilation newInstance() {
        return new Compilation(Compiler.newInstance());
    }

    @Override
    public void run(Program program) {
        if (program.isCompiled()) {
            logger.warn("Skipped compilation: Program is already compiled to {}", program.getArch());
            return;
        }
        final Arch target = compiler.getTarget();
        program.getThreads().forEach(this::run);
        program.getFunctions().forEach(this::run);
        program.setArch(target);
        program.setTargetLowering(new CompilerBasedLowering(compiler));
        program.markAsCompiled();
        IdReassignment.newInstance().run(program); // Reassign ids

        logger.info("Program compiled to {}", target);
    }

    private void run(Function function) {
        if (function.hasBody()) {
            function.getEvents().forEach(e -> compileEvent(e, function));
        }
    }

    // -----------------------------------------------------------------------------

    private void compileEvent(Event toBeCompiled, Function function) {
        toBeCompiled.setMetadata(new Event.CompilationId(toBeCompiled.getGlobalId()));
        final Event pred = toBeCompiled.getPredecessor();
        if (pred == null) {
            return; // We do not compile the entry event.
        }
        final List<Event> compiledEvents = compiler.compile(toBeCompiled, function);
        if (compiledEvents.size() == 1 && compiledEvents.getFirst() == toBeCompiled) {
            // In the special case where the compilation does nothing, we keep the event as is.
            return;
        }
        if (!toBeCompiled.getUsers().isEmpty()) {
            final String error = String.format("Could not compile event '%d:  %s' because it is referenced by other events.",
                    toBeCompiled.getGlobalId(), toBeCompiled);
            throw new IllegalStateException(error);
        }

        toBeCompiled.removeMetadata(Event.CustomPrinting.class);
        IRHelper.replaceWithMetadata(toBeCompiled, compiledEvents);
    }
}