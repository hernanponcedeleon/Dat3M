package com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.program.event.Tag;
import com.google.common.collect.Sets;

import java.util.*;

import static com.dat3m.dartagnan.program.event.Tag.Spirv.*;

public class HelperTags {
    private static final List<String> scopes = mkScopesList();
    private static final Map<Integer, String> semantics = mkSemanticsMap();

    private HelperTags() {
    }

    public static Set<String> parseMemorySemanticsTags(String id, Expression expr) {
        int value = getIntValue(id, expr);
        Set<String> tags = new HashSet<>();
        for (int i = 1; i <= value; i <<= 1) {
            if ((i & value) > 0) {
                if (!semantics.containsKey(i)) {
                    throw new ParsingException("Illegal memory semantics '%s': unexpected bits", value);
                }
                tags.add(semantics.get(i));
            }
        }
        int moSize = Sets.intersection(moTags, tags).size();
        if (moSize > 1) {
            throw new ParsingException("Illegal memory semantics '%s': multiple non-relaxed memory order bits", value);
        }
        if (moSize == 0) {
            tags.add(RELAXED);
        }
        return tags;
    }

    public static Set<String> parseMemoryOperandsTags(List<String> operands, Integer alignment,
                                                      List<String> paramIds, List<Expression> paramsValues) {
        List<String> tagList = parseTagList(operands, alignment);
        Set<String> tagSet = new HashSet<>(tagList);
        if (tagList.size() != tagSet.size()) {
            throwDuplicatesException(operands);
        }
        int i = 0;
        for (String tag : List.of(Tag.Spirv.MEM_AVAILABLE, Tag.Spirv.MEM_VISIBLE)) {
            if (tagSet.contains(tag)) {
                if (paramIds.size() <= i) {
                    throwIllegalParametersException(operands);
                }
                String scopeTag = HelperTags.parseScope(paramIds.get(i), paramsValues.get(i));
                tagSet.add(scopeTag);
                i++;
            }
        }
        if (i != paramsValues.size()) {
            throwIllegalParametersException(operands);
        }
        if (!tagSet.contains(MEM_NON_PRIVATE) && (tagSet.contains(Tag.Spirv.MEM_AVAILABLE) || tagSet.contains(MEM_VISIBLE))) {
            throw new ParsingException("Missing NonPrivatePointer bit in memory operands '%s'",
                    String.join("|", operands));
        }
        // TODO: Implementation: this is a legal combination for OpCopyMemory and OpCopyMemorySized
        if (tagSet.contains(MEM_AVAILABLE) && tagSet.contains(MEM_VISIBLE)) {
            throw new ParsingException("Unsupported combination of memory operands '%s'",
                    String.join("|", operands));
        }
        return tagSet;
    }

    private static List<String> parseTagList(List<String> operands, Integer alignment) {
        boolean isNone = false;
        boolean isAligned = false;
        List<String> tagList = new LinkedList<>();
        for (String tag : operands) {
            switch (tag) {
                case "None" -> {
                    if (isNone) {
                        throwDuplicatesException(operands);
                    }
                    isNone = true;
                }
                case "Aligned" -> {
                    if (isAligned) {
                        throwDuplicatesException(operands);
                    }
                    isAligned = true;
                }
                case "Volatile" -> tagList.add(Tag.Spirv.MEM_VOLATILE);
                case "Nontemporal" -> tagList.add(Tag.Spirv.MEM_NONTEMPORAL);
                case "MakePointerAvailable", "MakePointerAvailableKHR" -> tagList.add(Tag.Spirv.MEM_AVAILABLE);
                case "MakePointerVisible", "MakePointerVisibleKHR" -> tagList.add(Tag.Spirv.MEM_VISIBLE);
                case "NonPrivatePointer", "NonPrivatePointerKHR" -> tagList.add(Tag.Spirv.MEM_NON_PRIVATE);
                case "AliasScopeINTELMask", "NoAliasINTELMask" ->
                        throw new ParsingException("Unsupported memory operand '%s'", tag);
                default -> throw new ParsingException("Unexpected memory operand '%s'", tag);
            }
        }
        if (isNone && (isAligned || !tagList.isEmpty())) {
            throw new ParsingException("Memory operand 'None' cannot be combined with other operands");
        }
        if (isAligned && alignment == null || !isAligned && alignment != null) {
            throwIllegalParametersException(operands);
        }
        return tagList;
    }

    public static String parseScope(String id, Expression expr) {
        int value = getIntValue(id, expr);
        if (value >= 0 && value < scopes.size()) {
            return scopes.get(value);
        }
        throw new ParsingException("Illegal scope value %d", value);
    }

    public static String parseStorageClass(String cls) {
        return switch (cls) {
            case "UniformConstant" -> SC_UNIFORM_CONSTANT;
            case "Input" -> SC_INPUT;
            case "Uniform" -> SC_UNIFORM;
            case "Output" -> SC_OUTPUT;
            case "Workgroup" -> SC_WORKGROUP;
            case "CrossWorkgroup" -> SC_CROSS_WORKGROUP;
            case "Private" -> SC_PRIVATE;
            case "Function" -> SC_FUNCTION;
            case "Generic" -> SC_GENERIC;
            case "PushConstant" -> SC_PUSH_CONSTANT;
            case "StorageBuffer" -> SC_STORAGE_BUFFER;
            case "PhysicalStorageBuffer" -> SC_PHYS_STORAGE_BUFFER;
            default -> throw new ParsingException("Unsupported storage class '%s'", cls);
        };
    }

    private static void throwDuplicatesException(List<String> operands) {
        throw new ParsingException("Duplicated memory operands definition(s) in '%s'",
                String.join("|", operands));
    }

    private static void throwIllegalParametersException(List<String> operands) {
        throw new ParsingException("Illegal parameter(s) in memory operands definition '%s'",
                String.join("|", operands));
    }

    private static int getIntValue(String id, Expression expr) {
        if (expr instanceof IntLiteral iValue) {
            try {
                return iValue.getValue().intValue();
            } catch (IllegalArgumentException e) {
                throw new ParsingException("Illegal tag value at %s. %s", id, e.getMessage());
            }
        }
        throw new ParsingException("Non-constant tags are not supported. " +
                "Found non-constant tag at '%s'", id);
    }

    private static List<String> mkScopesList() {
        return List.of(
                CROSS_DEVICE,
                DEVICE,
                WORKGROUP,
                SUBGROUP,
                INVOCATION,
                QUEUE_FAMILY,
                SHADER_CALL);
    }

    private static Map<Integer, String> mkSemanticsMap() {
        Map<Integer, String> map = new HashMap<>();
        map.put(0x2, ACQUIRE);
        map.put(0x4, RELEASE);
        map.put(0x8, ACQ_REL);
        map.put(0x10, SEQ_CST);
        map.put(0x40, SEM_UNIFORM);
        map.put(0x80, SEM_SUBGROUP);
        map.put(0x100, SEM_WORKGROUP);
        map.put(0x200, SEM_CROSS_WORKGROUP);
        map.put(0x400, SEM_ATOMIC_COUNTER);
        map.put(0x800, SEM_IMAGE);
        map.put(0x1000, SEM_OUTPUT);
        map.put(0x2000, SEM_AVAILABLE);
        map.put(0x4000, SEM_VISIBLE);
        map.put(0x8000, SEM_VOLATILE);
        return map;
    }
}
