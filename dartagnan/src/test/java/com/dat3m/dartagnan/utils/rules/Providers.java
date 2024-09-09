package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.ProverWithTracker;

import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.SolverContext;

import java.io.File;
import java.util.EnumSet;
import java.util.function.Supplier;

import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;


/*
    This is a helper class that provides construction methods for
    commonly used Providers.
 */
public class Providers {

    private Providers() {
    }

    // =========================== Wmm providers ==============================

    public static Provider<Wmm> createWmmFromArch(Supplier<Arch> archSupplier) {
        return WmmFromArchitectureProvider.create(archSupplier);
    }

    public static Provider<Wmm> createWmmFromFile(Supplier<File> fileSupplier) {
        return Provider.fromSupplier(() -> new ParserCat().parse(fileSupplier.get()));
    }

    public static Provider<Wmm> createWmmFromPath(Supplier<String> pathSupplier) {
        return createWmmFromFile(() -> new File(pathSupplier.get()));
    }

    public static Provider<Wmm> createWmmFromName(Supplier<String> nameSupplier) {
        return createWmmFromPath(() -> getRootPath("cat/" + nameSupplier.get() + ".cat"));
    }

    // =========================== Program providers ==============================

    public static Provider<Program> createProgramFromPath(Supplier<String> pathSupplier) {
        return createProgramFromFile(() -> new File(pathSupplier.get()));
    }

    public static Provider<Program> createProgramFromFile(Supplier<File> fileSupplier) {
        return Provider.fromSupplier(() -> new ProgramParser().parse(fileSupplier.get()));
    }

    // =========================== Task related providers ==============================

    public static Provider<VerificationTask> createTask(Supplier<Program> programSupplier, Supplier<Wmm> wmmSupplier, Supplier<EnumSet<Property>> propertySupplier,
                                                        Supplier<Arch> targetSupplier, Supplier<Integer> boundSupplier, Supplier<Configuration> config) {
    	return Provider.fromSupplier(() -> VerificationTask.builder().
    	        withConfig(config.get()).
    			withTarget(targetSupplier.get()).
    			withBound(boundSupplier.get()).
    			build(programSupplier.get(), wmmSupplier.get(), propertySupplier.get()));
    }

    // =========================== Solving related providers ==============================

    public static Provider<SolverContext> createSolverContext(Supplier<ShutdownNotifier> shutdownNotifierSupplier, Supplier<Solvers> solverSupplier) {
        return Provider.fromSupplier(() -> TestHelper.createContextWithShutdownNotifier(shutdownNotifierSupplier.get(), solverSupplier.get()));
    }

    public static Provider<SolverContext> createSolverContextFromManager(Supplier<ShutdownManager> shutdownManagerSupplier, Supplier<Solvers> solverSupplier) {
        return Provider.fromSupplier(() -> TestHelper.createContextWithShutdownNotifier(shutdownManagerSupplier.get().getNotifier(), solverSupplier.get()));
    }

    public static Provider<ProverWithTracker> createProver(Supplier<SolverContext> contextSupplier, Supplier<SolverContext.ProverOptions[]> optionsSupplier) {
        return Provider.fromSupplier(() -> new ProverWithTracker(contextSupplier.get(), "", optionsSupplier.get()));
    }

    public static Provider<ProverWithTracker> createProverWithFixedOptions(Supplier<SolverContext> contextSupplier, SolverContext.ProverOptions... options) {
        return createProver(contextSupplier, () -> options);
    }
}
