package com.dat3m.dartagnan.program.event;

public class FenceOpt extends Fence {

    private final String opt;

    public FenceOpt(String name, String opt){
        super(name);
        this.opt = opt;
        filter.add(name + "." + opt);
    }

    protected FenceOpt(FenceOpt other){
        super(other);
        this.opt = other.opt;
    }

    @Override
    public String getName(){
        return name + "." + opt;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected FenceOpt mkCopy(){
        return new FenceOpt(this);
    }
}
