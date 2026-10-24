package com.dat3m.dartagnan.model.event;

import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import com.dat3m.dartagnan.model.ThreadModel;


public class GenericVisibleEventModel extends DefaultEventModel {
    public GenericVisibleEventModel(GenericVisibleEvent event, ThreadModel thread, int id) {
        super(event, thread, id);
    }
}