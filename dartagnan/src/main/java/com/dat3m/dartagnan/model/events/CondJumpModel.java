package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.model.AbstractEventModel;

public final class CondJumpModel extends AbstractEventModel {

    private final TypedValue<BooleanType, Boolean> guardValue;
    private final transient LabelModel target;

    public CondJumpModel(TypedValue<BooleanType, Boolean> guardValue, LabelModel target) {
        this.guardValue = guardValue;
        this.target = target;
    }

    public TypedValue<BooleanType, Boolean> getGuardValue() { return guardValue; }
    public LabelModel getTarget() { return target; }

    public boolean wasTaken() { return guardValue.value(); }

    @Override
    public String toString() {
        if (wasTaken()) {
            return String.format("goto %s", target);
        } else {
            return "fallthrough";
        }
    }
}
