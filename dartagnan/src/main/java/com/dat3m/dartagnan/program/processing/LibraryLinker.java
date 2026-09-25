package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.processing.libraries.*;
import com.google.common.collect.ImmutableList;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.List;

public class LibraryLinker implements ProgramProcessor {

    private final List<Library> libraries;

    private LibraryLinker(Configuration config) throws InvalidConfigurationException {
        libraries = ImmutableList.of(
                new PthreadLibrary(config),
                new LKMMLibrary(config),
                new LLVMLibrary(config),
                new StdLibrary(config),
                new UbsanLibrary(config),
                new VerifierLibrary(config)
        );
    }

    public static LibraryLinker fromConfig(Configuration config) throws InvalidConfigurationException {
        return new LibraryLinker(config);
    }

    @Override
    public void run(Program program) {
        libraries.forEach(library -> library.link(program));
    }
}
