package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

import java.util.HashMap;
import java.util.Map;

/**
 * Collects source-level variable names from clspv reflection metadata and associates them with SPIR-V variables.
 */
public final class VisitorClspvVariableNames extends SpirvBaseVisitor<Void> {

    private final ProgramBuilder builder;
    private final Map<String, String> strings = new HashMap<>();
    private final Map<String, String> constantValues = new HashMap<>();
    private final Map<String, String> descriptorSets = new HashMap<>();
    private final Map<String, String> bindings = new HashMap<>();
    private final Map<String, String> argumentNames = new HashMap<>();

    public VisitorClspvVariableNames(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Void visitOpString(SpirvParser.OpStringContext ctx) {
        strings.put(ctx.idResult().getText(), removeSurroundingQuotes(ctx.string().getText()));
        return null;
    }

    @Override
    public Void visitOpConstant(SpirvParser.OpConstantContext ctx) {
        constantValues.put(ctx.idResult().getText(), ctx.valueLiteralContextDependentNumber().getText());
        return null;
    }

    @Override
    public Void visitOpDecorate(SpirvParser.OpDecorateContext ctx) {
        String id = ctx.targetIdRef().getText();
        SpirvParser.DecorationContext decoration = ctx.decoration();
        if (decoration.Binding() != null) {
            bindings.put(id, decoration.bindingPoint().getText());
        } else if (decoration.DescriptorSet() != null) {
            descriptorSets.put(id, decoration.descriptorSetLiteralInteger().getText());
        }
        return null;
    }

    @Override
    public Void visitOpExtInst(SpirvParser.OpExtInstContext ctx) {
        final SpirvParser.ClspvReflectionContext reflection =
                ctx.instruction().literalExtInstInteger().clspvReflection();
        if (reflection == null) {
            return null;
        }

        final SpirvParser.ClspvReflection_argumentInfoContext argumentInfo =
                reflection.clspvReflection_argumentInfo();
        if (argumentInfo != null) {
            argumentNames.put(ctx.idResult().getText(), strings.get(argumentInfo.nameIdRef().getText()));
            return null;
        }

        final SpirvParser.ClspvReflection_argumentStorageBufferContext argument =
                reflection.clspvReflection_argumentStorageBuffer();
        if (argument != null && argument.argInfo() != null) {
            registerSourceName(argument);
        }
        return null;
    }

    private void registerSourceName(SpirvParser.ClspvReflection_argumentStorageBufferContext argument) {
        final String descriptorSet = constantValues.get(argument.descriptorSetIdRef().getText());
        final String binding = constantValues.get(argument.binding().getText());
        final String sourceName = argumentNames.get(argument.argInfo().getText());
        if (descriptorSet == null || binding == null || sourceName == null) {
            return;
        }

        for (Map.Entry<String, String> entry : bindings.entrySet()) {
            if (binding.equals(entry.getValue()) && descriptorSet.equals(descriptorSets.get(entry.getKey()))) {
                builder.addVariableSourceName(entry.getKey(), sourceName);
            }
        }
    }

    private static String removeSurroundingQuotes(String stringLiteral) {
        return stringLiteral.substring(1, stringLiteral.length() - 1);
    }
}
