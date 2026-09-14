package com.dat3m.dartagnan.utils.metadata;

public interface MetadataCarrier<T> {

    void copyAllMetadataFrom(T other);
    void copyMetadataFrom(T other, Class<? extends Metadata> metadataClass);
    boolean hasMetadata(Class<? extends Metadata> metadataClass);
    <TMeta extends Metadata> TMeta getMetadata(Class<TMeta> metadataClass);
    <TMeta extends Metadata> TMeta setMetadata(TMeta metadata);
    boolean hasEqualMetadata(T other, Class<? extends Metadata> metadataClass);
}
