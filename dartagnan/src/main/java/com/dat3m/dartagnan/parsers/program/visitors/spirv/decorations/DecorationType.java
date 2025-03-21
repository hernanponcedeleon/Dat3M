package com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations;

public enum DecorationType {
    ALIGNMENT,
    ARRAY_STRIDE,
    BINDING,
    BLOCK,
    BUFFER_BLOCK,
    BUILT_IN,
    COHERENT,
    CONSTANT,
    DESCRIPTOR_SET,
    FUNC_PARAM_ATTR,
    LINKAGE_ATTRIBUTES,
    NO_CONTRACTION,
    NO_PERSPECTIVE,
    NON_WRITABLE,
    OFFSET,
    SPEC_ID;

    public static DecorationType fromString(String type) {
        return switch (type) {
            case "Alignment" -> ALIGNMENT;
            case "ArrayStride" -> ARRAY_STRIDE;
            case "Binding" -> BINDING;
            case "Block" -> BLOCK;
            case "BufferBlock" -> BUFFER_BLOCK;
            case "BuiltIn" -> BUILT_IN;
            case "Coherent" -> COHERENT;
            case "Constant" -> CONSTANT;
            case "DescriptorSet" -> DESCRIPTOR_SET;
            case "FuncParamAttr" -> FUNC_PARAM_ATTR;
            case "LinkageAttributes" -> LINKAGE_ATTRIBUTES;
            case "NoContraction" -> NO_CONTRACTION;
            case "NoPerspective" -> NO_PERSPECTIVE;
            case "NonWritable" -> NON_WRITABLE;
            case "Offset" -> OFFSET;
            case "SpecId" -> SPEC_ID;
            default -> throw new IllegalArgumentException("Unsupported decoration type " + type);
        };
    }
}
