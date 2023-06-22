package com.dat3m.dartagnan.program.event.metadata;

//TODO: Add a factory with caching, because we can share the same MemoryOrder instance between different events.
public record MemoryOrder(String value) implements Metadata {  }
