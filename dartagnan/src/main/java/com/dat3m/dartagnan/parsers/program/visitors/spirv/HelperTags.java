package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IValue;
import com.google.common.collect.Sets;

import java.util.*;

import static com.dat3m.dartagnan.program.event.Tag.Spirv.*;

public class HelperTags {

    private final Map<Integer, String> semantics = mkSemanticsMap();
    private final Set<String> moStrong = Set.of(ACQUIRE, RELEASE, ACQ_REL, SEQ_CST);

    public Set<String> visitIdMemorySemantics(String id, Expression expr) {
        if (expr instanceof IValue iValue) {
            try {
                return parseSemantics(iValue.getValue().intValue());
            } catch (IllegalArgumentException e) {
                throw new ParsingException("Illegal memory semantics value at %s. %s", id, e.getMessage());
            }
        }
        throw new ParsingException("Non-constant memory semantics is not supported. " +
                "Found non-constant memory semantics at '%s'", id);
    }

    public String visitScope(String id, Expression expr) {
        if (expr instanceof IValue iValue) {
            try {
                return parseScope(iValue.getValue().intValue());
            } catch (Exception e) {
                throw new ParsingException("Illegal scope value at %s. %s", id, e.getMessage());
            }
        }
        throw new ParsingException("Non-constant scope is not supported. " +
                "Found non-constant scope at '%s'", id);
    }

    Set<String> parseSemantics(int value) {
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

    String parseScope(int value) {
        List<String> scopeTags = getScopeTags();
        if (value >= 0 && value < scopeTags.size()) {
            return scopeTags.get(value);
        }
        throw new ParsingException(String.format("Illegal scope value %d", value));
    }

    private Map<Integer, String> mkSemanticsMap() {
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
