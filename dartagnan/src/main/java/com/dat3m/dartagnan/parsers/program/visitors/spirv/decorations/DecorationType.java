package com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations;

public enum DecorationType {
    ARRAY_STRIDE,
    BINDING,
    BLOCK,
    BUFFER_BLOCK,
    BUILT_IN,
    COHERENT,
    DESCRIPTOR_SET,
    OFFSET,
    NO_CONTRACTION,
    NO_PERSPECTIVE,
    NON_WRITABLE,
    SPEC_ID;

    public static DecorationType fromString(String type) {
        return switch (type) {
            case "ArrayStride" -> ARRAY_STRIDE;
            case "Binding" -> BINDING;
            case "Block" -> BLOCK;
            case "BufferBlock" -> BUFFER_BLOCK;
            case "BuiltIn" -> BUILT_IN;
            case "Coherent" -> COHERENT;
            case "DescriptorSet" -> DESCRIPTOR_SET;
            case "Offset" -> OFFSET;
            case "NoContraction" -> NO_CONTRACTION;
            case "NoPerspective" -> NO_PERSPECTIVE;
            case "NonWritable" -> NON_WRITABLE;
            case "SpecId" -> SPEC_ID;
            default -> throw new IllegalArgumentException("Unsupported decoration type " + type);
        };
    }
}
