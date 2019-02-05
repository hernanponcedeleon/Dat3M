package com.dat3m.dartagnan.program.event.rmw.opt;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.rmw.RMWLoad;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;

public class RMWStoreOpt extends RMWStore implements RegReaderData {

    public RMWStoreOpt(RMWLoad loadEvent, IExpr address, ExprInterface value, String atomic){
        super(loadEvent, address, value, atomic);
    }

    @Override
    public BoolExpr encodeCF(Context ctx) {
        if(loadEvent != null){
            return ctx.mkAnd(
                    ctx.mkImplies(executes(ctx), ctx.mkEq(memAddressExpr, loadEvent.getMemAddressExpr())),
                    ctx.mkImplies(ctx.mkNot(ctx.mkBoolConst(cfVar())), ctx.mkNot(executes(ctx)))
            );
        }
        return ctx.mkNot(executes(ctx));
    }

    @Override
    public String toString(){
        return String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", super.toString()) + "# opt";
    }

    String toStringBase(){
        return super.toString();
    }

    @Override
    public RMWStoreOpt clone() {
        if(clone == null){
            RMWLoad newLoad = loadEvent != null ? loadEvent.clone() : null;
            clone = new RMWStoreOpt(newLoad, address, value, atomic);
            afterClone();
        }
        return (RMWStoreOpt)clone;
    }
}
