package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

import java.util.Set;

public class VisitorOpsSetting extends SpirvBaseVisitor<Void> {

    private final ProgramBuilder builder;

    public VisitorOpsSetting(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Void visitOpMemoryModel(SpirvParser.OpMemoryModelContext ctx) {
        builder.setArch(parseArch(ctx.memoryModel().getText()));
        return null;
    }

    @Override
    public Void visitOpEntryPoint(SpirvParser.OpEntryPointContext ctx) {
        builder.setEntryPointId(ctx.entryPoint().getText());
        return null;
    }

    private Arch parseArch(String memoryModel) {
        return switch (memoryModel) {
            case "Vulkan", "VulkanKHR" -> Arch.VULKAN;
            case "OpenCL" -> Arch.OPENCL;
            case "GLSL450", "Simple" -> throw new ParsingException("Unsupported memory model '%s'", memoryModel);
            default -> throw new ParsingException("Illegal memory model '%s'", memoryModel);
        };
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpCapability",
                "OpMemoryModel",
                "OpEntryPoint",
                "OpExecutionMode",
                "OpExecutionModeId"
        );
    }
}
