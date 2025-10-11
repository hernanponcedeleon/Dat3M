package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

//TODO: This relation may contain non-visible events. Is this reasonable?
public class TagSet extends Definition {

    private final String tag;

    public TagSet(Relation r, String tag) {
        this(Relation.checkIsSet(r), tag, tag);
    }

    protected TagSet(Relation r, String tag, String termPattern) {
        super(r, termPattern);
        this.tag = tag;
    }

    public String getTag() {
        return tag;
    }

    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitTagSet(this);
    }
}
