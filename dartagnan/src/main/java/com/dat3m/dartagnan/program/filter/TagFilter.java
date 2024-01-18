package com.dat3m.dartagnan.program.filter;

import com.dat3m.dartagnan.program.event.Event;

public class TagFilter extends Filter {

    private final String tag;

    TagFilter(String tag){
        this.tag = tag;
    }

    @Override
    public boolean apply(Event event){
        return event.hasTag(tag);
    }

    @Override
    public String toString(){
        return tag;
    }

    @Override
    public int hashCode() {
        return tag.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        TagFilter fObj = (TagFilter) obj;
        return fObj.tag.equals(tag);
    }
}
