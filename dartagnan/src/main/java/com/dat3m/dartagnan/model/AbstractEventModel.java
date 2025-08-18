package com.dat3m.dartagnan.model;

import com.dat3m.dartagnan.program.event.TagSet;

public abstract class AbstractEventModel implements EventModel {

    private final TagSet tags;

    private transient ThreadModel thread;

    protected AbstractEventModel() {
        tags = new TagSet();
    }

    @Override
    public TagSet getTags() { return tags; }
    @Override
    public ThreadModel getThread() { return thread; }


    void setThread(ThreadModel thread) { this.thread = thread; }

}

