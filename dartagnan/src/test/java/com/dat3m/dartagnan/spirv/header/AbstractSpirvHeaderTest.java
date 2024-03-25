package com.dat3m.dartagnan.spirv.header;

import com.dat3m.dartagnan.parsers.program.ParserSpirv;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

@RunWith(Parameterized.class)
public abstract class AbstractSpirvHeaderTest {
    protected final String spvBody = """
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
    protected final String wholeSpv;

    public AbstractSpirvHeaderTest(String header) {
        this.wholeSpv = header + spvBody;
    }

    protected Program parse() {
        ParserSpirv parser = new ParserSpirv();
        CharStream charStream = CharStreams.fromString(wholeSpv);
        return parser.parse(charStream);
    }
}