package dartagnan.program.event;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.memory.Location;

import java.util.Set;

public class WriteToAddress extends Write implements RegReaderData, RegReaderAddress {

    private Register address;

    public WriteToAddress(Register address, ExprInterface value, String atomic){
        super(null, value, atomic);
        this.address = address;
    }

    @Override
    public void setMaxLocationSet(Set<Location> locations){
        this.locations = locations;
    }

    @Override
    public Register getAddressReg(){
        return address;
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + "memory[" + address + "].store(" +  value + "," + atomic + ")";
    }

    @Override
    public WriteToAddress clone() {
        WriteToAddress newWrite = new WriteToAddress(address.clone(), value.clone(), atomic);
        newWrite.condLevel = condLevel;
        newWrite.memId = memId;
        newWrite.setUnfCopy(getUnfCopy());
        return newWrite;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        return _compile(new StoreToAddress(address, value, atomic), target, ctrl, leading);
    }
}
