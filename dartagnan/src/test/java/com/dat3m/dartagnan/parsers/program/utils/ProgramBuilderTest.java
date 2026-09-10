package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.exception.ParsingException;
import org.junit.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.Utils.hasExtension;
import static com.dat3m.dartagnan.test.TestHelper.EXTENSION_LITMUS;
import static com.dat3m.dartagnan.test.TestHelper.parseProgram;
import static com.dat3m.dartagnan.test.ResourceHelper.getTestResourcePath;
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
                                    parseProgram(f);
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
