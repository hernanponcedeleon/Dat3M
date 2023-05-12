package com.dat3m.dartagnan.expr.pointer;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.ExpressionVisitor;
import com.dat3m.dartagnan.expr.Type;
import com.dat3m.dartagnan.expr.helper.ExpressionBase;
import com.dat3m.dartagnan.expr.types.IntegerType;
import com.dat3m.dartagnan.expr.types.PointerType;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;

import java.util.Arrays;
import java.util.List;
import java.util.Objects;

/*
    LLVM GEP Instruction
    Important notes:
        - The computed pointer should point into the memory object associated with the base pointer.
        - The computed pointer may point beyond the size of the indexing type, i.e., the indexing type
          may be different from the actual memory object pointed into!!!

    TODO: Add isInBounds flag as in LLVm
 */
public class GEPExpression extends ExpressionBase<PointerType, ExpressionKind.Pointers> {

    private final Type indexingType;

    protected GEPExpression(Type indexingType, Expression ptr, List<? extends Expression> indices) {
        super(PointerType.get(), ExpressionKind.Pointers.GEP, Lists.asList(ptr, indices.toArray(new Expression[0])));
        this.indexingType = indexingType;
    }

    public static GEPExpression create(Type indexingType, Expression ptr, List<Expression> indices) {
        Preconditions.checkArgument(ptr.getType() == PointerType.get());
        Preconditions.checkArgument(!indices.isEmpty());
        Preconditions.checkArgument(indices.stream().allMatch(offset -> offset.getType() instanceof IntegerType));
        return new GEPExpression(indexingType, ptr, indices);
    }

    public static GEPExpression create(Type indexingType, Expression ptr, Expression... indices) {
        return create(indexingType, ptr, Arrays.asList(indices));
    }

    public Expression getBase() { return getOperands().get(0); }
    public List<? extends Expression> getIndices() { return getOperands().subList(1, getOperands().size()); }

    @Override
    public String toString() {
        return String.format("%s, [%s]",
                indexingType,
                String.join(", ", Lists.transform(getOperands(), Objects::toString))
        );
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) { return visitor.visitGEPExpression(this); }
}
