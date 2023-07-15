package com.dat3m.dartagnan.program.event.core.annotations;

public class FunReturnMarker extends StringAnnotation {

    private final String funName;

    public FunReturnMarker(String funName) {
        super("=== Returning from " + funName + " ===");
        this.funName = funName;
    }

    protected FunReturnMarker(FunReturnMarker other) {
        super(other);
        this.funName = other.funName;
    }

    public String getFunctionName() {
        return funName;
    }

    @Override
    public FunReturnMarker getCopy() {
        return new FunReturnMarker(this);
    }
}
