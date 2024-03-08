package com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations;

public enum DecorationType {
    ARRAY_STRIDE,
    BINDING,
    BLOCK,
    BUFFER_BLOCK,
    BUILT_IN,
    COHERENT,
    DESCRIPTOR_SET,
    NO_PERSPECTIVE,
    SPEC_ID;

    public static DecorationType fromString(String type) {
        switch (type) {
            case "ArrayStride":
                return ARRAY_STRIDE;
            case "Binding":
                return BINDING;
            case "Block":
                return BLOCK;
            case "BufferBlock":
                return BUFFER_BLOCK;
            case "BuiltIn":
                return BUILT_IN;
            case "Coherent":
                return COHERENT;
            case "DescriptorSet":
                return DESCRIPTOR_SET;
            case "NoPerspective":
                return NO_PERSPECTIVE;
            case "SpecId":
                return SPEC_ID;
            default:
                throw new IllegalArgumentException("Unsupported decoration type " + type);
        }
    }
}
