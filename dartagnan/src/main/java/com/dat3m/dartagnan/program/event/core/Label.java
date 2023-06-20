package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.Set;
import java.util.stream.Collectors;

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
                .collect(Collectors.toSet());
    }

    @Override
    public void delete() {
        getJumpSet().forEach(CondJump::delete);
        super.delete();
    }

    @Override
    public String toString(){
        return name + ":" + (hasTag(Tag.SPINLOOP) ? "\t### SPINLOOP" : "");
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Label getCopy(){
        return new Label(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLabel(this);
	}
}