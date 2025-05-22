package com.dat3m.dartagnan.spirv.header;

import com.dat3m.dartagnan.parsers.program.ParserSpirv;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;

public abstract class AbstractTest {

    protected static final String BODY = """
                            OpCapability Shader
                            OpCapability VulkanMemoryModel
                            OpMemoryModel Logical Vulkan
                            OpEntryPoint GLCompute %main "main"
                            OpSource GLSL 450
                            OpMemberDecorate %struct 0 Offset 0
                            OpMemberDecorate %struct 1 Offset 16
                            OpMemberDecorate %struct_2 0 Offset 0
                            OpMemberDecorate %struct_2 1 Offset 4
                            OpMemberDecorate %struct_2 2 Offset 8
                    %void = OpTypeVoid
                  %uint16 = OpTypeInt 16 0
                  %uint32 = OpTypeInt 32 0
                  %uint64 = OpTypeInt 64 0
                      %c0 = OpConstant %uint64 0
                      %c1 = OpConstant %uint64 1
                      %c2 = OpConstant %uint64 2
                      %c3 = OpConstant %uint64 3
                   %c0_16 = OpConstant %uint16 0
                   %c1_32 = OpConstant %uint32 1
                  %v1uint = OpTypeVector %uint64 1
                  %v3uint = OpTypeVector %uint64 3
                  %a2uint = OpTypeArray %uint64 %c2
                  %a3uint = OpTypeArray %uint64 %c3
                  %struct = OpTypeStruct %a2uint %v1uint
                %struct_2 = OpTypeStruct %uint16 %uint32 %uint64
                %v1v1uint = OpTypeArray %v1uint %c1
              %ptr_uint16 = OpTypePointer Uniform %uint16
              %ptr_uint32 = OpTypePointer Uniform %uint32
              %ptr_uint64 = OpTypePointer Uniform %uint64
              %ptr_v3uint = OpTypePointer Uniform %v3uint
              %ptr_a3uint = OpTypePointer Uniform %a3uint
            %ptr_struct_1 = OpTypePointer Uniform %struct
            %ptr_struct_2 = OpTypePointer Uniform %struct_2
            %ptr_v1v1uint = OpTypePointer Uniform %v1v1uint
                    %func = OpTypeFunction %void
                      %v1 = OpVariable %ptr_uint64 Uniform
                      %v2 = OpVariable %ptr_uint64 Uniform
                      %v3 = OpVariable %ptr_uint64 Uniform
                     %v3v = OpVariable %ptr_v3uint Uniform
                      %v4 = OpVariable %ptr_v3uint Uniform
                      %v5 = OpVariable %ptr_a3uint Uniform
                      %v6 = OpVariable %ptr_struct_1 Uniform
                      %v7 = OpVariable %ptr_struct_2 Uniform
                      %v8 = OpVariable %ptr_v1v1uint Uniform
                    %main = OpFunction %void None %func
                   %label = OpLabel
                            OpReturn
                            OpFunctionEnd
                             """;

    protected Program parse(String header) {
        ParserSpirv parser = new ParserSpirv();
        String data = String.format("%s\n%s", header, BODY);
        CharStream charStream = CharStreams.fromString(data);
        return parser.parse(charStream);
    }
}
