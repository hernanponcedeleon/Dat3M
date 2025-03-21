package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.math.BigInteger;

public record MemoryObjectModel(MemoryObject object, ValueModel address, BigInteger size) {
}
