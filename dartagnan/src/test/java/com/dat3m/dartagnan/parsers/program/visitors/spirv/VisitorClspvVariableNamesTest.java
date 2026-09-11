package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.junit.Test;

import java.nio.file.Path;
import java.util.Set;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class VisitorClspvVariableNamesTest {

    @Test
    public void testClspvSourceNames() throws Exception {
        Path path = getTestResourcePath("spirv/vulkan/patterns/mp.spvasm");
        Program program = new ProgramParser().parse(path);

        Set<String> names = program.getMemory().getObjects().stream()
                .map(MemoryObject::getName)
                .collect(Collectors.toSet());
        assertTrue(names.containsAll(Set.of("flag", "data", "r0", "r1")));
        assertFalse(names.contains("%5"));
    }
}
