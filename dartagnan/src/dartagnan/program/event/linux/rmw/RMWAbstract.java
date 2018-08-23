package dartagnan.program.event.linux.rmw;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.Fence;
import dartagnan.program.event.Local;
import dartagnan.program.event.MemEvent;
import dartagnan.program.event.filter.FilterUtils;
import dartagnan.program.event.rmw.cond.FenceCond;
import dartagnan.program.event.rmw.cond.RMWReadCond;

public abstract class RMWAbstract extends MemEvent {

    protected Register reg;
    protected ExprInterface value;
    protected String atomic;

    public RMWAbstract(Location location, Register register, ExprInterface value, String atomic) {
        this.loc = location;
        this.reg = register;
        this.value = value;
        this.atomic = atomic;
        this.condLevel = 0;
        this.memId = hashCode();
        addFilters(
                FilterUtils.EVENT_TYPE_ANY,
                FilterUtils.EVENT_TYPE_MEMORY,
                FilterUtils.EVENT_TYPE_READ,
                FilterUtils.EVENT_TYPE_WRITE,
                FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE,
                FilterUtils.EVENT_TYPE_ATOMIC
        );
    }

    public Register getReg() {
        return reg;
    }

    public Thread compile(String target, boolean ctrl, boolean leading) {
        throw new RuntimeException("Method compile is not implemented for " + target + " " + this.getClass().getName() + " " + atomic);
    }

    public Thread optCompile(String target, boolean ctrl, boolean leading) {
        throw new RuntimeException("Method optCompile is not implemented for " + target + " " + this.getClass().getName() + " " + atomic);
    }

    public Thread allCompile() {
        throw new RuntimeException("Method allCompile is not implemented for " + this.getClass().getName() + " " + atomic);
    }

    protected String getLoadMO(){
        return atomic.equals("_acq") ? "_acq" : "_rx";
    }

    protected String getStoreMO(){
        return atomic.equals("_rel") ? "_rel" : "_rx";
    }

    protected Thread insertFencesOnMb(Thread result){
        if (atomic.equals("_mb")) {
            return new Seq(new Fence("Mb"), new Seq(result, new Fence("Mb")));
        }
        return result;
    }

    protected Thread insertCondFencesOnMb(Thread result, RMWReadCond load){
        if (atomic.equals("_mb")) {
            return new Seq(new FenceCond(load, "Mb"), new Seq(result, new FenceCond(load, "Mb")));
        }
        return result;
    }

    protected Thread copyFromDummyToResult(Thread result, Register dummy){
        if (dummy != reg) {
            return new Seq(result, new Local(reg, dummy));
        }
        return result;
    }

    protected void compileBasic(MemEvent event){
        event.setHLId(memId);
        event.setUnfCopy(getUnfCopy());
        event.setCondLevel(condLevel);
        event.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);
    }

    protected String opToText(String op){
        switch (op){
            case "+":
                return "add";
            case "-":
                return "sub";
            default:
                throw new RuntimeException("Unsupported operation " + op + " in " + this.getClass().getName());
        }
    }

    protected String atomicToText(String atomic){
        switch (atomic){
            case "_rx":
                return "_relaxed";
            case "_acq":
                return "_acquire";
            case "_rel":
                return "_release";
            case "_mb":
                return "";
            default:
                throw new RuntimeException("Unsupported memory order " + atomic + " in " + this.getClass().getName());
        }
    }
}
