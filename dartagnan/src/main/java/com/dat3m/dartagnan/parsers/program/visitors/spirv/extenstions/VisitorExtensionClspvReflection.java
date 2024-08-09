package com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.utils.ThreadGrid;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import com.dat3m.dartagnan.program.event.Tag;

import java.util.List;
import java.util.Set;

public class VisitorExtensionClspvReflection extends VisitorExtension<Void> {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final ProgramBuilder builder;
    private ScopedPointerVariable pushConstant;
    private AggregateType pushConstantType;
    private int pushConstantIndex = 0;
    private int pushConstantOffset = 0;

    public VisitorExtensionClspvReflection(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Void visitKernel(SpirvParser.KernelContext ctx) {
        // Do nothing, kernel name and the number of arguments
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
        // Do nothing, will be overwritten by BuiltIn WorkgroupSize
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

    @Override
    public Void visitArgumentPodPushConstant(SpirvParser.ArgumentPodPushConstantContext ctx) {
        initPushConstant();
        if (pushConstantIndex >= pushConstantType.getDirectFields().size()) {
            throw new ParsingException("Out of bounds definition 'ArgumentPodPushConstant' in PushConstant '%s'",
                    pushConstant.getId());
        }
        Type type = pushConstantType.getDirectFields().get(pushConstantIndex);
        int typeSize = types.getMemorySizeInBytes(type);
        if (typeSize != getExpressionAsConstInteger(ctx.sizeIdRef().getText())) {
            throw new ParsingException("Unexpected offset in PushConstant '%s' element '%s'",
                    pushConstant.getId(), pushConstantIndex);
        }
        pushConstantOffset += typeSize;
        pushConstantIndex++;
        return null;
    }

    private Void setPushConstantValue(String decorationId, String sizeId) {
        initPushConstant();
        if (pushConstantIndex >= pushConstantType.getDirectFields().size()) {
            throw new ParsingException("Out of bounds definition '%s' in PushConstant '%s'",
                    decorationId, pushConstant.getId());
        }
        Type type = pushConstantType.getDirectFields().get(pushConstantIndex);
        int typeSize = types.getMemorySizeInBytes(type);
        int expectedSize = getExpressionAsConstInteger(sizeId);
        if (type instanceof ArrayType aType && aType.getNumElements() == 3 && typeSize == expectedSize) {
            Type elType = aType.getElementType();
            if (elType instanceof IntegerType iType) {
                List<Integer> values = computePushConstantValue(decorationId);
                int localOffset = 0;
                for (int value : values) {
                    Expression elExpr = expressions.makeValue(value, iType);
                    pushConstant.setInitialValue(pushConstantOffset + localOffset, elExpr);
                    localOffset += types.getMemorySizeInBytes(elExpr.getType());
                }
                pushConstantOffset += localOffset;
                pushConstantIndex++;
                return null;
            }
        }
        throw new ParsingException("Unexpected element type in '%s' at index %s",
                pushConstant.getId(), pushConstantIndex);
    }

    private List<Integer> computePushConstantValue(String command) {
        ThreadGrid grid = builder.getThreadGrid();
        return switch (command) {
            case "PushConstantGlobalSize" -> List.of(grid.dvSize(), 1, 1);
            case "PushConstantEnqueuedLocalSize" -> List.of(grid.wgSize(), 1, 1);
            case "PushConstantNumWorkgroups" -> List.of(grid.qfSize() / grid.wgSize(), 1, 1);
            case "PushConstantGlobalOffset",
                    "PushConstantRegionOffset",
                    "PushConstantRegionGroupOffset"
                    -> List.of(0, 0, 0);
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
