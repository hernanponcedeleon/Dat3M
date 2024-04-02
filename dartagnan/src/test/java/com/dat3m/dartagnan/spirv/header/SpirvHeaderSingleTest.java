package com.dat3m.dartagnan.spirv.header;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.ParserSpirv;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.specification.AssertBasic;
import com.dat3m.dartagnan.program.specification.AssertCompositeAnd;
import com.dat3m.dartagnan.program.specification.AssertCompositeOr;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.junit.Test;

import static com.dat3m.dartagnan.program.specification.AbstractAssert.ASSERT_TYPE_FORALL;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class SpirvHeaderSingleTest {
    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();
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

    @Test
    public void testAssertionScalarLeft() {
        // given
        String input = """
                ; @Output: forall %v1==1 and %v2>2 and %v3<3
                """;

        // when
        Program program = localParse(input + spvBody);
        AssertCompositeAnd ast = (AssertCompositeAnd) program.getSpecification();

        // then
        assertEquals(ASSERT_TYPE_FORALL, ast.getType());

        AssertBasic ast1 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getLeft();
        AssertBasic ast2 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getRight();
        AssertBasic ast3 = (AssertBasic) ast.getRight();

        IntegerType int64 = TYPE_FACTORY.getIntegerType(64);

        assertEquals(EXPR_FACTORY.makeValue(1, int64), ast1.getRight());
        assertEquals(EXPR_FACTORY.makeValue(2, int64), ast2.getRight());
        assertEquals(EXPR_FACTORY.makeValue(3, int64), ast3.getRight());

        assertEquals("%v1", ((Location) ast1.getLeft()).getMemoryObject().getName());
        assertEquals("%v2", ((Location) ast2.getLeft()).getMemoryObject().getName());
        assertEquals("%v3", ((Location) ast3.getLeft()).getMemoryObject().getName());
    }

    @Test
    public void testAssertionScalarRight() {
        // given
        String input = """
                ; @Output: forall 1!=%v1 and 2>%v2 and 3<%v3
                """;

        // when
        Program program = localParse(input + spvBody);
        AssertCompositeAnd ast = (AssertCompositeAnd) program.getSpecification();

        // then
        assertEquals(ASSERT_TYPE_FORALL, ast.getType());

        AssertBasic ast1 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getLeft();
        AssertBasic ast2 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getRight();
        AssertBasic ast3 = (AssertBasic) ast.getRight();

        IntegerType int64 = TYPE_FACTORY.getIntegerType(64);

        assertEquals(EXPR_FACTORY.makeValue(1, int64), ast1.getLeft());
        assertEquals(EXPR_FACTORY.makeValue(2, int64), ast2.getLeft());
        assertEquals(EXPR_FACTORY.makeValue(3, int64), ast3.getLeft());

        assertEquals("%v1", ((Location) ast1.getRight()).getName());
        assertEquals("%v2", ((Location) ast2.getRight()).getName());
        assertEquals("%v3", ((Location) ast3.getRight()).getName());
    }

    @Test
    public void testAssertionVectorLeft() {
        // given
        String input = """
                ; @Output: forall %v4[0]<=1 and %v4[1]>=2 and %v4[2]==3
                """;

        // when
        Program program = localParse(input + spvBody);
        AssertCompositeAnd ast = (AssertCompositeAnd) program.getSpecification();

        // then
        assertEquals(ASSERT_TYPE_FORALL, ast.getType());

        AssertBasic ast1 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getLeft();
        AssertBasic ast2 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getRight();
        AssertBasic ast3 = (AssertBasic) ast.getRight();

        IntegerType int64 = TYPE_FACTORY.getIntegerType(64);

        assertEquals(EXPR_FACTORY.makeValue(1, int64), ast1.getRight());
        assertEquals(EXPR_FACTORY.makeValue(2, int64), ast2.getRight());
        assertEquals(EXPR_FACTORY.makeValue(3, int64), ast3.getRight());

        assertEquals("%v4[0]", ((Location) ast1.getLeft()).getName());
        assertEquals("%v4[1]", ((Location) ast2.getLeft()).getName());
        assertEquals("%v4[2]", ((Location) ast3.getLeft()).getName());

        assertEquals(0, ((Location) ast1.getLeft()).getOffset());
        assertEquals(8, ((Location) ast2.getLeft()).getOffset());
        assertEquals(16, ((Location) ast3.getLeft()).getOffset());
    }

    @Test
    public void testAssertionVectorRight() {
        // given
        String input = """
                ; @Output: forall 1<=%v4[0] and 2>=%v4[1] and 3==%v4[2]
                """;

        // when
        Program program = localParse(input + spvBody);
        AssertCompositeAnd ast = (AssertCompositeAnd) program.getSpecification();

        // then
        assertEquals(ASSERT_TYPE_FORALL, ast.getType());

        AssertBasic ast1 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getLeft();
        AssertBasic ast2 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getRight();
        AssertBasic ast3 = (AssertBasic) ast.getRight();

        IntegerType int64 = TYPE_FACTORY.getIntegerType(64);

        assertEquals(EXPR_FACTORY.makeValue(1, int64), ast1.getLeft());
        assertEquals(EXPR_FACTORY.makeValue(2, int64), ast2.getLeft());
        assertEquals(EXPR_FACTORY.makeValue(3, int64), ast3.getLeft());

        assertEquals("%v4[0]", ((Location) ast1.getRight()).getName());
        assertEquals("%v4[1]", ((Location) ast2.getRight()).getName());
        assertEquals("%v4[2]", ((Location) ast3.getRight()).getName());

        assertEquals(0, ((Location) ast1.getRight()).getOffset());
        assertEquals(8, ((Location) ast2.getRight()).getOffset());
        assertEquals(16, ((Location) ast3.getRight()).getOffset());
    }

    @Test
    public void testAssertionArrayLeft() {
        // given
        String wholeSpv = """
                    ; @ Output: forall (%v4[0]==1 and %v4[1]==2 and %v4[2]==3)
                    OpCapability Shader
                       %ext = OpExtInstImport "GLSL.std.450"
                              OpMemoryModel Logical GLSL450
                              OpEntryPoint GLCompute %main "main"
                              OpSource GLSL 450
                      %void = OpTypeVoid
                      %uint = OpTypeInt 64 0
                        %c3 = OpConstant %uint 3
                    %v3uint = OpTypeArray %uint %c3
                %ptr_v3uint = OpTypePointer Uniform %v3uint
                  %ptr_uint = OpTypePointer Uniform %uint
                      %func = OpTypeFunction %void
                        %v1 = OpVariable %ptr_uint Uniform
                        %v2 = OpVariable %ptr_uint Uniform
                        %v3 = OpVariable %ptr_uint Uniform
                        %c0 = OpConstant %uint 0
                        %c1 = OpConstant %uint 1
                        %c2 = OpConstant %uint 2
                        %v4 = OpVariable %ptr_v3uint Uniform
                      %main = OpFunction %void None %func
                     %label = OpLabel
                              OpReturn
                              OpFunctionEnd
                    """;
        // when
        Program program = localParse(wholeSpv);
        AssertCompositeAnd ast = (AssertCompositeAnd) program.getSpecification();

        // then
        assertEquals(ASSERT_TYPE_FORALL, ast.getType());

        AssertBasic ast1 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getLeft();
        AssertBasic ast2 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getRight();
        AssertBasic ast3 = (AssertBasic) ast.getRight();

        IntegerType int64 = TYPE_FACTORY.getIntegerType(64);

        assertEquals(EXPR_FACTORY.makeValue(1, int64), ast1.getRight());
        assertEquals(EXPR_FACTORY.makeValue(2, int64), ast2.getRight());
        assertEquals(EXPR_FACTORY.makeValue(3, int64), ast3.getRight());

        assertEquals("%v4[0]", ((Location) ast1.getLeft()).getName());
        assertEquals("%v4[1]", ((Location) ast2.getLeft()).getName());
        assertEquals("%v4[2]", ((Location) ast3.getLeft()).getName());

        assertEquals(0, ((Location) ast1.getLeft()).getOffset());
        assertEquals(8, ((Location) ast2.getLeft()).getOffset());
        assertEquals(16, ((Location) ast3.getLeft()).getOffset());
    }

    @Test
    public void testAssertionArrayRight() {
        // given
        String wholeSpv = """
                    ; @ Output: forall (1==%v4[0] and 2==%v4[1] and 3==%v4[2])
                    OpCapability Shader
                       %ext = OpExtInstImport "GLSL.std.450"
                              OpMemoryModel Logical GLSL450
                              OpEntryPoint GLCompute %main "main"
                              OpSource GLSL 450
                      %void = OpTypeVoid
                      %uint = OpTypeInt 64 0
                        %c3 = OpConstant %uint 3
                    %v3uint = OpTypeArray %uint %c3
                %ptr_v3uint = OpTypePointer Uniform %v3uint
                  %ptr_uint = OpTypePointer Uniform %uint
                      %func = OpTypeFunction %void
                        %v1 = OpVariable %ptr_uint Uniform
                        %v2 = OpVariable %ptr_uint Uniform
                        %v3 = OpVariable %ptr_uint Uniform
                        %c0 = OpConstant %uint 0
                        %c1 = OpConstant %uint 1
                        %c2 = OpConstant %uint 2
                        %v4 = OpVariable %ptr_v3uint Uniform
                      %main = OpFunction %void None %func
                     %label = OpLabel
                              OpReturn
                              OpFunctionEnd
                    """;
        // when
        Program program = localParse(wholeSpv);
        AssertCompositeAnd ast = (AssertCompositeAnd) program.getSpecification();

        // then
        assertEquals(ASSERT_TYPE_FORALL, ast.getType());

        AssertBasic ast1 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getLeft();
        AssertBasic ast2 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getRight();
        AssertBasic ast3 = (AssertBasic) ast.getRight();

        IntegerType int64 = TYPE_FACTORY.getIntegerType(64);

        assertEquals(EXPR_FACTORY.makeValue(1, int64), ast1.getLeft());
        assertEquals(EXPR_FACTORY.makeValue(2, int64), ast2.getLeft());
        assertEquals(EXPR_FACTORY.makeValue(3, int64), ast3.getLeft());

        assertEquals("%v4[0]", ((Location) ast1.getRight()).getName());
        assertEquals("%v4[1]", ((Location) ast2.getRight()).getName());
        assertEquals("%v4[2]", ((Location) ast3.getRight()).getName());

        assertEquals(0, ((Location) ast1.getRight()).getOffset());
        assertEquals(8, ((Location) ast2.getRight()).getOffset());
        assertEquals(16, ((Location) ast3.getRight()).getOffset());
    }

    @Test
    public void testAssertionStructLeft() {
        // given
        String wholeSpv = """
                ; @Input: %v4 = {{0, 0}, {0}}
                ; @Output: forall (%v4[0][0]==1 and %v4[0][1]==2 and %v4[1][0]==3)
                               OpCapability Shader
                        %ext = OpExtInstImport "GLSL.std.450"
                               OpMemoryModel Logical GLSL450
                               OpEntryPoint GLCompute %main "main"
                               OpSource GLSL 450
                       %void = OpTypeVoid
                       %func = OpTypeFunction %void
                       %uint = OpTypeInt 64 0
                         %c0 = OpConstant %uint 0
                         %c1 = OpConstant %uint 1
                         %c2 = OpConstant %uint 2
                     %v1uint = OpTypeVector %uint 1
                     %v2uint = OpTypeArray %uint %c2
                     %struct = OpTypeStruct %v2uint %v1uint
                 %ptr_struct = OpTypePointer Uniform %struct
                   %ptr_uint = OpTypePointer Uniform %uint
                        %v4 = OpVariable %ptr_struct Uniform
                       %main = OpFunction %void None %func
                      %label = OpLabel
                        %el0 = OpAccessChain %ptr_uint %v4 %c0 %c0
                        %el1 = OpAccessChain %ptr_uint %v4 %c1 %c0
                        %el2 = OpAccessChain %ptr_uint %v4 %c1 %c1
                               OpStore %el0 %c0
                               OpStore %el1 %c1
                               OpStore %el2 %c2
                               OpReturn
                               OpFunctionEnd
                     """;
        // when
        Program program = localParse(wholeSpv);
        AssertCompositeAnd ast = (AssertCompositeAnd) program.getSpecification();

        // then
        assertEquals(ASSERT_TYPE_FORALL, ast.getType());

        AssertBasic ast1 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getLeft();
        AssertBasic ast2 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getRight();
        AssertBasic ast3 = (AssertBasic) ast.getRight();

        IntegerType int64 = TYPE_FACTORY.getIntegerType(64);

        assertEquals(EXPR_FACTORY.makeValue(1, int64), ast1.getRight());
        assertEquals(EXPR_FACTORY.makeValue(2, int64), ast2.getRight());
        assertEquals(EXPR_FACTORY.makeValue(3, int64), ast3.getRight());

        assertEquals("%v4[0][0]", ((Location) ast1.getLeft()).getName());
        assertEquals("%v4[0][1]", ((Location) ast2.getLeft()).getName());
        assertEquals("%v4[1][0]", ((Location) ast3.getLeft()).getName());

        assertEquals(0, ((Location) ast1.getLeft()).getOffset());
        assertEquals(8, ((Location) ast2.getLeft()).getOffset());
        assertEquals(16, ((Location) ast3.getLeft()).getOffset());
    }

    @Test
    public void testAssertionStructRight() {
        // given
        String wholeSpv = """
                    ; @Input: %v4 = {{0, 0}, {0}}
                    ; @ Output: forall (1==%v4[0][0] and 2==%v4[0][1] and 3==%v4[1][0])
                              OpCapability Shader
                       %ext = OpExtInstImport "GLSL.std.450"
                              OpMemoryModel Logical GLSL450
                              OpEntryPoint GLCompute %main "main"
                              OpSource GLSL 450
                      %void = OpTypeVoid
                      %func = OpTypeFunction %void
                      %uint = OpTypeInt 64 0
                        %c0 = OpConstant %uint 0
                        %c1 = OpConstant %uint 1
                        %c2 = OpConstant %uint 2
                    %v1uint = OpTypeVector %uint 1
                    %v2uint = OpTypeArray %uint %c2
                    %struct = OpTypeStruct %v2uint %v1uint
                %ptr_struct = OpTypePointer Uniform %struct
                  %ptr_uint = OpTypePointer Uniform %uint
                       %v4 = OpVariable %ptr_struct Uniform
                      %main = OpFunction %void None %func
                     %label = OpLabel
                       %el0 = OpAccessChain %ptr_uint %v4 %c0 %c0
                       %el1 = OpAccessChain %ptr_uint %v4 %c1 %c0
                       %el2 = OpAccessChain %ptr_uint %v4 %c1 %c1
                              OpStore %el0 %c0
                              OpStore %el1 %c1
                              OpStore %el2 %c2
                              OpReturn
                              OpFunctionEnd
                    """;
        // when
        Program program = localParse(wholeSpv);
        AssertCompositeAnd ast = (AssertCompositeAnd) program.getSpecification();

        // then
        assertEquals(ASSERT_TYPE_FORALL, ast.getType());

        AssertBasic ast1 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getLeft();
        AssertBasic ast2 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getRight();
        AssertBasic ast3 = (AssertBasic) ast.getRight();

        IntegerType int64 = TYPE_FACTORY.getIntegerType(64);

        assertEquals(EXPR_FACTORY.makeValue(1, int64), ast1.getLeft());
        assertEquals(EXPR_FACTORY.makeValue(2, int64), ast2.getLeft());
        assertEquals(EXPR_FACTORY.makeValue(3, int64), ast3.getLeft());

        assertEquals("%v4[0][0]", ((Location) ast1.getRight()).getName());
        assertEquals("%v4[0][1]", ((Location) ast2.getRight()).getName());
        assertEquals("%v4[1][0]", ((Location) ast3.getRight()).getName());

        assertEquals(0, ((Location) ast1.getRight()).getOffset());
        assertEquals(8, ((Location) ast2.getRight()).getOffset());
        assertEquals(16, ((Location) ast3.getRight()).getOffset());
    }

    @Test
    public void testAssertionAndOr() {
        // given
        String input = """
                ; @Output: forall %v1==1 and %v2==2 or %v3==3
                """;

        // when
        Program program = localParse(input + spvBody);
        AssertCompositeOr ast = (AssertCompositeOr) program.getSpecification();

        // then
        assertEquals(ASSERT_TYPE_FORALL, ast.getType());

        AssertBasic ast1 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getLeft();
        AssertBasic ast2 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getRight();
        AssertBasic ast3 = (AssertBasic) ast.getRight();

        IntegerType int64 = TYPE_FACTORY.getIntegerType(64);

        assertEquals(EXPR_FACTORY.makeValue(1, int64), ast1.getRight());
        assertEquals(EXPR_FACTORY.makeValue(2, int64), ast2.getRight());
        assertEquals(EXPR_FACTORY.makeValue(3, int64), ast3.getRight());

        assertEquals("%v1", ((Location) ast1.getLeft()).getMemoryObject().getName());
        assertEquals("%v2", ((Location) ast2.getLeft()).getMemoryObject().getName());
        assertEquals("%v3", ((Location) ast3.getLeft()).getMemoryObject().getName());
    }

    @Test
    public void testAssertionBrackets() {
        // given
        String input = """
                ; @Output: forall %v1==1 and (%v2==2 or %v3==3)
                """;

        // when
        Program program = localParse(input + spvBody);
        AssertCompositeAnd ast = (AssertCompositeAnd) program.getSpecification();

        // then
        assertEquals(ASSERT_TYPE_FORALL, ast.getType());

        AssertBasic ast1 = (AssertBasic) ast.getLeft();
        AssertBasic ast2 = (AssertBasic) ((AssertCompositeOr) ast.getRight()).getLeft();
        AssertBasic ast3 = (AssertBasic) ((AssertCompositeOr) ast.getRight()).getRight();

        IntegerType int64 = TYPE_FACTORY.getIntegerType(64);

        assertEquals(EXPR_FACTORY.makeValue(1, int64), ast1.getRight());
        assertEquals(EXPR_FACTORY.makeValue(2, int64), ast2.getRight());
        assertEquals(EXPR_FACTORY.makeValue(3, int64), ast3.getRight());

        assertEquals("%v1", ((Location) ast1.getLeft()).getMemoryObject().getName());
        assertEquals("%v2", ((Location) ast2.getLeft()).getMemoryObject().getName());
        assertEquals("%v3", ((Location) ast3.getLeft()).getMemoryObject().getName());
    }

    @Test
    public void testByteWidth() {
        // given
        String wholeSpv = """
            ; @Input: %v4 = {0, 0, 0}
            ; @Output: forall (%v4[0]==1 and %v4[1]==2 and %v4[2]==3)
                           OpCapability Shader
                    %ext = OpExtInstImport "GLSL.std.450"
                           OpMemoryModel Logical GLSL450
                           OpEntryPoint GLCompute %main "main"
                           OpSource GLSL 450
                   %void = OpTypeVoid
                   %func = OpTypeFunction %void
                 %uint16 = OpTypeInt 16 0
                 %uint32 = OpTypeInt 32 0
                 %uint64 = OpTypeInt 64 0

                     %c0 = OpConstant %uint16 0
                     %c1 = OpConstant %uint32 1
                     %c2 = OpConstant %uint64 2

                 %struct = OpTypeStruct %uint16 %uint32 %uint64
             %ptr_struct = OpTypePointer Uniform %struct
            
               %ptr_uint16 = OpTypePointer Uniform %uint16
               %ptr_uint32 = OpTypePointer Uniform %uint32
               %ptr_uint64 = OpTypePointer Uniform %uint64
              
                    %v4 = OpVariable %ptr_struct Uniform
                   %main = OpFunction %void None %func
                  %label = OpLabel
                    %el0 = OpAccessChain %ptr_uint16 %v4 %c0
                    %el1 = OpAccessChain %ptr_uint32 %v4 %c1
                    %el2 = OpAccessChain %ptr_uint64 %v4 %c2
                           OpStore %el0 %c0
                           OpStore %el1 %c1
                           OpStore %el2 %c2
                           OpReturn
                           OpFunctionEnd
                 """;
        // when
        Program program = localParse(wholeSpv);
        AssertCompositeAnd ast = (AssertCompositeAnd) program.getSpecification();

        // then
        assertEquals(ASSERT_TYPE_FORALL, ast.getType());

        AssertBasic ast1 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getLeft();
        AssertBasic ast2 = (AssertBasic) ((AssertCompositeAnd) ast.getLeft()).getRight();
        AssertBasic ast3 = (AssertBasic) ast.getRight();

        IntegerType int64 = TYPE_FACTORY.getIntegerType(64);

        assertEquals(EXPR_FACTORY.makeValue(1, int64), ast1.getRight());
        assertEquals(EXPR_FACTORY.makeValue(2, int64), ast2.getRight());
        assertEquals(EXPR_FACTORY.makeValue(3, int64), ast3.getRight());

        assertEquals("%v4[0]", ((Location) ast1.getLeft()).getName());
        assertEquals("%v4[1]", ((Location) ast2.getLeft()).getName());
        assertEquals("%v4[2]", ((Location) ast3.getLeft()).getName());

        assertEquals(0, ((Location) ast1.getLeft()).getOffset());
        assertEquals(2, ((Location) ast2.getLeft()).getOffset());
        assertEquals(6, ((Location) ast3.getLeft()).getOffset());
    }

    @Test
    public void testIllegalVectorIndex() {
        doTestIllegalVectorIndex("%var[0][0][0]==0",
                "Illegal assertion for variable '%var', index too deep");
        doTestIllegalVectorIndex("%var[0]==0", "Illegal assertion for variable '%var', index not deep enough");
        doTestIllegalVectorIndex("%var[1][0]==0", "Illegal assertion for variable '%var', index out of bounds");
        doTestIllegalVectorIndex("%var[0][1]==0", "Illegal assertion for variable '%var', index out of bounds");
    }

    private void doTestIllegalVectorIndex(String ast, String error) {
        String input = """
        ; @Input: %var = {{0}}
        ; @Output: forall (<<ast>>)
                       OpCapability Shader
                %ext = OpExtInstImport "GLSL.std.450"
                       OpMemoryModel Logical GLSL450
                       OpEntryPoint GLCompute %main "main"
                       OpSource GLSL 450
               %void = OpTypeVoid
               %func = OpTypeFunction %void
             %uint64 = OpTypeInt 64 0
            %v1_type = OpTypeVector %uint64 1
            %v2_type = OpTypeVector %v1_type 1
           %ptr_type = OpTypePointer Uniform %v2_type
                %var = OpVariable %ptr_type Uniform
               %main = OpFunction %void None %func
              %label = OpLabel
                       OpReturn
                       OpFunctionEnd
             """.replace("<<ast>>", ast);

        try {
            // when
            localParse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals(error, e.getMessage());
        }
    }

    private Program localParse(String wholeSpv) {
        ParserSpirv parser = new ParserSpirv();
        CharStream charStream = CharStreams.fromString(wholeSpv);
        return parser.parse(charStream);
    }
}
