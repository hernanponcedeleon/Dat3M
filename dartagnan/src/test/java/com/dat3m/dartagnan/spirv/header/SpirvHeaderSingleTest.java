package com.dat3m.dartagnan.spirv.header;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.program.ParserSpirv;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.specification.AssertBasic;
import com.dat3m.dartagnan.program.specification.AssertCompositeAnd;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class SpirvHeaderSingleTest {
    public SpirvHeaderSingleTest() {
    }

    @Test
    public void testComplexSpecHeader() {
        String wholeSpv = """
                ; @ Input: %v3v = {77, 88, 99}
                ; @ Output: forall (%v3v[0]==77 and %v3v[1]==88 and %v3v[2]==99)
                ; @ Config: 1, 1, 1
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
        Program program = localParse(wholeSpv);
        AssertCompositeAnd astAnd = (AssertCompositeAnd) program.getSpecification();
        AssertCompositeAnd astAnda1 = (AssertCompositeAnd) astAnd.getLeft();
        AssertBasic astAnda2 = (AssertBasic) astAnd.getRight();
        AssertBasic astAnda1a1 = (AssertBasic) astAnda1.getLeft();
        AssertBasic astAnda1a2 = (AssertBasic) astAnda1.getRight();
        Location e1 = (Location) astAnda1a1.getLeft();
        Expression v1 = astAnda1a1.getRight();
        Location e2 = (Location) astAnda1a2.getLeft();
        Expression v2 = astAnda1a2.getRight();
        Location e3 = (Location) astAnda2.getLeft();
        Expression v3 = astAnda2.getRight();
        int byteWidth = 8;
        assertEquals("%v3v", e1.getName());
        assertEquals(0, e1.getOffset() / byteWidth);
        assertEquals("bv64(77)", v1.toString());
        assertEquals("%v3v", e2.getName());
        assertEquals(1, e2.getOffset() / byteWidth);
        assertEquals("bv64(88)", v2.toString());
        assertEquals("%v3v", e3.getName());
        assertEquals(2, e3.getOffset() / byteWidth);
        assertEquals("bv64(99)", v3.toString());
    }

    @Test
    public void testInt32VectorHeader() {
        String wholeSpv = """
                ; @ Input: %v3v = {77, 88, 99}
                ; @ Output: forall (%v3v[0]==77 and %v3v[1]==88 and %v3v[2]==99)
                ; @ Config: 1, 1, 1
                OpCapability Shader
                   %ext = OpExtInstImport "GLSL.std.450"
                          OpMemoryModel Logical GLSL450
                          OpEntryPoint GLCompute %main "main"
                          OpSource GLSL 450
                  %void = OpTypeVoid
                  %uint = OpTypeInt 32 0
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
        Program program = localParse(wholeSpv);
        AssertCompositeAnd astAnd = (AssertCompositeAnd) program.getSpecification();
        AssertCompositeAnd astAnda1 = (AssertCompositeAnd) astAnd.getLeft();
        AssertBasic astAnda2 = (AssertBasic) astAnd.getRight();
        AssertBasic astAnda1a1 = (AssertBasic) astAnda1.getLeft();
        AssertBasic astAnda1a2 = (AssertBasic) astAnda1.getRight();
        Location e1 = (Location) astAnda1a1.getLeft();
        Expression v1 = astAnda1a1.getRight();
        Location e2 = (Location) astAnda1a2.getLeft();
        Expression v2 = astAnda1a2.getRight();
        Location e3 = (Location) astAnda2.getLeft();
        Expression v3 = astAnda2.getRight();
        int byteWidth = 4;
        assertEquals("%v3v", e1.getName());
        assertEquals(0, e1.getOffset() / byteWidth);
        assertEquals("bv64(77)", v1.toString());
        assertEquals("%v3v", e2.getName());
        assertEquals(1, e2.getOffset() / byteWidth);
        assertEquals("bv64(88)", v2.toString());
        assertEquals("%v3v", e3.getName());
        assertEquals(2, e3.getOffset() / byteWidth);
        assertEquals("bv64(99)", v3.toString());
    }

    private Program localParse(String wholeSpv) {
        ParserSpirv parser = new ParserSpirv();
        CharStream charStream = CharStreams.fromString(wholeSpv);
        return parser.parse(charStream);
    }
}
