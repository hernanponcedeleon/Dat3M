package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.metadata.SourceLocation.SourcePath;
import com.dat3m.dartagnan.program.Program;
import org.junit.Test;

import java.nio.file.Path;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class ProgramParserTest {

    @Test
    public void parsedProgramHasSourceMetadata() throws Exception {
        final Path sourcePath = getTestResourcePath("branch/AARCH64/Aarch64-branch-01.litmus");
        final Program program = new ProgramParser().parse(sourcePath);

        assertTrue(program.hasMetadata(SourcePath.class));
        assertEquals(sourcePath, program.getMetadata(SourcePath.class).sourcePath());
    }

    @Test
    public void temporarilyParsedProgramHasNoSourceMetadata() throws Exception {
        final Path sourcePath = getTestResourcePath("branch/AARCH64/Aarch64-branch-01.litmus");
        final Program program = new ProgramParser().parseTemporary(sourcePath);

        assertFalse(program.hasMetadata(SourcePath.class));
    }
}
