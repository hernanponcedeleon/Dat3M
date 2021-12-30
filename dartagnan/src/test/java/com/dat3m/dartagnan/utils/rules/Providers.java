package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;

import java.io.File;
import java.util.function.Supplier;


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
        return createWmmFromPath(() -> ResourceHelper.CAT_RESOURCE_PATH + "cat/" + nameSupplier.get() + ".cat");
    }

    // =========================== Program providers ==============================

    public static Provider<Program> createProgramFromPath(Supplier<String> pathSupplier) {
        return createProgramFromFile(() -> new File(pathSupplier.get()));
    }

    public static Provider<Program> createProgramFromFile(Supplier<File> fileSupplier) {
        return Provider.fromSupplier(() -> new ProgramParser().parse(fileSupplier.get()));
    }

    // =========================== Task related providers ==============================

    public static Provider<VerificationTask> createTask(Supplier<Program> programSupplier, Supplier<Wmm> wmmSupplier,
                                                        Supplier<Arch> targetSupplier, Supplier<Settings> settingsSupplier) {
        return Provider.fromSupplier(() -> new VerificationTask(programSupplier.get(), wmmSupplier.get(), targetSupplier.get(), settingsSupplier.get()));
    }

    public static Provider<Settings> createSettings(Supplier<Integer> boundSupplier, Supplier<Integer> timeoutSupplier) {
        return Provider.fromSupplier(() -> new Settings(boundSupplier.get(), timeoutSupplier.get()));
    }

    // =========================== Solving related providers ==============================

    public static Provider<SolverContext> createSolverContext(Supplier<ShutdownNotifier> shutdownNotifierSupplier) {
        return Provider.fromSupplier(() -> TestHelper.createContextWithShutdownNotifier(shutdownNotifierSupplier.get()));
    }

    public static Provider<SolverContext> createSolverContextFromManager(Supplier<ShutdownManager> shutdownManagerSupplier) {
        return Provider.fromSupplier(() -> TestHelper.createContextWithShutdownNotifier(shutdownManagerSupplier.get().getNotifier()));
    }

    public static Provider<ProverEnvironment> createProver(Supplier<SolverContext> contextSupplier, Supplier<SolverContext.ProverOptions[]> optionsSupplier) {
        return Provider.fromSupplier(() -> contextSupplier.get().newProverEnvironment(optionsSupplier.get()));
    }

    public static Provider<ProverEnvironment> createProverWithFixedOptions(Supplier<SolverContext> contextSupplier, SolverContext.ProverOptions... options) {
        return createProver(contextSupplier, () -> options);
    }
}
