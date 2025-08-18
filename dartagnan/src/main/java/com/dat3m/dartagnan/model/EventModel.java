package com.dat3m.dartagnan.model;

import com.dat3m.dartagnan.program.event.TagSet;

public interface EventModel {

    TagSet getTags();
    ThreadModel getThread();
}
