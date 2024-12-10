package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.verification.model.ThreadModel;
import com.dat3m.dartagnan.verification.model.ValueModel;

import java.math.BigInteger;


public class LoadModel extends MemoryEventModel implements RegWriterModel {
    public LoadModel(Load load, ThreadModel thread, int id, BigInteger address, ValueModel value) {
        super(load, thread, id, address, value);
    }
}