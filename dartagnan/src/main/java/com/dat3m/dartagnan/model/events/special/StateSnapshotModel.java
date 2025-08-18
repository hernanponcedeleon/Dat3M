package com.dat3m.dartagnan.model.events.special;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.model.AbstractEventModel;
import com.google.common.collect.ImmutableList;

import java.util.List;
import java.util.stream.Collectors;

public final class StateSnapshotModel extends AbstractEventModel {

    private final ImmutableList<TypedValue<?, ?>> values;

    public StateSnapshotModel(List<TypedValue<?, ?>> values) {
        this.values = ImmutableList.copyOf(values);
    }

    public ImmutableList<TypedValue<?, ?>> getValues() { return values; }

    @Override
    public String toString() {
        return String.format("StateSnapshot(%s)",
                values.stream().map(TypedValue::toString).collect(Collectors.joining(", "))
        );
    }
}
