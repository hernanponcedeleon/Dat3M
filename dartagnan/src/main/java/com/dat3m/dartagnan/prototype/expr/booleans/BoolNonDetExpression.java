package com.dat3m.dartagnan.prototype.expr.booleans;

import com.dat3m.dartagnan.prototype.expr.Constant;
import com.dat3m.dartagnan.prototype.expr.ExpressionKind;
import com.dat3m.dartagnan.prototype.expr.ExpressionVisitor;
import com.dat3m.dartagnan.prototype.expr.helper.LeafExpressionBase;
import com.dat3m.dartagnan.prototype.expr.types.BooleanType;

import java.util.HashMap;
import java.util.Map;

/*
    TODO: The identifier may not be needed if we can make sure to never copy instances of IntNonDet and instead
     reuse existing ones. To determine this, we need to check existing and potential use-cases.
 */
public class BoolNonDetExpression extends LeafExpressionBase<BooleanType, ExpressionKind.Leaf> implements Constant {

    private static int nextId = 0;
    private static final Map<Integer, BoolNonDetExpression> nonDetInstanceMap = new HashMap<>();

    private final int identifier;

    protected BoolNonDetExpression(int identifier) {
        super(BooleanType.get(), ExpressionKind.Leaf.NONDET);
        this.identifier = identifier;
    }

    public static BoolNonDetExpression create(int identifier) {
        return nonDetInstanceMap.computeIfAbsent(identifier, BoolNonDetExpression::new);
    }

    public static BoolNonDetExpression create() {
        return create(nextId++);
    }

    public int getIdentifier() { return identifier; }

    @Override
    public int hashCode() {
        return identifier;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != this.getClass()) {
            return false;
        }

        final BoolNonDetExpression nonDet = (BoolNonDetExpression) obj;
        return nonDet.identifier == this.identifier;
    }


    @Override
    public String toString() { return String.format("nondet_%s_%d", type, identifier); }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) { return visitor.visitBoolNonDetExpression(this); }
}
