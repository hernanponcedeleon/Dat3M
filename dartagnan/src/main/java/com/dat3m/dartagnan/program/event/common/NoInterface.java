package com.dat3m.dartagnan.program.event.common;

import java.lang.annotation.ElementType;
import java.lang.annotation.Target;

/*
    We use this annotation to mark abstract classes that should never be used as an interface. This means:
    (1) there are no casts nor instanceof checks involving this class,
    (2) the class is ONLY used to reduce implementation effort by providing a common implementation.
 */
@Target(ElementType.TYPE)
public @interface NoInterface {
}
