package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.dat3m.dartagnan.program.processing.libraries.*;
import com.google.common.collect.ImmutableList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.List;
import java.util.Optional;
import java.util.TreeSet;
import java.util.stream.Collectors;

public class LibraryLinker implements ProgramProcessor {

    private static final Logger logger = LoggerFactory.getLogger(LibraryLinker.class);

    private final List<Library> libraries;
    private final MissingLibrary missingLibrary;

    private LibraryLinker(Configuration config) throws InvalidConfigurationException {
        libraries = ImmutableList.of(
                new PthreadLibrary(config),
                new LKMMLibrary(config),
                new LLVMLibrary(config),
                new StdLibrary(config),
                new UbsanLibrary(config),
                new VerifierLibrary(config)
        );

        missingLibrary = new MissingLibrary(config);
    }

    public static LibraryLinker fromConfig(Configuration config) throws InvalidConfigurationException {
        return new LibraryLinker(config);
    }

    @Override
    public void run(Program program) {
        libraries.forEach(library -> library.link(program));
        missingLibrary.link(program);

        IdReassignment.newInstance().run(program);
    }


    private static class MissingLibrary extends AbstractLibrary<MissingLibrary> {
        private MissingLibrary(Configuration config) throws InvalidConfigurationException {
            super(config);
        }

        @Override
        protected MissingLibrary getThis() {
            return this;
        }

        private final TreeSet<String> undefinedFunctions = new TreeSet<>();

        @Override
        protected Optional<CallResolver<MissingLibrary>> getHandler(Function function) {
            if (function.isIntrinsic()) {
                return Optional.empty();
            }

            undefinedFunctions.add(function.getName());
            return Optional.of(MissingLibrary::resolveUnknownCall);
        }


        private List<Event> resolveUnknownCall(FunctionCall call) {
            return EventFactory.eventSequence(
                    call instanceof ValueFunctionCall ? inlineCallAsNonDet(call) : null,
                    inlineAssert(AssertionType.UNKNOWN_FUNCTION,
                            "Calling unknown function " + call.getCalledFunction().getName())
            );
        }

        @Override
        public void link(Program program) {
            resolveLibraryCalls(program);

            if (!undefinedFunctions.isEmpty()) {
                logger.warn("{}. Detecting calls to unknown functions requires --property=program_spec.",
                        undefinedFunctions.stream().collect(Collectors.joining(", ", "Unknown functions ", "")));
            }

        }
    }
}
