package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.program.event.metadata.Metadata;

import java.util.List;
import java.util.stream.Collectors;

public final class TBAA {

    private TBAA() {}

    public static boolean canAlias(AccessTag x, AccessTag y) {
        final TypeOffset xAccess = new TypeOffset(x.base(), x.offset());
        final TypeOffset yAccess = new TypeOffset(y.base(), y.offset());

        TypeOffset xCheck = xAccess;
        while (xCheck != null) {
            if (xCheck.equals(yAccess)) {
                return true;
            }
            xCheck = getImmediateParent(xCheck);
        }

        TypeOffset yCheck = yAccess;
        while (yCheck != null) {
            if (yCheck.equals(xAccess)) {
                return true;
            }
            yCheck = getImmediateParent(yCheck);
        }

        return false;
    }

    public static TypeOffset getImmediateParent(TypeOffset typeOffset) {
        if (typeOffset.type() instanceof ScalarType scalarType) {
            return scalarType.parent() == null ? null: new TypeOffset(scalarType.parent(), typeOffset.offset());
        } else if (typeOffset.type() instanceof StructType structType) {
            for (int i = 0; i < structType.offsets().size(); i++) {
                final TypeOffset cur = structType.offsets().get(i);
                final TypeOffset next = (i + 1) < structType.offsets().size() ? structType.offsets().get(i + 1) : null;

                if (next == null || next.offset() < typeOffset.offset()) {
                    return new TypeOffset(cur.type(), cur.offset() - typeOffset.offset());
                }
            }
        }
        assert false;
        return null;
    }

    // ================================================================================================
    // Classes

    public record AccessTag(Type base, Type access, int offset) implements Metadata {
        @Override
        public String toString() {
            return String.format("TBAA.Access( %s, %s, %d )", base.getName(), access.getName(), offset);
        }
    }

    public interface Type {
        String getName();
    }

    public record TypeOffset(Type type, int offset) {
        @Override
        public String toString() {
            return String.format("( %s, %s )", type.getName(), offset);
        }
    }

    public record ScalarType(String name, Type parent) implements Type {
        @Override
        public String toString() {
            if (parent == null) {
                return name;
            }
            return String.format("{ %s, %s }", name, parent.getName());
        }

        @Override
        public String getName() {
            return name;
        }
    }

    public record StructType(String name, List<TypeOffset> offsets) implements Type {
        @Override
        public String getName() {
            return name;
        }

        @Override
        public String toString() {
            return String.format("{ %s, %s }", name,
                    offsets.stream().map(Object::toString).collect(Collectors.joining(", ")));
        }
    }
}
