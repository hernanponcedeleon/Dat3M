package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.memory.MemoryObject;

/**
 * An instance of this class is generated for each defined location in the shared memory of a program.
 * It is exposed to the memory consistency model as a visible event.
 * It acts like a regular store, such that load events may read from it and other stores may overwrite it.
 */
public class Init extends Store {

    private final MemoryObject base;
    private final int offset;

    public Init(MemoryObject b, int o, Expression address) {
        super(address, b.getInitialValue(o));
        base = b;
        offset = o;
        addTags(Tag.INIT);
    }

    /**
     * Partially identifies this instance in the program.
     *
     * @return Address of the array whose field is initialized in this event.
     */
    public MemoryObject getBase() {
        return base;
    }

    /**
     * Partially identifies this instance in the program.
     *
     * @return Number of fields before the initialized location.
     */
    public int getOffset() {
        return offset;
    }

    /**
     * Initial value at the associated field.
     *
     * @return Content of the location at the start of each execution.
     */
    public Expression getValue() {
        return base.getInitialValue(offset);
    }

    @Override
    public String defaultString() {
        return String.format("%s[%d] := %s", base, offset, getValue());
    }

    @Override
    public Expression getMemValue() { return getValue(); }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitInit(this);
    }
}