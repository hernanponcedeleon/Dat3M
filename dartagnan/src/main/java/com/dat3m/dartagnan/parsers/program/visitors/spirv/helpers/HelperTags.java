package com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.google.common.collect.Sets;

import java.util.*;

import static com.dat3m.dartagnan.program.event.Tag.Spirv.*;

public class HelperTags {
    private static final List<String> scopes = mkScopesList();
    private static final Set<String> moStrong = mkStrongMemoryOrderSet();
    private static final Map<Integer, String> semantics = mkSemanticsMap();

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

    private static Set<String> mkStrongMemoryOrderSet() {
        return Set.of(
                ACQUIRE,
                RELEASE,
                ACQ_REL,
                SEQ_CST
        );
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

    public boolean isMemorySemanticsNone(String id, Expression expr) {
        return getIntValue(id, expr) == 0;
    }

    public Set<String> visitIdMemorySemantics(String id, Expression expr) {
        int value = getIntValue(id, expr);
        Set<String> tags = new HashSet<>();
        for (int i = 1; i <= value; i <<= 1) {
            if ((i & value) > 0) {
                if (!semantics.containsKey(i)) {
                    throw new ParsingException("Unexpected memory semantics bits");
                }
                tags.add(semantics.get(i));
            }
        }
        int moSize = Sets.intersection(moStrong, tags).size();
        if (moSize > 1) {
            throw new ParsingException("Selected multiple non-relaxed memory order bits");
        }
        if (moSize == 0) {
            tags.add(RELAXED);
        }
        return tags;
    }

    public String visitScope(String id, Expression expr) {
        int value = getIntValue(id, expr);
        if (value >= 0 && value < scopes.size()) {
            return scopes.get(value);
        }
        throw new ParsingException("Illegal scope value %d", value);
    }

    public String visitStorageClass(String cls) {
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

    private int getIntValue(String id, Expression expr) {
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
}
