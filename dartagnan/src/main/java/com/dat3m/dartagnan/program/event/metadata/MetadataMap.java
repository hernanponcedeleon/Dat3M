package com.dat3m.dartagnan.program.event.metadata;

import java.util.ArrayList;
import java.util.List;

// This class effectively amounts to a map "Map<Class<? extends Metadata>, Metadata>".
public class MetadataMap {

    // Since there is usually not much metadata, we opt for a more efficient representation via a linear list
    // rather than an actual map.
    private final List<Metadata> metadataList = new ArrayList<>();

    public boolean contains(Class<? extends Metadata> metadataClass) {
        return metadataList.stream().anyMatch(m -> m.getClass() == metadataClass);
    }

    @SuppressWarnings("unchecked") // The class guarantees that the unchecked cast is valid.
    public <T extends Metadata> T get(Class<T> metadataClass) {
        return (T)metadataList.stream()
                .filter(m -> m.getClass() == metadataClass)
                .findAny().orElse(null);
    }

    @SuppressWarnings("unchecked") // The class guarantees that the unchecked cast is valid.
    public <T extends Metadata> T put(T metadata) {
        final Class<? extends Metadata> mClass = metadata.getClass();
        for (int i = 0; i < metadataList.size(); i++) {
            final Metadata m = metadataList.get(i);
            if (m.getClass() == mClass) {
                metadataList.set(i, metadata);
                return (T)m;
            }
        }
        metadataList.add(metadata);
        return null;
    }

    public List<Metadata> getAllMetadata() { return metadataList; }

}
