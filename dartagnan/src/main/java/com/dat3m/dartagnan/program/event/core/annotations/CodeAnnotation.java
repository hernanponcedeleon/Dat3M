package com.dat3m.dartagnan.program.event.core.annotations;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

/*
    Annotation events have no semantics (like skip).
    Their only purpose is to give metadata about the code which may be used for analyses or
    just for debugging.
 */
public abstract class CodeAnnotation extends Event {

    public CodeAnnotation() {
        addFilters(Tag.ANY, Tag.ANNOTATION);
    }

    protected CodeAnnotation(CodeAnnotation other) {
        super(other);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitCodeAnnotation(this);
	}
}
