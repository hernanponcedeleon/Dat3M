package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.memory.MemoryObject.VariableName;
import org.junit.Test;

import java.nio.file.Path;
import java.util.Map;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.assertEquals;

public class VisitorClspvVariableNamesTest {

    @Test
    public void testClspvSourceNames() throws Exception {
        Path path = getTestResourcePath("spirv/vulkan/patterns/mp.spvasm");
        Program program = new ProgramParser().parse(path);

        Map<String, String> variableNames = program.getMemory().getObjects().stream()
                .filter(m -> m.hasMetadata(VariableName.class))
                .collect(Collectors.toMap(
                        m -> m.getName(),
                        m -> m.getMetadata(VariableName.class).value()
                ));
        assertEquals(Map.of("%5", "flag", "%6", "data", "%7", "r0", "%8", "r1"), variableNames);
    }
}
