package com.dat3m.dartagnan.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.parsers.program.ParserSpirv;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.specification.AssertBasic;
import com.dat3m.dartagnan.program.specification.AssertCompositeAnd;
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
              %v3uint = OpTypeVector %uint 3
          %ptr_v3uint = OpTypePointer Uniform %v3uint
            %ptr_uint = OpTypePointer Uniform %uint
                %func = OpTypeFunction %void
                  %v1 = OpVariable %ptr_uint Uniform
                  %v2 = OpVariable %ptr_uint Uniform
                  %v3 = OpVariable %ptr_uint Uniform
                  %c0 = OpConstant %uint 0
                  %c1 = OpConstant %uint 1
                  %c2 = OpConstant %uint 2
                 %v3v = OpVariable %ptr_v3uint Uniform
                  %v4 = OpVariable %ptr_v3uint Uniform
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
        Optional<MemoryObject> v1 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v1")).findFirst();
        Optional<MemoryObject> v2 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v2")).findFirst();
        Optional<MemoryObject> v3 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v3")).findFirst();
        assert (v1.isPresent());
        assert (v1.get().getInitialValue(0).toString().equals("bv64(7)"));
        assert (v2.isPresent());
        assert (v2.get().getInitialValue(0).toString().equals("bv64(123)"));
        assert (v3.isPresent());
        assert (v3.get().getInitialValue(0).toString().equals("bv64(0)"));
    }

    @Test
    public void testSpace() {
        String header = """
                ; @   Input   : %v1=7, %v2=123, %v3=0
                ; @  Output : forall (%v1==7 and %v2==123 and %v3==0)
                ;       @ Config : 1, 1, 1
                """;
        Program program = parse(header);
        Optional<MemoryObject> v1 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v1")).findFirst();
        Optional<MemoryObject> v2 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v2")).findFirst();
        Optional<MemoryObject> v3 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v3")).findFirst();
        assert (v1.isPresent());
        assert (v1.get().getInitialValue(0).toString().equals("bv64(7)"));
        assert (v2.isPresent());
        assert (v2.get().getInitialValue(0).toString().equals("bv64(123)"));
        assert (v3.isPresent());
        assert (v3.get().getInitialValue(0).toString().equals("bv64(0)"));
    }

    @Test
    public void testSequence() {
        String header = """
                ; @Config: 1, 1, 1
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; @Input: %v1=7, %v2=123, %v3=0
                """;
        Program program = parse(header);
        Optional<MemoryObject> v1 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v1")).findFirst();
        Optional<MemoryObject> v2 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v2")).findFirst();
        Optional<MemoryObject> v3 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v3")).findFirst();
        assert (v1.isPresent());
        assert (v1.get().getInitialValue(0).toString().equals("bv64(7)"));
        assert (v2.isPresent());
        assert (v2.get().getInitialValue(0).toString().equals("bv64(123)"));
        assert (v3.isPresent());
        assert (v3.get().getInitialValue(0).toString().equals("bv64(0)"));
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
        Optional<MemoryObject> v1 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v1")).findFirst();
        Optional<MemoryObject> v2 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v2")).findFirst();
        Optional<MemoryObject> v3 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v3")).findFirst();
        assert (v1.isPresent());
        assert (v1.get().getInitialValue(0).toString().equals("bv64(7)"));
        assert (v2.isPresent());
        assert (v2.get().getInitialValue(0).toString().equals("bv64(123)"));
        assert (v3.isPresent());
        assert (v3.get().getInitialValue(0).toString().equals("bv64(0)"));
    }

    @Test
    public void testInputVector() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0, %v4 = {11, 22, 33}
                ; @Output: forall (%v1==7 and %v4[0]==0 and %v4[1]==0 and %v4[2]==0)
                ; @Config: 1, 1, 1
                """;
        Program program = parse(header);
        Optional<MemoryObject> v1 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v1")).findFirst();
        Optional<MemoryObject> v2 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v2")).findFirst();
        Optional<MemoryObject> v3 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v3")).findFirst();
        Optional<MemoryObject> v4 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v4")).findFirst();
        assert (v1.isPresent());
        assert (v1.get().getInitialValue(0).toString().equals("bv64(7)"));
        assert (v2.isPresent());
        assert (v2.get().getInitialValue(0).toString().equals("bv64(123)"));
        assert (v3.isPresent());
        assert (v3.get().getInitialValue(0).toString().equals("bv64(0)"));
        assert (v4.isPresent());
        assert (v4.get().getInitialValue(0).toString().equals("bv64(11)"));
        assert (v4.get().getInitialValue(8).toString().equals("bv64(22)"));
        assert (v4.get().getInitialValue(16).toString().equals("bv64(33)"));
    }

    @Test
    public void testEmptyInput() {
        String header = """
                ; @Input:
                ; @Output: forall (0)
                ; @Config: 1, 1, 1
                """;
        try {
            parse(header);
        } catch (Exception e) {
            fail("Empty input should not have thrown any exception");
        }
    }

    @Test
    public void testMissingInput() {
        String header = """
                ; @Output: forall (0)
                ; @Config: 1, 1, 1
                """;
        try {
            parse(header);
        } catch (Exception e) {
            fail("Empty input should not have thrown any exception");
        }
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
        Optional<MemoryObject> v1 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v1")).findFirst();
        Optional<MemoryObject> v2 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v2")).findFirst();
        Optional<MemoryObject> v3 = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals("%v3")).findFirst();
        assert (v1.isPresent());
        assert (v1.get().getInitialValue(0).toString().equals("bv64(7)"));
        assert (v2.isPresent());
        assert (v2.get().getInitialValue(0).toString().equals("bv64(123)"));
        assert (v3.isPresent());
        assert (v3.get().getInitialValue(0).toString().equals("bv64(0)"));
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
    public void testVectorOutput() {
        String header = """
                ; @ Input: %v3v = {77, 88, 99}
                ; @ Output: forall (%v3v[0]==77 and %v3v[1]==88 and %v3v[2]==99)
                ; @ Config: 1, 1, 1
                """;
        Program program = parse(header);
        AssertCompositeAnd astAnd = (AssertCompositeAnd) program.getSpecification();
        AssertCompositeAnd astAnda1 = (AssertCompositeAnd) astAnd.getLeft();
        AssertBasic astAnda2 = (AssertBasic) astAnd.getRight();
        AssertBasic astAnda1a1 = (AssertBasic) astAnda1.getLeft();
        AssertBasic astAnda1a2 = (AssertBasic) astAnda1.getRight();
        Location e1 = (Location) astAnda1a1.getLeft();
        IValue v1 = (IValue) astAnda1a1.getRight();
        Location e2 = (Location) astAnda1a2.getLeft();
        IValue v2 = (IValue) astAnda1a2.getRight();
        Location e3 = (Location) astAnda2.getLeft();
        IValue v3 = (IValue) astAnda2.getRight();
        assert (e1.getName().equals("%v3v"));
        assert (e1.getOffset() == 0);
        assert (v1.toString().equals("bv64(77)"));
        assert (e2.getName().equals("%v3v"));
        assert (e2.getOffset() == 1);
        assert (v2.toString().equals("bv64(88)"));
        assert (e3.getName().equals("%v3v"));
        assert (e3.getOffset() == 2);
        assert (v3.toString().equals("bv64(99)"));
    }

    @Test
    public void testVectorOverRangeOutput() {
        String header = """
                ; @ Input: %v3v = {77, 88, 99}
                ; @ Output: forall (%v3v[0]==77 and %v3v[256]==88 and %v3v[1000]==99)
                ; @ Config: 1, 1, 1
                """;
        Program program = parse(header);
        AssertCompositeAnd astAnd = (AssertCompositeAnd) program.getSpecification();
        AssertCompositeAnd astAnda1 = (AssertCompositeAnd) astAnd.getLeft();
        AssertBasic astAnda2 = (AssertBasic) astAnd.getRight();
        AssertBasic astAnda1a1 = (AssertBasic) astAnda1.getLeft();
        AssertBasic astAnda1a2 = (AssertBasic) astAnda1.getRight();
        Location e1 = (Location) astAnda1a1.getLeft();
        IValue v1 = (IValue) astAnda1a1.getRight();
        Location e2 = (Location) astAnda1a2.getLeft();
        IValue v2 = (IValue) astAnda1a2.getRight();
        Location e3 = (Location) astAnda2.getLeft();
        IValue v3 = (IValue) astAnda2.getRight();
        assert (e1.getName().equals("%v3v"));
        assert (e1.getOffset() == 0);
        assert (v1.toString().equals("bv64(77)"));
        assert (e2.getName().equals("%v3v"));
        assert (e2.getOffset() == 256);
        assert (v2.toString().equals("bv64(88)"));
        assert (e3.getName().equals("%v3v"));
        assert (e3.getOffset() == 1000);
        assert (v3.toString().equals("bv64(99)"));
    }

    @Test
    public void testUndefinedOutput() {
        String header = """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v4!=456)
                ; @Config: 1, 1, 1
                """;
        try {
            parse(header);
        } catch (Exception e) {
            assert (e.getMessage().equals("Undefined memory object '%v4'"));
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
            fail("Empty config should not have thrown any exception");
        }
    }

    @Test
    public void testMissingHeader() {
        String header = """
                """;
        try {
            parse(header);
        } catch (ParsingException e) {
            fail("Empty header should not have thrown any exception");
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
