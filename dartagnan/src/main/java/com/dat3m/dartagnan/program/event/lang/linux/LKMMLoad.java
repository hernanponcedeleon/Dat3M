package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.LoadBase;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.metadata.CustomPrinting;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;

import java.util.Optional;

public class LKMMLoad extends LoadBase {

    // A custom printer to make core loads appear like LKMMLoads
    public static final CustomPrinting CUSTOM_CORE_PRINTING = (e -> {
        assert e instanceof Load;
        Load load = (Load)e;
        MemoryOrder memoryOrder = load.getMetadata(MemoryOrder.class);
        if (memoryOrder != null && memoryOrder.value().equals(Tag.Linux.MO_ONCE)) {
            return Optional.of(load.getResultRegister() + " := READ_ONCE(" + load.getAddress() + ")\t### LKMM");
        }
        return Optional.empty(); // Use default printing
    });

    public LKMMLoad(Register register, Expression address, String mo) {
        super(register, address, mo);
    }

    private LKMMLoad(LKMMLoad other) {
        super(other);
    }

    @Override
    public String defaultString() {
        if (mo.equals(Tag.Linux.MO_ONCE)) {
            return resultRegister + " := READ_ONCE(" + address + ")\t### LKMM";
        }
        return super.defaultString();
    }

    @Override
    public LKMMLoad getCopy() {
        return new LKMMLoad(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLKMMLoad(this);
    }
}
