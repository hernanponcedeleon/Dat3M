package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.utils.ResourceHelper;
import org.antlr.v4.runtime.misc.ParseCancellationException;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Collectors;

import static org.junit.Assert.fail;

@RunWith(Parameterized.class)
public class DartagnanArrayIllegalTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        return Files.walk(Paths.get(ResourceHelper.TEST_RESOURCE_PATH + "arrays/error/"))
                .filter(Files::isRegularFile)
                .filter(f -> (f.toString().endsWith("litmus")))
                .map(f -> new Object[]{f.toString()})
                .collect(Collectors.toList());
    }

    private final String path;

    public DartagnanArrayIllegalTest(String path) {
        this.path = path;
    }

    @Test
    public void test() {
        try{
            new ProgramParser().parse(new File(path));
            fail("Didn't throw an exception");
        } catch(ParseCancellationException | ParsingException e){
            // Test succeeded
        } catch (IOException e){
            fail("Missing resource file");
        }
    }
}
