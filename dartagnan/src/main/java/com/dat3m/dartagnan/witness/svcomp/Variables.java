package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.Optional;
import java.util.Set;
import java.util.regex.Pattern;

import static com.google.common.base.Verify.verify;

/**
 * Shared rules for witness variables: named, statically allocated, initialized integral scalars.
 * {@link WitnessResolver} additionally checks that all writes match the object's type.
 */
public final class Variables {

    /** The syntax of a variable name in an assumption. */
    public static final Pattern NAME = Pattern.compile("[A-Za-z_][A-Za-z0-9_$]*");

    private Variables() { }

    public static boolean isVariable(MemoryObject object) {
        return object.hasName() && NAME.matcher(object.getName()).matches() && scalarType(object).isPresent();
    }

    /**
     * The type of the only field of {@code object}, if it is a statically allocated, initialized integral scalar.
     */
    public static Optional<Type> scalarType(MemoryObject object) {
        if (!object.isStaticallyAllocated() || !object.hasKnownSize()
                || !object.getInitializedFields().equals(Set.of(0))) {
            return Optional.empty();
        }
        final Type type = object.getInitialValue(0).getType();
        if (!(type instanceof IntegerType || type instanceof BooleanType)) {
            return Optional.empty();
        }
        // Frontends store the initializer of the whole object at offset 0.
        verify(TypeFactory.getInstance().getMemorySizeInBytes(type) == object.getKnownSize(),
                "Initial value of %s does not span the object", object);
        return Optional.of(type);
    }
}
