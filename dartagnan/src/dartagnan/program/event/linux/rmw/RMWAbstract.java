package dartagnan.program.event.linux.rmw;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.Fence;
import dartagnan.program.event.Local;
import dartagnan.program.event.MemEvent;
import dartagnan.program.event.rmw.cond.FenceCond;
import dartagnan.program.event.rmw.cond.RMWReadCond;
import dartagnan.program.utils.linux.EType;

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
        addFilters(EType.ANY, EType.MEMORY, EType.READ, EType.WRITE, EType.RMW);
    }

    public Register getReg() {
        return reg;
    }

    public Thread compile(String target, boolean ctrl, boolean leading) {
        throw new RuntimeException("Method compile is not implemented for " + target + " " + this.getClass().getName() + " " + atomic);
    }

    protected String getLoadMO(){
        return atomic.equals("Acquire") ? "Acquire" : "Relaxed";
    }

    protected String getStoreMO(){
        return atomic.equals("Release") ? "Release" : "Relaxed";
    }

    protected Thread insertFencesOnMb(Thread result){
        if (atomic.equals("Mb")) {
            return new Seq(new Fence("Mb"), new Seq(result, new Fence("Mb")));
        }
        return result;
    }

    protected Thread insertCondFencesOnMb(Thread result, RMWReadCond load){
        if (atomic.equals("Mb")) {
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
    }

    protected String opToText(String op){
        switch (op){
            case "+":
                return "add";
            case "-":
                return "sub";
            default:
                throw new RuntimeException("Unrecognised operation " + op + " in " + this.getClass().getName());
        }
    }

    protected String atomicToText(String atomic){
        switch (atomic){
            case "Relaxed":
                return "_relaxed";
            case "Acquire":
                return "_acquire";
            case "Release":
                return "_release";
            case "Mb":
                return "";
            default:
                throw new RuntimeException("Unrecognised memory order " + atomic + " in " + this.getClass().getName());
        }
    }
}
