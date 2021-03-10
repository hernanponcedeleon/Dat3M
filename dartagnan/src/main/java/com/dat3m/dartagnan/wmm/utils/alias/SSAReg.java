package com.dat3m.dartagnan.wmm.utils.alias;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemEvent;

import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class SSAReg {

    private final Set<MemEvent> eventsWithAddress = new HashSet<>();
    private final Register register;
    private final int ssaId;
        
    public SSAReg(int SSAId, Register register) {
        this.ssaId = SSAId;
        this.register = register;
    }

    public Register getReg() {
        return register;
    }

    @Override
    public int hashCode(){
        return register.hashCode() ^ ssaId;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        SSAReg sObj = (SSAReg)obj;
        return register == sObj.register && ssaId == sObj.ssaId;
    }

    Set<MemEvent> getEventsWithAddr() {
        return eventsWithAddress;
    }
}
