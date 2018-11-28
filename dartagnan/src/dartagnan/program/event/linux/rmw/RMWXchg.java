package dartagnan.program.event.linux.rmw;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;

public class RMWXchg extends RMWAbstract implements RegWriter, RegReaderData {

    public RMWXchg(Register address, Register register, ExprInterface value, String atomic) {
        super(address, register, value, atomic);
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = reg == value ? new Register(null) : reg;
            RMWLoad load = new RMWLoad(dummy, address, getLoadMO());
            RMWStore store = new RMWStore(load, address, value, getStoreMO());

            compileBasic(load);
            compileBasic(store);

            Thread result = new Seq(load, store);
            result = copyFromDummyToResult(result, dummy);
            return insertFencesOnMb(result);
        }
        return super.compile(target, ctrl, leading);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + reg + " := atomic_xchg" + atomicToText(atomic) + "(" + address + ", " + value + ")";
    }

    @Override
    public RMWXchg clone() {
        if(clone == null){
            Register newReg = reg.clone();
            ExprInterface newValue = reg == value ? newReg : value.clone();
            clone = new RMWXchg((Register) address.clone(), newReg, newValue, atomic);
            afterClone();
        }
        return (RMWXchg)clone;
    }
}
