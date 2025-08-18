package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.model.EventModel;
import com.dat3m.dartagnan.program.Register;

public interface RegWriterModel extends EventModel {
    Register getResultRegister();
    TypedValue<?, ?> getValue();
}
