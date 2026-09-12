package com.dat3m.dartagnan.utils.metadata;

import com.dat3m.dartagnan.program.event.common.NoInterface;

import java.util.Objects;

@NoInterface
public abstract class MetadataCarrierBase<T extends MetadataCarrier<T>> implements MetadataCarrier<T> {

    protected final MetadataMap metadataMap = new MetadataMap();

    @Override
    public boolean hasMetadata(Class<? extends Metadata> metadataClass) { return metadataMap.contains(metadataClass); }
    @Override
    public <TMeta extends Metadata> TMeta getMetadata(Class<TMeta> metadataClass) { return metadataMap.get(metadataClass); }
    @Override
    public <TMeta extends Metadata> TMeta setMetadata(TMeta metadata) { return metadataMap.put(metadata); }

    @Override
    public void copyAllMetadataFrom(T other) {
        ((MetadataCarrierBase<?>) other).metadataMap.getAllMetadata().forEach(this.metadataMap::put);
    }

    @Override
    public void copyMetadataFrom(T other, Class<? extends Metadata> metadataClass) {
        Metadata metadata = other.getMetadata(metadataClass);
        if (metadata == null) {
            this.metadataMap.remove(metadataClass);
        } else {
            this.setMetadata(metadata);
        }
    }

    @Override
    public boolean hasEqualMetadata(T other, Class<? extends Metadata> metadataClass) {
        return Objects.equals(getMetadata(metadataClass), other.getMetadata(metadataClass));
    }
}
