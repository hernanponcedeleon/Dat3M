package com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.program.ThreadGrid;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;

import java.util.List;
import java.util.Set;

public class VisitorExtensionClspvReflection extends VisitorExtension<Void> {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final ProgramBuilder builder;
    private ScopedPointerVariable pushConstant;
    private AggregateType pushConstantType;

    public VisitorExtensionClspvReflection(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Void visitClspvReflection_kernel(SpirvParser.ClspvReflection_kernelContext ctx) {
        // Do nothing, kernel name and the number of arguments
        return null;
    }

    @Override
    public Void visitClspvReflection_argumentInfo(SpirvParser.ClspvReflection_argumentInfoContext ctx) {
        // Do nothing, variable name in OpenCL
        return null;
    }

    @Override
    public Void visitClspvReflection_argumentStorageBuffer(SpirvParser.ClspvReflection_argumentStorageBufferContext ctx) {
        // Do nothing, variable index in OpenCL and Spir-V and descriptor set
        return null;
    }

    @Override
    public Void visitClspvReflection_argumentWorkgroup(SpirvParser.ClspvReflection_argumentWorkgroupContext ctx) {
        // Do nothing, default size of workgroup buffer defined in spec constant
        return null;
    }

    @Override
    public Void visitClspvReflection_specConstantWorkgroupSize(SpirvParser.ClspvReflection_specConstantWorkgroupSizeContext ctx) {
        // Do nothing, will be overwritten by BuiltIn WorkgroupSize
        return null;
    }

    @Override
    public Void visitClspvReflection_pushConstantGlobalOffset(SpirvParser.ClspvReflection_pushConstantGlobalOffsetContext ctx) {
        return setPushConstantValue("PushConstantGlobalOffset", ctx.offsetIdRef().getText(), ctx.sizeIdRef().getText());
    }

    @Override
    public Void visitClspvReflection_pushConstantGlobalSize(SpirvParser.ClspvReflection_pushConstantGlobalSizeContext ctx) {
        return setPushConstantValue("PushConstantGlobalSize", ctx.offsetIdRef().getText(), ctx.sizeIdRef().getText());
    }

    @Override
    public Void visitClspvReflection_pushConstantEnqueuedLocalSize(SpirvParser.ClspvReflection_pushConstantEnqueuedLocalSizeContext ctx) {
        return setPushConstantValue("PushConstantEnqueuedLocalSize", ctx.offsetIdRef().getText(), ctx.sizeIdRef().getText());
    }

    @Override
    public Void visitClspvReflection_pushConstantNumWorkgroups(SpirvParser.ClspvReflection_pushConstantNumWorkgroupsContext ctx) {
        return setPushConstantValue("PushConstantNumWorkgroups", ctx.offsetIdRef().getText(), ctx.sizeIdRef().getText());
    }

    @Override
    public Void visitClspvReflection_pushConstantRegionOffset(SpirvParser.ClspvReflection_pushConstantRegionOffsetContext ctx) {
        return setPushConstantValue("PushConstantRegionOffset", ctx.offsetIdRef().getText(), ctx.sizeIdRef().getText());
    }

    @Override
    public Void visitClspvReflection_pushConstantRegionGroupOffset(SpirvParser.ClspvReflection_pushConstantRegionGroupOffsetContext ctx) {
        return setPushConstantValue("PushConstantRegionGroupOffset", ctx.offsetIdRef().getText(), ctx.sizeIdRef().getText());
    }

    @Override
    public Void visitClspvReflection_argumentPodPushConstant(SpirvParser.ClspvReflection_argumentPodPushConstantContext ctx) {
        initPushConstant();
        int argOffset = getExpressionAsConstInteger(ctx.offsetIdRef().getText());
        int argSize = getExpressionAsConstInteger(ctx.sizeIdRef().getText());
        getTypeOffset("ArgumentPodPushConstant", pushConstantType, argOffset, argSize);
        return null;
    }

    private Void setPushConstantValue(String argument, String offsetId, String sizeId) {
        initPushConstant();
        int argOffset = getExpressionAsConstInteger(offsetId);
        int argSize = getExpressionAsConstInteger(sizeId);
        TypeOffset typeOffset = getTypeOffset(argument, pushConstantType, argOffset, argSize);
        if (typeOffset.type() instanceof ArrayType aType && aType.getNumElements() == 3) {
            Type elType = aType.getElementType();
            if (elType instanceof IntegerType iType) {
                int offset = typeOffset.offset();
                for (int value : computePushConstantValue(argument)) {
                    Expression elExpr = expressions.makeValue(value, iType);
                    pushConstant.setInitialValue(offset, elExpr);
                    offset += types.getMemorySizeInBytes(elExpr.getType());
                }
                return null;
            }
        }
        throw new ParsingException("Argument %s doesn't match the PushConstant type", argument);
    }

    private List<Integer> computePushConstantValue(String command) {
        ThreadGrid grid = builder.getThreadGrid();
        return switch (command) {
            case "PushConstantGlobalSize" -> List.of(grid.getSize(Tag.Vulkan.DEVICE), 1, 1);
            case "PushConstantEnqueuedLocalSize" -> List.of(grid.getSize(Tag.Vulkan.WORK_GROUP), 1, 1);
            case "PushConstantNumWorkgroups" ->
                    List.of(grid.getSize(Tag.Vulkan.QUEUE_FAMILY) / grid.getSize(Tag.Vulkan.WORK_GROUP), 1, 1);
            case "PushConstantGlobalOffset",
                 "PushConstantRegionOffset",
                 "PushConstantRegionGroupOffset" -> List.of(0, 0, 0);
            default -> throw new ParsingException("Unsupported PushConstant command '%s'", command);
        };
    }

    // TODO: Better way to identify PushConstant using kernel and arg info methods
    private void initPushConstant() {
        if (pushConstant == null) {
            List<ScopedPointerVariable> variables = builder.getVariables().stream()
                    .filter(v -> Tag.Spirv.SC_PUSH_CONSTANT.equals(v.getScopeId()))
                    .toList();
            if (variables.size() == 1) {
                pushConstant = variables.get(0);
                Type type = pushConstant.getInnerType();
                if (type instanceof AggregateType agType) {
                    pushConstantType = agType;
                    return;
                }
                throw new ParsingException("Unexpected type '%s' for PushConstant '%s'",
                        type, pushConstant.getId());
            }
            throw new ParsingException("Cannot identify PushConstant referenced by CLSPV extension");
        }
    }

    private int getExpressionAsConstInteger(String id) {
        Expression expression = builder.getExpression(id);
        if (expression instanceof IntLiteral iExpr) {
            return iExpr.getValueAsInt();
        }
        throw new ParsingException("Expression '%s' is not an integer constant", id);
    }

    private TypeOffset getTypeOffset(String argument, AggregateType type, int argOffset, int argSize) {
        TypeOffset lastOffset = null;
        for (TypeOffset typeOffset : type.getFields()) {
            if (argOffset <= typeOffset.offset()) {
                if (argOffset == typeOffset.offset()) {
                    lastOffset = typeOffset;
                }
                break;
            }
            lastOffset = typeOffset;
        }
        if (lastOffset != null) {
            if (argOffset == lastOffset.offset() && argSize == types.getMemorySizeInBytes(lastOffset.type())) {
                return new TypeOffset(lastOffset.type(), lastOffset.offset());
            }
            if (lastOffset.type() instanceof AggregateType aType) {
                TypeOffset subTypeOffset = getTypeOffset(argument, aType, argOffset - lastOffset.offset(), argSize);
                return new TypeOffset(subTypeOffset.type(), lastOffset.offset() + subTypeOffset.offset());
            }
        }
        throw new ParsingException("Argument %s doesn't match the PushConstant type", argument);
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
}
