package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.google.common.collect.ImmutableSet;

import java.util.Set;

public class Label extends AbstractEvent {

    private String name;

    public Label(String name){
        this.name = name;
    }

    protected Label(Label other){
        super(other);
        this.name = other.name;
    }

    public String getName(){ return name; }
    public void setName(String name) { this.name = name;}

    public Set<CondJump> getJumpSet() {
        return getUsers().stream()
                .filter(CondJump.class::isInstance).map(CondJump.class::cast)
                .collect(ImmutableSet.toImmutableSet());
    }

    @Override
    public String defaultString() {
        return name + ":" + (hasTag(Tag.SPINLOOP) ? "\t### SPINLOOP" : "");
    }

    @Override
    public Label getCopy(){
        return new Label(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLabel(this);
	}
}