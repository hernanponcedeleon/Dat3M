package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.metadata.CompilationId;
import com.dat3m.dartagnan.program.processing.EventIdReassignment;
import com.dat3m.dartagnan.program.processing.FunctionProcessor;
import com.dat3m.dartagnan.program.processing.ProgramProcessor;
import com.dat3m.dartagnan.program.processing.compilation.VisitorPower.PowerScheme;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.List;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.program.processing.compilation.VisitorPower.PowerScheme.LEADING_SYNC;

@Options
public class Compilation implements ProgramProcessor, FunctionProcessor {


    private static final Logger logger = LogManager.getLogger(Compilation.class);

    // =========================== Configurables ===========================

    @Option(name = TARGET,
            description = "The target architecture to which the program shall be compiled to.",
            secure = true,
            toUppercase = true)
    private Arch target = Arch.C11;

    public Arch getTarget() { return target; }
    public void setTarget(Arch target) { this.target = target; }

    @Option(name = USE_RC11_TO_ARCH_SCHEME,
            description = "Use the RC11 to Arch (Power/ARMv8) compilation scheme to forbid out-of-thin-air behaviours.",
            secure = true,
            toUppercase = true)
    private boolean useRC11Scheme = false;

    @Option(name = C_TO_POWER_SCHEME,
            description = "Use the leading/trailing-sync compilation scheme from C to Power.",
            secure = true,
            toUppercase = true)
    private PowerScheme cToPowerScheme = LEADING_SYNC;

    @Option(name = THREAD_CREATE_ALWAYS_SUCCEEDS,
            description = "Calling pthread_create is guaranteed to succeed.",
            secure = true,
            toUppercase = true)
    private boolean forceStart = false;

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

        final VisitorBase visitor = getCompiler();
        program.getEvents().forEach(e -> e.setMetadata(new CompilationId(e.getGlobalId())));
        program.getThreads().forEach(thread -> this.compileFunction(thread, visitor));
        program.setArch(target);
        program.markAsCompiled();
        EventIdReassignment.newInstance().run(program); // Reassign ids

        logger.info("Program compiled to {}", target);
    }

    @Override
    public void run(Function function) {
        if (function.hasBody()) {
            compileFunction(function, getCompiler());
        }
    }

    private VisitorBase getCompiler() {
        return switch (target) {
            case C11 -> new VisitorC11(forceStart);
            case LKMM -> new VisitorLKMM(forceStart);
            case TSO -> new VisitorTso(forceStart);
            case POWER -> new VisitorPower(forceStart, useRC11Scheme, cToPowerScheme);
            case ARM8 -> new VisitorArm8(forceStart, useRC11Scheme);
            case IMM -> new VisitorIMM(forceStart);
            case RISCV -> new VisitorRISCV(forceStart, useRC11Scheme);
            case PTX -> new VisitorPTX(forceStart);
        };
    }

    private void compileFunction(Function func, VisitorBase visitor) {
        visitor.funcToBeCompiled = func;
        func.getEvents().forEach(e -> compileEvent(e, visitor));
    }

    private void compileEvent(Event toBeCompiled, VisitorBase visitor) {
        final Event pred = toBeCompiled.getPredecessor();
        if (pred == null) {
            return; // We do not compile the entry event.
        }
        final List<Event> compiledEvents = toBeCompiled.accept(visitor);
        if (compiledEvents.size() == 1 && compiledEvents.get(0) == toBeCompiled) {
            // In the special case where the compilation does nothing, we keep the event as is.
            return;
        }
        if (!toBeCompiled.tryDelete()) {
            final String error = String.format("Could not compile event '%d:  %s' because it is not deletable." +
                    "The event is likely referenced by other events.", toBeCompiled.getGlobalId(), toBeCompiled);
            throw new IllegalStateException(error);
        }
        if (!compiledEvents.isEmpty()) {
            // Insert result of compilation
            compiledEvents.forEach(e -> e.copyAllMetadataFrom(toBeCompiled));
            pred.insertAfter(compiledEvents);
        }
    }
}