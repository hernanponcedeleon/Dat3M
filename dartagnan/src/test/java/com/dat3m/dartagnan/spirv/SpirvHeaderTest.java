package com.dat3m.dartagnan.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.ParserSpirv;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.junit.Test;

import java.util.Optional;

import static org.junit.Assert.fail;

public class SpirvHeaderTest {

    private final String spvBody = """
                        OpCapability Shader
                 %ext = OpExtInstImport "GLSL.std.450"
                        OpMemoryModel Logical GLSL450
                        OpEntryPoint GLCompute %main "main"
                        OpSource GLSL 450
                %void = OpTypeVoid
                %uint = OpTypeInt 64 0
            %ptr_uint = OpTypePointer Uniform %uint
                %func = OpTypeFunction %void
                %main = OpFunction %void None %func
               %label = OpLabel
                        OpReturn
                        OpFunctionEnd
                         """;


    public SpirvHeaderTest() {
    }

    // --------------------------------------------------------------
    // Input Tests
    @Test
    public void testInputValue() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """;
        Program program = parse(header);
        assert (program.getMemory().getObjects().toString().equals("[%v1, %v2, %v3]"));
        Optional<MemoryObject> v1 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v1")).findFirst();
        Optional<MemoryObject> v2 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v2")).findFirst();
        Optional<MemoryObject> v3 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v3")).findFirst();
        assert (v1.isPresent());
        assert (v1.get().getInitialValue(0).toString().equals("int(7)"));
        assert (v2.isPresent());
        assert (v2.get().getInitialValue(0).toString().equals("int(123)"));
        assert (v3.isPresent());
        assert (v3.get().getInitialValue(0).toString().equals("int(0)"));
    }

    @Test
    public void testSpace() {
        String header = """
                ; @   Input   : %v1=7, %v2=123, %v3=0
                ; @  Output : forall (%v1==7 and %v2==123 and %v3==0)
                ;       @ Config : 1, 1, 1
                """;
        Program program = parse(header);
        assert (program.getMemory().getObjects().toString().equals("[%v1, %v2, %v3]"));
        Optional<MemoryObject> v1 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v1")).findFirst();
        Optional<MemoryObject> v2 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v2")).findFirst();
        Optional<MemoryObject> v3 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v3")).findFirst();
        assert (v1.isPresent());
        assert (v1.get().getInitialValue(0).toString().equals("int(7)"));
        assert (v2.isPresent());
        assert (v2.get().getInitialValue(0).toString().equals("int(123)"));
        assert (v3.isPresent());
        assert (v3.get().getInitialValue(0).toString().equals("int(0)"));
    }

    @Test
    public void testSequence() {
        String header = """
                ; @Config: 1, 1, 1
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; @Input: %v1=7, %v2=123, %v3=0
                """;
        Program program = parse(header);
        assert (program.getMemory().getObjects().toString().equals("[%v1, %v2, %v3]"));
        Optional<MemoryObject> v1 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v1")).findFirst();
        Optional<MemoryObject> v2 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v2")).findFirst();
        Optional<MemoryObject> v3 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v3")).findFirst();
        assert (v1.isPresent());
        assert (v1.get().getInitialValue(0).toString().equals("int(7)"));
        assert (v2.isPresent());
        assert (v2.get().getInitialValue(0).toString().equals("int(123)"));
        assert (v3.isPresent());
        assert (v3.get().getInitialValue(0).toString().equals("int(0)"));
    }

    @Test
    public void testMixWithComments() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; SPIR-V
                ; Version: 1.0
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; Schema: 0
                ; @Config: 1, 1, 1
                """;
        Program program = parse(header);
        assert (program.getMemory().getObjects().toString().equals("[%v1, %v2, %v3]"));
        Optional<MemoryObject> v1 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v1")).findFirst();
        Optional<MemoryObject> v2 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v2")).findFirst();
        Optional<MemoryObject> v3 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v3")).findFirst();
        assert (v1.isPresent());
        assert (v1.get().getInitialValue(0).toString().equals("int(7)"));
        assert (v2.isPresent());
        assert (v2.get().getInitialValue(0).toString().equals("int(123)"));
        assert (v3.isPresent());
        assert (v3.get().getInitialValue(0).toString().equals("int(0)"));
    }

    @Test
    public void testInputVector() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0, %v4 = {11, 22, 33}
                ; @Output: forall (%v1==7 and %v4[0]==0 and %v4[1]==0 and %v4[2]==0)
                ; @Config: 1, 1, 1
                """;
        Program program = parse(header);
        assert (program.getMemory().getObjects().toString().equals("[%v1, %v2, %v3, %v4]"));
        Optional<MemoryObject> v1 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v1")).findFirst();
        Optional<MemoryObject> v2 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v2")).findFirst();
        Optional<MemoryObject> v3 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v3")).findFirst();
        Optional<MemoryObject> v4 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v4")).findFirst();
        assert (v1.isPresent());
        assert (v1.get().getInitialValue(0).toString().equals("int(7)"));
        assert (v2.isPresent());
        assert (v2.get().getInitialValue(0).toString().equals("int(123)"));
        assert (v3.isPresent());
        assert (v3.get().getInitialValue(0).toString().equals("int(0)"));
        assert (v4.isPresent());
        assert (v4.get().getInitialValue(0).toString().equals("int(11)"));
        assert (v4.get().getInitialValue(1).toString().equals("int(22)"));
        assert (v4.get().getInitialValue(2).toString().equals("int(33)"));
    }

    @Test
    public void testEmptyInput() {
        String header = """
                ; @Input:
                ; @Output: forall (0)
                ; @Config: 1, 1, 1
                """;
        Program program = parse(header);
        assert (program.getMemory().getObjects().toString().equals("[]"));
    }

    @Test
    public void testMissingInput() {
        String header = """
                ; @Output: forall (0)
                ; @Config: 1, 1, 1
                """;
        Program program = parse(header);
        assert (program.getMemory().getObjects().toString().equals("[]"));
    }

    @Test
    public void testMultiLineInput() {
        String header = """
                ; @Input: %v1=7
                ; @Input: %v2=123, %v3=0
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """;
        Program program = parse(header);
        assert (program.getMemory().getObjects().toString().equals("[%v1, %v2, %v3]"));
        Optional<MemoryObject> v1 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v1")).findFirst();
        Optional<MemoryObject> v2 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v2")).findFirst();
        Optional<MemoryObject> v3 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v3")).findFirst();
        assert (v1.isPresent());
        assert (v1.get().getInitialValue(0).toString().equals("int(7)"));
        assert (v2.isPresent());
        assert (v2.get().getInitialValue(0).toString().equals("int(123)"));
        assert (v3.isPresent());
        assert (v3.get().getInitialValue(0).toString().equals("int(0)"));
    }

    @Test
    public void testDuplicateInput() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Input: %v1=7
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """;
        try {
            parse(header);
        } catch (ParsingException e) {
            assert (e.getMessage().equals("Duplicated definition '%v1'"));
        }
    }

    // --------------------------------------------------------------
    // Output Tests
    @Test
    public void testEmptyOutput() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output:
                ; @Config: 1, 1, 1
                """;
        try {
            parse(header);
        } catch (Exception e) {
            // TODO: is this the expected behavior?
            fail("Empty output should not have thrown any exception");
        }
    }

    @Test
    public void testMissingOutput() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Config: 1, 1, 1
                """;
        try {
            parse(header);
        } catch (Exception e) {
            // TODO: is this the expected behavior?
            fail("Empty output should not have thrown any exception");
        }
    }

    @Test
    public void testOutputExists() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """;
        Program program = parse(header);
        assert (program.getSpecification().toString().equals("%v1==bv64(7) && %v2==bv64(123) && %v3==bv64(0)"));
        assert (program.getSpecification().getType().equals("exists"));
    }

    @Test
    public void testOutputNotExists() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: not exists (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """;
        Program program = parse(header);
        assert (program.getSpecification().toString().equals("%v1==bv64(7) && %v2==bv64(123) && %v3==bv64(0)"));
        assert (program.getSpecification().getType().equals("not exists"));
    }

    @Test
    public void testOutputOrExists() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1==7 or %v2==123 or %v3==0)
                ; @Config: 1, 1, 1
                """;
        Program program = parse(header);
        assert (program.getSpecification().toString().equals("((%v1==bv64(7) || %v2==bv64(123)) || %v3==bv64(0))"));
        assert (program.getSpecification().getType().equals("exists"));
    }

    @Test
    public void testMultiLineOutput() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (%v1==7)
                ; @Output: forall (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """;
        Program program = parse(header);
        assert (program.getSpecification().toString().equals("%v1==bv64(7) && %v2==bv64(123) && %v3==bv64(0)"));
        assert (program.getSpecification().getType().equals("forall"));
    }

    @Test
    public void testMultiLineForAllNotExistsOutput() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (%v1==7)
                ; @Output: not exists (%v2!=123 or %v3!=0)
                ; @Config: 1, 1, 1
                """;
        Program program = parse(header);
        assert (program.getSpecification().toString().equals("%v1==bv64(7) && !%v2!=bv64(123) && !%v3!=bv64(0)"));
        assert (program.getSpecification().getType().equals("forall"));
    }

    @Test
    public void testMultiLineNotExistsComplementOutput() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (%v1==7)
                ; @Output: not exists (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """;
        Program program = parse(header);
        assert (program.getSpecification().toString().equals("%v1==bv64(7) && (!%v2==bv64(123) || !%v3==bv64(0))"));
        assert (program.getSpecification().getType().equals("forall"));
    }

    @Test
    public void testMultiLineNotExistsNotExistsOutput() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: not exists (%v1!=7)
                ; @Output: not exists (%v2!=123 or %v3!=0)
                ; @Config: 1, 1, 1
                """;
        Program program = parse(header);
        assert (program.getSpecification().toString().equals("!%v1!=bv64(7) && !%v2!=bv64(123) && !%v3!=bv64(0)"));
        assert (program.getSpecification().getType().equals("forall"));
    }

    @Test
    public void testMultiLineExistsForallOutput() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1!=7)
                ; @Output: forall (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """;
        try {
            parse(header);
        } catch (Exception e) {
            assert (e.getMessage().equals("Existential assertions can not be used in conjunction with other assertions"));
        }
    }

    @Test
    public void testMultiLineExistsNotExistsOutput() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1!=7)
                ; @Output: not exists (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """;
        try {
            parse(header);
        } catch (Exception e) {
            assert (e.getMessage().equals("Existential assertions can not be used in conjunction with other assertions"));
        }
    }

    @Test
    public void testMultiLineExistsExistsOutput() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1!=7)
                ; @Output: exists (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """;
        try {
            parse(header);
        } catch (Exception e) {
            assert (e.getMessage().equals("Existential assertions can not be used in conjunction with other assertions"));
        }
    }

    // --------------------------------------------------------------
    // Config Tests
    @Test
    public void testZeroConfig() {
        String header = """
                ; @Input:
                ; @Output: forall (0)
                ; @Config: 1, 1, 0
                """;
        try {
            parse(header);
        } catch (ParsingException e) {
            assert (e.getMessage().equals("Thread grid dimensions must be positive"));
        }
    }

    @Test
    public void testLargeConfig() {
        String header = """
                ; @Input:
                ; @Output: forall (0)
                ; @Config: 100, 100, 100
                """;
        try {
            parse(header);
        } catch (ParsingException e) {
            assert (e.getMessage().equals("Thread grid dimensions must be less than 128"));
        }
    }

    @Test
    public void testMultiConfig() {
        String header = """
                ; @Input:
                ; @Output: forall (0)
                ; @Config: 1, 1, 1
                ; @Config: 1, 1, 1
                """;
        try {
            parse(header);
        } catch (ParsingException e) {
            assert (e.getMessage().equals("Thread grid is set multiple times"));
        }
    }

    @Test
    public void testMissingConfig() {
        String header = """
                ; @Input:
                ; @Output: forall (0)
                """;
        try {
            parse(header);
        } catch (ParsingException e) {
            assert (e.getMessage().equals("Thread grid is not set"));
        }
    }

    // --------------------------------------------------------------
    // Utility
    private Program parse(String header) {
        String wholeSpv = header + spvBody;
        ParserSpirv parser = new ParserSpirv();
        CharStream charStream = CharStreams.fromString(wholeSpv);
        return parser.parse(charStream);
    }
}
