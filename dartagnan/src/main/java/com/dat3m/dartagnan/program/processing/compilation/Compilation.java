package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.metadata.CompilationId;
import com.dat3m.dartagnan.program.processing.IdReassignment;
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
public class Compilation implements ProgramProcessor {


    private static final Logger logger = LogManager.getLogger(Compilation.class);

    // =========================== Configurables ===========================

    @Option(name = TARGET,
            description = "The target architecture to which the program shall be compiled to.",
            secure = true,
            toUppercase = true)
    private Arch target = Arch.C11;

    public Arch getTarget() { return target; }
    public void setTarget(Arch target) {
        this.target = target;
        compiler = getCompiler();
    }

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

    // =====================================================================

    private VisitorBase compiler;

    private Compilation() {
        compiler = getCompiler();
    }

    private Compilation(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
        Preconditions.checkNotNull(target);
        compiler = getCompiler();
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
        if (program.getFormat() == Program.SourceLanguage.SPV) {
            compiler = new VisitorSpirvVulkan();
        }

        program.getThreads().forEach(this::run);
        program.getFunctions().forEach(this::run);
        program.setArch(target);
        program.markAsCompiled();
        IdReassignment.newInstance().run(program); // Reassign ids

        logger.info("Program compiled to {}", target);
    }

    private void run(Function function) {
        if (function.hasBody()) {
            compiler.funcToBeCompiled = function;
            function.getEvents().forEach(e -> compileEvent(e, compiler));
        }
    }

    /*
        Returns the plain result of what an event would be compiled to.
        The following holds:
        (1) The original event is not affected. The result may be a singleton that contains exactly the original event.
        (2) The resultant events do not inherit any metadata, nor are they inserted anywhere.
        (3) CARE: The resultant events may reference events that the original referenced, i.e., they may be EventUsers.
            This means their existence can affect other events even if not inserted anywhere: the events have to get
            deleted properly!

     */
    // TODO: Refactoring. This shouldn't be used from outside,
    //  and the compiler should be resolved when program is passed
    public List<Event> getCompilationResult(Event toBeCompiled) {
        compiler.funcToBeCompiled = toBeCompiled.getFunction();
        return toBeCompiled.accept(compiler);
    }

    // -----------------------------------------------------------------------------

    private VisitorBase getCompiler() {
        return switch (target) {
            case C11 -> new VisitorC11();
            case LKMM -> new VisitorLKMM();
            case TSO -> new VisitorTso();
            case POWER -> new VisitorPower(useRC11Scheme, cToPowerScheme);
            case ARM8 -> new VisitorArm8(useRC11Scheme);
            case IMM -> new VisitorIMM();
            case RISCV -> new VisitorRISCV(useRC11Scheme);
            case PTX -> new VisitorPTX();
            case VULKAN -> new VisitorVulkan();
        };
    }

    private void compileEvent(Event toBeCompiled, VisitorBase compiler) {
        toBeCompiled.setMetadata(new CompilationId(toBeCompiled.getGlobalId()));
        final Event pred = toBeCompiled.getPredecessor();
        if (pred == null) {
            return; // We do not compile the entry event.
        }
        final List<Event> compiledEvents = toBeCompiled.accept(compiler);
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