package com.dat3m.dartagnan.program.event.lang.spirv;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.StoreBase;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.Spirv.*;

public class SpirvStore extends StoreBase {

    private final String scope;

    public SpirvStore(Expression address, Expression value, String scope, Set<String> tags) {
        super(address, value, getMoTag(tags));
        this.scope = scope;
        addTags(scope);
        addTags(tags);
        validateMemoryOrder();
    }

    private SpirvStore(SpirvStore other) {
        super(other);
        this.scope = other.scope;
    }

    @Override
    public String defaultString() {
        return String.format("spirv_store[%s, %s](%s, %s)", mo, scope, address, value);
    }

    @Override
    public SpirvStore getCopy() {
        return new SpirvStore(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitSpirvStore(this);
    }

    private void validateMemoryOrder() {
        if (mo.equals(ACQUIRE) || mo.equals(ACQ_REL)) {
            throw new IllegalArgumentException(
                    String.format("%s cannot have memory order '%s'",
                            getClass().getSimpleName(), mo));
        }
        if (getTags().contains(SEM_VISIBLE)) {
            throw new IllegalArgumentException(
                    String.format("%s cannot have semantics '%s'",
                            getClass().getSimpleName(), SEM_VISIBLE));
        }
    }
}
