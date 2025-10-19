package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.model.EventModel;
import com.dat3m.dartagnan.model.RegisterModel;

public interface RegWriterModel extends EventModel {
    RegisterModel getResultRegister();
    TypedValue<?, ?> getValue();
}
