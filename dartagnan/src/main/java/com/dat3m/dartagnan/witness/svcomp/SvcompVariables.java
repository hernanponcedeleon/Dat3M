package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.Optional;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * Defines which program variables witnesses may constrain.
 * Witness extraction and validation share these rules, so that every assumption we generate is one we can validate.
 * A variable is a bare identifier naming a statically allocated, initialized scalar memory object of integral type.
 * Validation additionally requires all writes to the object to have its type.
 * Writes are only known after alias analysis, so this last rule is checked by {@link SvcompWitnessResolver} alone.
 */
public final class SvcompVariables {

    /** The syntax of a variable name in an assumption. */
    public static final Pattern NAME = Pattern.compile("[A-Za-z_][A-Za-z0-9_$]*");

    private SvcompVariables() { }

    /** Whether {@code object} may be named by a witness variable. */
    public static boolean isVariable(MemoryObject object) {
        return object.hasName() && NAME.matcher(object.getName()).matches() && scalarType(object).isPresent();
    }

    /**
     * The type of the only field of {@code object}, if it is a statically allocated, initialized integral scalar
     * whose size is that of its type.
     */
    public static Optional<Type> scalarType(MemoryObject object) {
        if (!object.isStaticallyAllocated() || !object.hasKnownSize()
                || !object.getInitializedFields().equals(Set.of(0))) {
            return Optional.empty();
        }
        final Type type = object.getInitialValue(0).getType();
        final boolean integral = type instanceof IntegerType || type instanceof BooleanType;
        return integral && TypeFactory.getInstance().getMemorySizeInBytes(type) == object.getKnownSize()
                ? Optional.of(type) : Optional.empty();
    }
}
