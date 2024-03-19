package com.dat3m.dartagnan.spirv;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.program.ParserSpirv;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.specification.AssertBasic;
import com.dat3m.dartagnan.program.specification.AssertCompositeAnd;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.junit.Assume;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static java.util.Map.entry;
import static org.junit.Assert.fail;

@RunWith(Parameterized.class)
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
    private enum TestType {VALID_FORMAT, INVALID_FORMAT, VALUE, SPEC, COMPLEX}
    private final TestType type;
    private final String wholeSpv;
    private final String msg;
    private final Map<String, String> values;

    public SpirvHeaderTest(TestType type, String header, String msg, Map<String, String> values) {
        this.type = type;
        this.wholeSpv = header + spvBody;
        this.msg = msg;
        this.values = values;
    }

    @Parameterized.Parameters()
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {TestType.VALID_FORMAT,
                        """
                ; @Input:
                ; @Output: forall (0)
                ; @Config: 1, 1, 1
                """,
                        "Empty input should not have thrown any exception", new HashMap<>()},
                {TestType.VALID_FORMAT,
                        """
                ; @Output: forall (0)
                ; @Config: 1, 1, 1
                """,
                        "Missing input should not have thrown any exception", new HashMap<>()},
                {TestType.VALID_FORMAT,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output:
                ; @Config: 1, 1, 1
                """,
                        "Empty output should not have thrown any exception", new HashMap<>()},
                {TestType.VALID_FORMAT,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Config: 1, 1, 1
                """,
                        "Missing output should not have thrown any exception", new HashMap<>()},
                {TestType.VALID_FORMAT,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (0)
                """,
                        "Missing config should not have thrown any exception", new HashMap<>()},
                {TestType.VALID_FORMAT,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (0)
                """,
                        "Missing header should not have thrown any exception", new HashMap<>()},
                {TestType.INVALID_FORMAT,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Input: %v1=7
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "Duplicated definition '%v1'", new HashMap<>()},
                {TestType.INVALID_FORMAT,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v4!=456)
                ; @Config: 1, 1, 1
                """,
                        "Undefined memory object '%v4'", new HashMap<>()},
                {TestType.INVALID_FORMAT,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1!=7)
                ; @Output: not exists (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "Existential assertions can not be used in conjunction with other assertions", new HashMap<>()},
                {TestType.INVALID_FORMAT,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1!=7)
                ; @Output: forall (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "Existential assertions can not be used in conjunction with other assertions", new HashMap<>()},
                {TestType.INVALID_FORMAT,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1!=7)
                ; @Output: exists (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "Existential assertions can not be used in conjunction with other assertions", new HashMap<>()},
                {TestType.INVALID_FORMAT,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (0)
                ; @Config: 1, 1, 0
                """,
                        "Thread grid dimensions must be positive", new HashMap<>()},
                {TestType.INVALID_FORMAT,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (0)
                ; @Config: 100, 100, 100
                """,
                        "Thread grid dimensions must be less than 128", new HashMap<>()},
                {TestType.INVALID_FORMAT,
                        """
                ; @Input:
                ; @Output: forall (0)
                ; @Config: 1, 1, 1
                ; @Config: 1, 1, 1
                """,
                        "Thread grid is set multiple times", new HashMap<>()},

                {TestType.VALUE,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "",
                        Map.ofEntries(
                                entry("%v1", "bv64(7)"),
                                entry("%v2", "bv64(123)"),
                                entry("%v3", "bv64(0)")
                        )},
                {TestType.VALUE,
                        """
                ; @   Input   : %v1=7, %v2=123, %v3=0
                ; @  Output : forall (%v1==7 and %v2==123 and %v3==0)
                ;       @ Config : 1, 1, 1
                """,
                        "",
                        Map.ofEntries(
                                entry("%v1", "bv64(7)"),
                                entry("%v2", "bv64(123)"),
                                entry("%v3", "bv64(0)")
                        )},
                {TestType.VALUE,
                        """
                ; @Config: 1, 1, 1
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; @Input: %v1=7, %v2=123, %v3=0
                """,
                        "",
                        Map.ofEntries(
                                entry("%v1", "bv64(7)"),
                                entry("%v2", "bv64(123)"),
                                entry("%v3", "bv64(0)")
                        )},
                {TestType.VALUE,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; SPIR-V
                ; Version: 1.0
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; Schema: 0
                ; @Config: 1, 1, 1
                """,
                        "",
                        Map.ofEntries(
                                entry("%v1", "bv64(7)"),
                                entry("%v2", "bv64(123)"),
                                entry("%v3", "bv64(0)")
                        )},
                {TestType.VALUE,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0, %v4 = {11, 22, 33}
                ; @Output: forall (%v1==7 and %v4[0]==0 and %v4[1]==0 and %v4[2]==0)
                ; @Config: 1, 1, 1
                """,
                        "",
                        Map.ofEntries(
                                entry("%v1", "bv64(7)"),
                                entry("%v2", "bv64(123)"),
                                entry("%v3", "bv64(0)"),
                                entry("%v4", "0: bv64(11), 8: bv64(22), 16: bv64(33)")
                        )},
                {TestType.VALUE,
                        """
                ; @Input: %v1=7
                ; @Input: %v2=123, %v3=0
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "",
                        Map.ofEntries(
                                entry("%v1", "bv64(7)"),
                                entry("%v2", "bv64(123)"),
                                entry("%v3", "bv64(0)")
                        )},
                {TestType.SPEC,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "exists:%v1==bv64(7) && %v2==bv64(123) && %v3==bv64(0)", new HashMap<>()},
                {TestType.SPEC,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: not exists (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "not exists:%v1==bv64(7) && %v2==bv64(123) && %v3==bv64(0)", new HashMap<>()},
                {TestType.SPEC,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (%v1==7)
                ; @Output: forall (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "forall:%v1==bv64(7) && %v2==bv64(123) && %v3==bv64(0)", new HashMap<>()},
                {TestType.SPEC,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (%v1==7)
                ; @Output: not exists (%v2!=123 or %v3!=0)
                ; @Config: 1, 1, 1
                """,
                        "forall:%v1==bv64(7) && !%v2!=bv64(123) && !%v3!=bv64(0)", new HashMap<>()},
                {TestType.SPEC,
                        """
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: not exists (%v1!=7)
                ; @Output: not exists (%v2!=123 or %v3!=0)
                ; @Config: 1, 1, 1
                """,
                        "forall:!%v1!=bv64(7) && !%v2!=bv64(123) && !%v3!=bv64(0)", new HashMap<>()},
                {TestType.COMPLEX, "", "", new HashMap<>()},
        });
    }

    @Test
    public void testValidFormatHeader() {
        Assume.assumeTrue(type == TestType.VALID_FORMAT);
        try {
            parse();
        } catch (Exception e) {
            fail(msg);
        }
    }

    @Test
    public void testInvalidFormatHeader() {
        Assume.assumeTrue(type == TestType.INVALID_FORMAT);
        try {
            parse();
        } catch (Exception e) {
            assert (e.getMessage().equals(msg));
        }
    }

    @Test
    public void testValueHeader() {
        Assume.assumeTrue(type == TestType.VALUE);
        try {
            Program program = parse();
            for (Map.Entry<String, String> entry : values.entrySet()) {
                Optional<MemoryObject> v = program.getMemory().getObjects().stream().filter(o -> o.getCVar().equals(entry.getKey())).findFirst();
                if (entry.getValue().contains(",")) {
                    String[] values = Arrays.stream(entry.getValue().split(","))
                            .map(String::trim)
                            .toArray(String[]::new);
                    assert (v.isPresent());
                    for (String s : values) {
                        String[] offsetAndValue = s.split(":");
                        assert v.get().getInitialValue(Integer.parseInt(offsetAndValue[0])).toString().equals(offsetAndValue[1].trim());
                    }
                } else {
                    assert (v.isPresent());
                    assert (v.get().getInitialValue(0).toString().equals(entry.getValue()));
                }
            }
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test
    public void testSpecHeader() {
        Assume.assumeTrue(type == TestType.SPEC);
        try {
            Program program = parse();
            String[] msgSplit = msg.split(":");
            String specType = msgSplit[0];
            String spec = msgSplit[1];
            assert (program.getSpecification().toString().equals(spec));
            assert (program.getSpecification().getType().equals(specType));
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test
    public void testComplexSpecHeader() {
        Assume.assumeTrue(type == TestType.COMPLEX);
        String header = """
                ; @ Input: %v3v = {77, 88, 99}
                ; @ Output: forall (%v3v[0]==77 and %v3v[1]==88 and %v3v[2]==99)
                ; @ Config: 1, 1, 1
                """;
        Program program = parseComplex(header);
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
        int byteWidth = e1.getMemoryObject().getType().getBitWidth() / 8;
        assert (e1.getName().equals("%v3v"));
        assert (e1.getOffset() / byteWidth == 0);
        assert (v1.toString().equals("bv64(77)"));
        assert (e2.getName().equals("%v3v"));
        assert (e2.getOffset() / byteWidth == 1);
        assert (v2.toString().equals("bv64(88)"));
        assert (e3.getName().equals("%v3v"));
        assert (e3.getOffset() / byteWidth == 2);
        assert (v3.toString().equals("bv64(99)"));
    }

    @Test
    public void testComplexSpecHeader1() {
        Assume.assumeTrue(type == TestType.COMPLEX);
        String header = """
                ; @ Input: %v3v = {77, 88, 99}
                ; @ Output: forall (%v3v[0]==77 and %v3v[256]==88 and %v3v[1000]==99)
                ; @ Config: 1, 1, 1
                """;
        Program program = parseComplex(header);
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
        int byteWidth = e1.getMemoryObject().getType().getBitWidth() / 8;
        assert (e1.getName().equals("%v3v"));
        assert (e1.getOffset() / byteWidth == 0);
        assert (v1.toString().equals("bv64(77)"));
        assert (e2.getName().equals("%v3v"));
        assert (e2.getOffset() / byteWidth == 256);
        assert (v2.toString().equals("bv64(88)"));
        assert (e3.getName().equals("%v3v"));
        assert (e3.getOffset() / byteWidth == 1000);
        assert (v3.toString().equals("bv64(99)"));
    }

    private Program parse() {
        ParserSpirv parser = new ParserSpirv();
        CharStream charStream = CharStreams.fromString(wholeSpv);
        return parser.parse(charStream);
    }

    private Program parseComplex(String header) {
        String wholeSpv = header + spvBody;
        ParserSpirv parser = new ParserSpirv();
        CharStream charStream = CharStreams.fromString(wholeSpv);
        return parser.parse(charStream);
    }
}
