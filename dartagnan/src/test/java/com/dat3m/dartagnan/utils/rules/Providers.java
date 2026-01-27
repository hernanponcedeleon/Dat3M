package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;

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
                                                        Supplier<ProgressModel.Hierarchy> progressModelSupplier, Supplier<Configuration> config) {
        return Provider.fromSupplier(() -> VerificationTask.builder().
                withConfig(config.get()).
                withProgressModel(progressModelSupplier.get()).
                build(programSupplier.get(), wmmSupplier.get(), propertySupplier.get())
        );
    }

    public static Provider<VerificationTask> createTask(Supplier<Program> programSupplier, Supplier<Wmm> wmmSupplier, Supplier<EnumSet<Property>> propertySupplier,
                                                        Supplier<Arch> targetSupplier, Supplier<ProgressModel.Hierarchy> progressModelSupplier, Supplier<Integer> boundSupplier, Supplier<Configuration> config) {
        return Provider.fromSupplier(() -> VerificationTask.builder().
                withConfig(config.get()).
                withTarget(targetSupplier.get()).
                withBound(boundSupplier.get()).
                withProgressModel(progressModelSupplier.get()).
                build(programSupplier.get(), wmmSupplier.get(), propertySupplier.get()));
    }

}
