package com.dat3m.dartagnan.program.event;

public class FenceOpt extends Fence {

	//TODO(HP) I think this class can go. It was for some idea I never managed to implement
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
    public FenceOpt getCopy(){
        return new FenceOpt(this);
    }
}
