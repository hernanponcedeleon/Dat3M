package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.wmm.Wmm;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

public class WmmProcessingManager implements WmmProcessor {

    private final List<WmmProcessor> processors = new ArrayList<>();

    private WmmProcessingManager() {
        processors.addAll(Arrays.asList(
                RemoveDeadRelations.newInstance(),
                MergeEquivalentRelations.newInstance(),
                FlattenAssociatives.newInstance(),
                MarkFreeRelations.newInstance()
        ));
        processors.removeIf(Objects::isNull);
    }

    public static WmmProcessingManager newInstance() {
        return new WmmProcessingManager();
    }

    // ==================================================

    @Override
    public void run(Wmm wmm) {
        processors.forEach(p -> p.run(wmm));
    }


}
