package com.dat3m.dartagnan.program.event.core.annotations;

public class FunCallMarker extends StringAnnotation {

    private final String funName;

    public FunCallMarker(String funName) {
        super("=== Calling " + funName + " ===");
        this.funName = funName;
    }

    protected FunCallMarker(FunCallMarker other) {
        super(other);
        this.funName = other.funName;
    }

    public String getFunctionName() {
        return funName;
    }

    @Override
    public FunCallMarker getCopy() {
        return new FunCallMarker(this);
    }
}