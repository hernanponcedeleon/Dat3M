package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import org.junit.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.Utils.hasExtension;
import static com.dat3m.dartagnan.parsers.program.ProgramParser.EXTENSION_LITMUS;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.fail;

public class ProgramBuilderTest {

    @Test
    public void testLabelsValidation() throws IOException {
        try (Stream<Path> fileStream = Files.walk(getTestResourcePath("parsers/program/utils/programBuilder/labels/aarch64"))) {
            fileStream
                    .filter(Files::isRegularFile)
                    .filter(f -> hasExtension(f, EXTENSION_LITMUS))
                    .forEach(f -> {
                                try {
                                    new ProgramParser().parse(f);
                                } catch (ParsingException e) {
                                    // Test succeeded
                                } catch (Exception e) {
                                    fail("Missing resource file");
                                }
                            }
                    );
        }
    }
}
