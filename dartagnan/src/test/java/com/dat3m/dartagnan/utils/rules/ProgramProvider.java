package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;

import java.io.File;
import java.util.function.Supplier;

public class ProgramProvider extends Provider<Program> {

    private final Supplier<String> pathProvider;
    public ProgramProvider(Supplier<String> pathProvider) {
        this.pathProvider = pathProvider;
    }

    @Override
    protected Program provide() throws Throwable {
        return new ProgramParser().parse(new File(pathProvider.get()));
    }

}
