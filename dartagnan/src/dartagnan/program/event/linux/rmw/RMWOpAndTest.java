package dartagnan.program.event.linux.rmw;

import dartagnan.expression.*;
import dartagnan.expression.op.COpBin;
import dartagnan.expression.op.IOpBin;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.Local;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;

public class RMWOpAndTest extends RMWAbstract implements RegWriter, RegReaderData {

    private IOpBin op;

    public RMWOpAndTest(IExpr address, Register register, ExprInterface value, IOpBin op) {
        super(address, register, value, "Mb");
        this.op = op;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = new Register(null);
            RMWLoad load = new RMWLoad(dummy, address, "Relaxed");
            Local local1 = new Local(dummy, new IExprBin(dummy, op, value));
            RMWStore store = new RMWStore(load, address, dummy, "Relaxed");
            Local local2 = new Local(reg, new Atom(dummy, COpBin.EQ, new IConst(0)));

            compileBasic(load);
            compileBasic(store);

            Thread result = new Seq(load, new Seq(local1, new Seq(store, local2)));
            return insertFencesOnMb(result);
        }
        return super.compile(target, ctrl, leading);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + reg + " := atomic_" + op.toLinuxName() + "_and_test(" + value + ", memory[" + address + "])";
    }

    @Override
    public RMWOpAndTest clone() {
        if(clone == null){
            Register newReg = reg.clone();
            ExprInterface newValue = reg == value ? newReg : value.clone();
            clone = new RMWOpAndTest(address.clone(), newReg, newValue, op);
            afterClone();
        }
        return (RMWOpAndTest)clone;
    }
}
