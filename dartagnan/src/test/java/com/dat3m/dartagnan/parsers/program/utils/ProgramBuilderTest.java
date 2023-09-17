package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.fail;

public class ProgramBuilderTest {

    @Test
    public void testLabelsValidation() throws IOException {
        try (Stream<Path> fileStream = Files.walk(Paths.get(getTestResourcePath("parsers/program/utils/programBuilder/labels/aarch64")))) {
            fileStream
                    .filter(Files::isRegularFile)
                    .filter(f -> (f.toString().endsWith("litmus")))
                    .forEach(f -> {
                                try {
                                    new ProgramParser().parse(new File(f.toString()));
                                } catch (MalformedProgramException e) {
                                    // Test succeeded
                                } catch (Exception e) {
                                    fail("Missing resource file");
                                }
                            }
                    );
        }
    }
}
