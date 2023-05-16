package com.dat3m.dartagnan.prototype.expr;

import javax.annotation.Nonnegative;

/**
 * Classifies values of an expression, as well as objects in shared memory.
 */
public interface Type {

    /**
     * @return Greatest common divisor of valid address values to instances of this type.
     */
    @Nonnegative
    int getMemoryAlignment();

    /**
     * @return Number of bytes occupied by values of this type.
     * A multiple of {@link #getMemoryAlignment()}.
     */
    @Nonnegative
    int getMemorySize();
}
