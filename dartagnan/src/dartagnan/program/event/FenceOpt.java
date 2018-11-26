package dartagnan.program.event;

public class FenceOpt extends Fence {

    private String opt;

    public FenceOpt(String name, String opt){
        super(name);
        this.opt = opt;
        filter.add(name + "." + opt);
    }

    public FenceOpt(String name, String opt, int condLevel){
        super(name, condLevel);
        this.opt = opt;
        filter.add(name + "." + opt);
    }

    public String getName(){
        return name + "." + opt;
    }

    @Override
    public FenceOpt clone() {
        if(clone == null){
            clone = new FenceOpt(name, opt, condLevel);
            afterClone();
        }
        return (FenceOpt)clone;
    }
}
