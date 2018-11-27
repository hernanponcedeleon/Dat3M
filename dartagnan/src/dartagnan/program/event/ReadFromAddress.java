package dartagnan.program.event;

import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegWriter;

public class ReadFromAddress extends Read implements RegWriter, RegReaderAddress {

    public ReadFromAddress(Register register, Register address, String atomic) {
        super(register, null, atomic);
        this.address = address;
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + reg + " = memory[" + address + "].load(" +  atomic + ")";
    }

    @Override
    public ReadFromAddress clone() {
        if(clone == null){
            clone = new ReadFromAddress(reg.clone(), address.clone(), atomic);
            afterClone();
        }
        return (ReadFromAddress)clone;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        return _compile(new LoadFromAddress(reg, address, atomic), target, ctrl, leading);
    }
}
