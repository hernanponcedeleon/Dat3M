package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.model.AbstractEventModel;

public final class AssertModel extends AbstractEventModel {

    private final TypedValue<BooleanType, Boolean> value;
    private final String errorMessage;

    public AssertModel(TypedValue<BooleanType, Boolean> value, String errorMessage) {
        this.value = value;
        this.errorMessage = errorMessage;
    }

    public TypedValue<BooleanType, Boolean> getValue() { return value; }
    public String getErrorMessage() { return errorMessage; }

    @Override
    public String toString() {
        return String.format("Assert(%s) # \"%s\"", value, errorMessage);
    }
}
