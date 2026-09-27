package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.dat3m.dartagnan.program.processing.libraries.*;
import com.google.common.collect.ImmutableList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.ArrayList;
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

        @Override
        protected Optional<? extends Handler<MissingLibrary>> getHandler(Function function) {
            return Optional.empty();
        }

        @Override
        public void link(Program program) {
            final TreeSet<String> missingFunctions = new TreeSet<>();

            for (Function function : program.getFunctions()) {
                for (FunctionCall call : function.getEvents(FunctionCall.class)) {
                    if (!call.isDirectCall()) {
                        continue;
                    }
                    final Function target = call.getDirectCallTarget();
                    if (target.hasBody() || target.isIntrinsic()) {
                        continue;
                    }

                    final List<Event> replacement = new ArrayList<>();
                    if (call instanceof ValueFunctionCall) {
                        replacement.addAll(inlineCallAsNonDet(call));
                    }
                    replacement.addAll(inlineAssert(AssertionType.UNKNOWN_FUNCTION,
                            "Calling unknown function " + target.getName()));
                    IRHelper.replaceWithMetadata(call, replacement);

                    missingFunctions.add(target.getName());
                }
            }

            if (!missingFunctions.isEmpty()) {
                logger.warn("{}. Detecting calls to unknown functions requires --property=program_spec.",
                        missingFunctions.stream().collect(Collectors.joining(", ", "Unknown functions ", "")));
            }

        }
    }
}
