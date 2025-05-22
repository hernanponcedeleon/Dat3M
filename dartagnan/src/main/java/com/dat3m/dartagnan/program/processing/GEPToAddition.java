package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.misc.GEPExpr;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.List;

/*
    Replaces GEP expressions by plain pointer arithmetic according to
    https://llvm.org/docs/LangRef.html#getelementptr-instruction

    WARNING:
    (1) Our GEPs have no attributes but LLVM's have.
        For attributed GEPs, the semantics may mismatch.
    (2) LLVM's LangRef has a strange special rule that we have not implemented:
       """
       The offsets are then added to the low bits of the base address up to the index type width,
       with silently-wrapping two’s complement arithmetic.
       If the pointer size is larger than the index size, this means that the bits outside
       the index type width will not be affected.
       """
       This rule says that only the lower bits of pointers are affected by GEP additions,
       if the index type is smaller than the pointer type.

    NOTE:
    This replacement might also match with SPIRV's OpAccessChain:
    https://registry.khronos.org/SPIR-V/specs/unified1/SPIRV.html#OpAccessChain
    However, the documentation of SPIRV's operation is unclear.
*/
public class GEPToAddition implements ProgramProcessor {

    private GEPToAddition() {}

    public static GEPToAddition newInstance() {
        return new GEPToAddition();
    }

    @Override
    public void run(Program program) {
        final var transformer = new GEPToAdditionTransformer();
        for (Function function : program.getFunctions()) {
            for (RegReader reader : function.getEvents(RegReader.class)) {
                reader.transformExpressions(transformer);
            }
        }

        for (MemoryObject memoryObject : program.getMemory().getObjects()) {
            for (int field : memoryObject.getInitializedFields()) {
                memoryObject.setInitialValue(field, memoryObject.getInitialValue(field).accept(transformer));
            }
        }
    }

    private static final class GEPToAdditionTransformer extends ExprTransformer {

        @Override
        public Expression visitGEPExpression(GEPExpr gep) {
            final List<Expression> indices = gep.getOffsets();
            final IntegerType offsetType = (IntegerType) indices.get(0).getType();
            final Integer baseStride = gep.getStride();
            Type indexingType = gep.getIndexingType();

            final int baseSize = baseStride != null ? baseStride : types.getMemorySizeInBytes(indexingType);
            Expression totalOffset = expressions.makeMul(expressions.makeValue(baseSize, offsetType), indices.get(0));

            for (Expression index : indices.subList(1, indices.size())) {
                Expression offset;
                if (indexingType instanceof AggregateType aggType && index instanceof IntLiteral lit) {
                    final int intIndex = lit.getValueAsInt();
                    final int intOffset = types.getOffsetInBytes(aggType, intIndex);
                    offset = expressions.makeValue(intOffset, offsetType);
                    indexingType = aggType.getFields().get(intIndex).type();
                } else if (indexingType instanceof ArrayType arrayType) {
                    Integer stride = arrayType.getStride();
                    final int elSize = stride != null ? stride : types.getMemorySizeInBytes(arrayType.getElementType());
                    final Expression scaling = expressions.makeValue(elSize, offsetType);
                    final Expression castIndex = expressions.makeCast(index, offsetType, true);
                    offset = expressions.makeMul(scaling, castIndex);
                    indexingType = arrayType.getElementType();
                } else {
                    final String error = String.format("Invalid GEP indexing: Type %s, index %s", indexingType, index);
                    throw new MalformedProgramException(error);
                }
                totalOffset = expressions.makeAdd(totalOffset, offset);
            }

            final Expression base = gep.getBase().accept(this);
            final Expression castOffset = expressions.makeCast(totalOffset, base.getType(), true);
            return expressions.makeAdd(base, castOffset);
        }
    }
}
