package dartagnan.program.event.linux.rmw;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.rmw.RMWLoadFromAddress;
import dartagnan.program.event.rmw.RMWStoreToAddress;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;

public class RMWXchg extends RMWAbstract implements RegWriter, RegReaderData, RegReaderAddress {

    public RMWXchg(Register address, Register register, ExprInterface value, String atomic) {
        super(address, register, value, atomic);
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = reg == value ? new Register(null) : reg;
            RMWLoadFromAddress load = new RMWLoadFromAddress(dummy, address, getLoadMO());
            RMWStoreToAddress store = new RMWStoreToAddress(load, address, value, getStoreMO());

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
        return nTimesCondLevel() + reg + " := atomic_xchg" + atomicToText(atomic) + "(" + loc + ", " + value + ")";
    }

    @Override
    public RMWXchg clone() {
        if(clone == null){
            Register newReg = reg.clone();
            ExprInterface newValue = reg == value ? newReg : value.clone();
            clone = new RMWXchg(address.clone(), newReg, newValue, atomic);
            afterClone();
        }
        return (RMWXchg)clone;
    }
}
