package com.dat3m.dartagnan.program.event.core.annotations;

import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.EventVisitor;

/*
    Annotation events have no semantics (like skip).
    Their only purpose is to give metadata about the code which may be used for analyses or
    just for debugging.
 */
public abstract class CodeAnnotation extends AbstractEvent {

    public CodeAnnotation() {
    }

    protected CodeAnnotation(CodeAnnotation other) {
        super(other);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitCodeAnnotation(this);
    }
}
