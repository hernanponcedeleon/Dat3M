package dartagnan.program.event;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegReaderData;

public class WriteToAddress extends Write implements RegReaderData, RegReaderAddress {

    public WriteToAddress(Register address, ExprInterface value, String atomic){
        super(null, value, atomic);
        this.address = address;
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + "memory[" + address + "].store(" +  value + "," + atomic + ")";
    }

    @Override
    public WriteToAddress clone() {
        if(clone == null){
            clone = new WriteToAddress(address.clone(), value.clone(), atomic);
            afterClone();
        }
        return (WriteToAddress)clone;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        return _compile(new StoreToAddress(address, value, atomic), target, ctrl, leading);
    }
}
