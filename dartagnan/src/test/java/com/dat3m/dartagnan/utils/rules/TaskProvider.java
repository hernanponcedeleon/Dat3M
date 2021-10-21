package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.rules.ExternalResource;

import java.util.function.Supplier;

public class TaskProvider extends ExternalResource implements Supplier<VerificationTask> {

    private final Supplier<Program> programSupplier;
    private final Supplier<Wmm> wmmSupplier;
    private final Supplier<Arch> targetSupplier;
    private final Supplier<Settings> settingsSupplier;

    private VerificationTask task;

    public TaskProvider(Supplier<Program> programSupplier, Supplier<Wmm> wmmSupplier,
                        Supplier<Arch> targetSupplier, Supplier<Settings> settingsSupplier) {
        this.programSupplier = programSupplier;
        this.wmmSupplier = wmmSupplier;
        this.targetSupplier = targetSupplier;
        this.settingsSupplier = settingsSupplier;
    }

    @Override
    protected void before() throws Throwable {
        task = new VerificationTask(programSupplier.get(), wmmSupplier.get(), targetSupplier.get(), settingsSupplier.get());
    }

    @Override
    public VerificationTask get() {
        return task;
    }
}
