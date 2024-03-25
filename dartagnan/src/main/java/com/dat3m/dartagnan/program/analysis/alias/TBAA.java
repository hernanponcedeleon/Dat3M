package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.metadata.Metadata;
import org.sosy_lab.common.configuration.Configuration;

import java.util.List;
import java.util.stream.Collectors;

/*
    Type-based alias analysis that relies on type annotations provided by metadata (e.g., from LLVM).
    This analysis does NOT(!) use the IR's internal type system.
 */
public final class TBAA implements AliasAnalysis {

    private TBAA() {}

    public static AliasAnalysis fromConfig(Configuration config) {
        return new TBAA();
    }

    @Override
    public boolean mustAlias(MemoryCoreEvent a, MemoryCoreEvent b) {
        return false;
    }

    @Override
    public boolean mayAlias(MemoryCoreEvent a, MemoryCoreEvent b) {
        final AccessTag aTag = a.getMetadata(AccessTag.class);
        final AccessTag bTag = b.getMetadata(AccessTag.class);
        return aTag == null || bTag == null || canAlias(aTag, bTag);
    }

    // ================================================================================================
    // Helper methods

    public static boolean canAlias(AccessTag x, AccessTag y) {
        if (x == y) {
            return true;
        }
        final TypeOffset xAccess = new TypeOffset(x.base(), x.offset());
        final TypeOffset yAccess = new TypeOffset(y.base(), y.offset());

        final TypeOffset upper = x.offset() <= y.offset() ? xAccess : yAccess;
        TypeOffset lower = (upper == xAccess) ? yAccess : xAccess;
        while (lower.offset() > upper.offset()) {
            lower = getImmediateParent(lower);
            assert lower != null;
        }

        return lower.equals(upper);
    }

    public static TypeOffset getImmediateParent(TypeOffset typeOffset) {
        if (typeOffset.type() instanceof ScalarType scalarType) {
            final boolean isRoot = scalarType.parent() == null;
            return isRoot ? null : new TypeOffset(scalarType.parent(), typeOffset.offset());
        } else if (typeOffset.type() instanceof StructType structType) {
            for (int i = 0; i < structType.offsets().size(); i++) {
                final TypeOffset cur = structType.offsets().get(i);
                final TypeOffset next = (i + 1) < structType.offsets().size() ? structType.offsets().get(i + 1) : null;

                if (next == null || next.offset() > typeOffset.offset()) {
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
        public String getName() {
            return name;
        }

        @Override
        public String toString() {
            if (parent == null) {
                return name;
            }
            return String.format("TBAA.Scalar{ %s, %s }", name, parent.getName());
        }
    }

    public record StructType(String name, List<TypeOffset> offsets) implements Type {
        @Override
        public String getName() {
            return name;
        }

        @Override
        public String toString() {
            return String.format("TBAA.Struct{ %s, %s }", name,
                    offsets.stream().map(Object::toString).collect(Collectors.joining(", ")));
        }
    }
}
