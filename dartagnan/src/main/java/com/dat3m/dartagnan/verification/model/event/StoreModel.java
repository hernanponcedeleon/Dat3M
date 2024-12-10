package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.verification.model.ThreadModel;
import com.dat3m.dartagnan.verification.model.ValueModel;

import java.math.BigInteger;


public class StoreModel extends MemoryEventModel {
    public StoreModel(Store store, ThreadModel thread, int id, BigInteger address, ValueModel value) {
        super(store, thread, id, address, value);
    }
}