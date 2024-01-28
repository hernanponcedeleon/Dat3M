package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;

import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

public interface MemoryCoreEvent extends MemoryEvent {

    Expression getAddress();
    void setAddress(Expression address);
    Type getAccessType();

    @Override
    default Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(getAddress(), Register.UsageType.ADDR, new HashSet<>());
    }

    @Override
    default <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitMemEvent(this);
    }


    /*
        Convenience implementation to set the MemoryOrder metadata + add a corresponding tag.
     */
    default void setMemoryOrder(String newMo) {
        final MemoryOrder mo = getMetadata(MemoryOrder.class);
        final String oldMo = (mo == null ? null : mo.value());
        newMo = (newMo == null || newMo.isEmpty()) ? null : newMo;

        if (!Objects.equals(oldMo, newMo)) {
            removeTags(oldMo);
            if (newMo != null) {
                setMetadata(new MemoryOrder(newMo));
                addTags(newMo);
            }
        }
    }
}
