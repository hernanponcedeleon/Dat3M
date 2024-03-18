package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.StoreBase;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.metadata.CustomPrinting;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;

import java.util.Optional;

public class LKMMStore extends StoreBase {

    // A custom printer to make core stores appear like LKMMStore
    public static final CustomPrinting CUSTOM_CORE_PRINTING = (e -> {
        assert e instanceof Store;
        Store store = (Store)e;
        MemoryOrder memoryOrder = store.getMetadata(MemoryOrder.class);
        if (memoryOrder != null && memoryOrder.value().equals(Tag.Linux.MO_ONCE)) {
            return Optional.of( "STORE_ONCE(" + store.getAddress() + ", " + store.getMemValue() + ")\t### LKMM");
        }
        return Optional.empty(); // Use default printing
    });

    public LKMMStore(Expression address, Expression value, String mo) {
        super(address, value, mo);
    }

    private LKMMStore(LKMMStore other) {
        super(other);
    }

    @Override
    public String defaultString() {
        if (mo.equals(Tag.Linux.MO_ONCE)) {
            return "STORE_ONCE(" + address + ", " + value + ")\t### LKMM";
        }
        return super.defaultString();
    }

    @Override
    public LKMMStore getCopy() {
        return new LKMMStore(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLKMMStore(this);
    }

}
