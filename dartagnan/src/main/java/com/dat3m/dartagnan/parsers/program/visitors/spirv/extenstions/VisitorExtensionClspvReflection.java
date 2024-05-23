package com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.ProgramBuilderSpv;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.List;
import java.util.Set;

public class VisitorExtensionClspvReflection extends VisitorExtension<Void> {

    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();

    private final ProgramBuilderSpv builder;
    private final List<Integer> threadGrid;
    private MemoryObject pushConstant;
    private AggregateType pushConstantType;
    private int pushConstantIndex = 0;
    private int pushConstantOffset = 0;

    public VisitorExtensionClspvReflection(ProgramBuilderSpv builder) {
        this.builder = builder;
        this.threadGrid = builder.getThreadGrid();
    }

    @Override
    public Set<String> getSupportedInstructions() {
        return Set.of(
                "Kernel",
                "ArgumentInfo",
                "ArgumentStorageBuffer",
                "ArgumentWorkgroup",
                "ArgumentPodPushConstant",
                "PushConstantGlobalOffset",
                "PushConstantGlobalSize",
                "PushConstantEnqueuedLocalSize",
                "PushConstantNumWorkgroups",
                "PushConstantRegionOffset",
                "PushConstantRegionGroupOffset",
                "SpecConstantWorkgroupSize"
        );
    }

    @Override
    public Void visitKernel(SpirvParser.KernelContext ctx) {
        // Do nothing, kernel name and the number of argument
        return null;
    }

    @Override
    public Void visitArgumentInfo(SpirvParser.ArgumentInfoContext ctx) {
        // Do nothing, variable name in OpenCL
        return null;
    }

    @Override
    public Void visitArgumentStorageBuffer(SpirvParser.ArgumentStorageBufferContext ctx) {
        // Do nothing, variable index in OpenCL and Spir-V and descriptor set
        return null;
    }

    @Override
    public Void visitArgumentWorkgroup(SpirvParser.ArgumentWorkgroupContext ctx) {
        // Do nothing, default size of workgroup buffer defined in spec constant
        return null;
    }

    @Override
    public Void visitSpecConstantWorkgroupSize(SpirvParser.SpecConstantWorkgroupSizeContext ctx) {
        // Do nothing, will be overwritten but BuiltIn WorkgroupSize
        return null;
    }

    @Override
    public Void visitArgumentPodPushConstant(SpirvParser.ArgumentPodPushConstantContext ctx) {
        initPushConstant();
        if (pushConstantIndex >= pushConstantType.getDirectFields().size()) {
            throw new ParsingException("Out of bounds definition 'ArgumentPodPushConstant' in PushConstant '%s'", pushConstant.getName());
        }
        Type type = pushConstantType.getDirectFields().get(pushConstantIndex);
        int typeSize = TYPE_FACTORY.getMemorySizeInBytes(type);
        if (type instanceof AggregateType aType) {
            // TODO: Replace with getMemorySizeInBytes for aggregate type after offset is fixed in TypeFactory
            typeSize = aType.getDirectFields().stream()
                    .map(TYPE_FACTORY::getMemorySizeInBytes)
                    .reduce(0, Integer::sum);
        }
        String sizeId = ctx.sizeIdRef().getText();
        if (typeSize != builder.getExpressionAsConstInteger(sizeId)) {
            throw new ParsingException("Unexpected offset in PushConstant '%s' element '%s'",
                    pushConstant.getName(), pushConstantIndex);
        }
        pushConstantOffset += TYPE_FACTORY.getMemorySizeInBytes(type);
        pushConstantIndex++;
        return null;
    }

    @Override
    public Void visitPushConstantGlobalOffset(SpirvParser.PushConstantGlobalOffsetContext ctx) {
        return setPushConstantValue("PushConstantGlobalOffset", ctx.sizeIdRef().getText());
    }

    @Override
    public Void visitPushConstantGlobalSize(SpirvParser.PushConstantGlobalSizeContext ctx) {
        return setPushConstantValue("PushConstantGlobalSize", ctx.sizeIdRef().getText());
    }

    @Override
    public Void visitPushConstantEnqueuedLocalSize(SpirvParser.PushConstantEnqueuedLocalSizeContext ctx) {
        return setPushConstantValue("PushConstantEnqueuedLocalSize", ctx.sizeIdRef().getText());
    }

    @Override
    public Void visitPushConstantNumWorkgroups(SpirvParser.PushConstantNumWorkgroupsContext ctx) {
        return setPushConstantValue("PushConstantNumWorkgroups", ctx.sizeIdRef().getText());
    }

    @Override
    public Void visitPushConstantRegionOffset(SpirvParser.PushConstantRegionOffsetContext ctx) {
        return setPushConstantValue("PushConstantRegionOffset", ctx.sizeIdRef().getText());
    }

    @Override
    public Void visitPushConstantRegionGroupOffset(SpirvParser.PushConstantRegionGroupOffsetContext ctx) {
        return setPushConstantValue("PushConstantRegionGroupOffset", ctx.sizeIdRef().getText());
    }

    // TODO: Better way to identify PushConstant using kernel and arg info
    private void initPushConstant() {
        if (pushConstant == null) {
            List<MemoryObject> variables = builder.getVariablesWithStorageClass(Tag.Spirv.SC_PUSH_CONSTANT);
            if (variables.size() != 1) {
                throw new ParsingException("Cannot identify PushConstant referenced by CLSPV extension");
            }
            pushConstant = variables.get(0);
            Type type = builder.getVariableType(pushConstant.getName());
            if (type instanceof AggregateType agType) {
                pushConstantType = agType;
            } else {
                throw new ParsingException("Unexpected type '%s' for PushConstant '%s'",
                        type, pushConstant.getName());
            }
        }
    }

    private Void setPushConstantValue(String decorationId, String sizeId) {
        initPushConstant();
        if (pushConstantIndex >= pushConstantType.getDirectFields().size()) {
            throw new ParsingException("Out of bounds definition '%s' in PushConstant '%s'", decorationId, pushConstant.getName());
        }
        Type type = pushConstantType.getDirectFields().get(pushConstantIndex);
        int typeSize = TYPE_FACTORY.getMemorySizeInBytes(type);
        int parsedSize = builder.getExpressionAsConstInteger(sizeId);
        if (type instanceof ArrayType aType && aType.getNumElements() == 3 && typeSize == parsedSize) {
            Type elType = aType.getElementType();
            if (elType instanceof IntegerType iType) {
                List<Integer> values = getPushConstantValue(decorationId);
                int localOffset = 0;
                for (int value : values) {
                    Expression elExpr = ExpressionFactory.getInstance().makeValue(value, iType);
                    pushConstant.setInitialValue(pushConstantOffset + localOffset, elExpr);
                    localOffset += TYPE_FACTORY.getMemorySizeInBytes(elExpr.getType());
                }
                pushConstantOffset += localOffset;
                pushConstantIndex++;
                return null;
            }
        }
        throw new ParsingException("Unexpected element type in '%s' at index %s",
                pushConstant.getName(), pushConstantIndex);
    }

    public List<Integer> getPushConstantValue(String command) {
        return switch (command) {
            case "PushConstantGlobalSize" -> List.of(threadGrid.get(0) * threadGrid.get(1) * threadGrid.get(2), 1, 1);
            case "PushConstantEnqueuedLocalSize" -> List.of(threadGrid.get(0) * threadGrid.get(1), 1, 1);
            case "PushConstantNumWorkgroups" -> List.of(threadGrid.get(2), 1, 1);
            case "PushConstantGlobalOffset",
                    "PushConstantRegionOffset",
                    "PushConstantRegionGroupOffset"
                    -> List.of(0, 0, 0);
            default -> throw new ParsingException("Unsupported PushConstant command '%s'", command);
        };
    }
}
