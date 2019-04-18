package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.utils.ResourceHelper;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import static org.junit.Assert.fail;

public class ProgramBuilderTest {

    @Test
    public void testLabelsValidation() throws IOException {
        Files.walk(Paths.get(ResourceHelper.TEST_RESOURCE_PATH + "parsers/program/utils/programBuilder/labels/aarch64"))
                .filter(Files::isRegularFile)
                .filter(f -> (f.toString().endsWith("litmus")))
                .forEach(f -> {
                            try{
                                new ProgramParser().parse(new File(f.toString()));
                            } catch(ParsingException e){
                                // Test succeeded
                            } catch (IOException e){
                                fail("Missing resource file");
                            }
                        }
                );
    }
}
