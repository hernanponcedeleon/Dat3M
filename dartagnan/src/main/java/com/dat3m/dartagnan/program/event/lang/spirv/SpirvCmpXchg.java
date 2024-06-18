package com.dat3m.dartagnan.program.event.lang.spirv;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWCmpXchgBase;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.Spirv.*;

public class SpirvCmpXchg extends RMWCmpXchgBase {

    private static final List<String> moStrength = List.of(RELAXED, RELEASE, ACQUIRE, ACQ_REL, SEQ_CST);

    private final String scope;
    private final String eqMo;
    private final Set<String> eqTags;

    public SpirvCmpXchg(Register register, Expression address, Expression cmp, Expression value, String scope, Set<String> eqTags, Set<String> neqTags) {
        super(register, address, cmp, value, true, getMoTag(neqTags));
        this.scope = scope;
        this.eqMo = getMoTag(eqTags);
        this.eqTags = mkEqTags(eqTags);
        addTags(scope);
        addTags(neqTags);
        validateMemoryOrder();
    }

    private SpirvCmpXchg(SpirvCmpXchg other) {
        super(other);
        this.scope = other.scope;
        this.eqMo = other.eqMo;
        this.eqTags = Set.copyOf(other.eqTags);
    }

    public Set<String> getEqTags() {
        return Set.copyOf(eqTags);
    }

    @Override
    public String defaultString() {
        return String.format("%s := spirv_cmpxchg[%s, %s, %s](%s, %s, %s)",
                resultRegister, eqMo, mo, scope, address, expectedValue, storeValue);
    }

    @Override
    public SpirvCmpXchg getCopy() {
        return new SpirvCmpXchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitSpirvCmpXchg(this);
    }

    private Set<String> mkEqTags(Set<String> eqTags) {
        Set<String> tags = new HashSet<>(getTags());
        tags.remove(mo);
        tags.addAll(eqTags);
        tags.add(scope);
        return Set.copyOf(tags);
    }

    private void validateMemoryOrder() {
        // TODO: It allows illegal combination eq RELEASE and neq ACQUIRE
        if (mo.equals(RELEASE) || mo.equals(ACQ_REL)) {
            throw new IllegalArgumentException(
                    String.format("%s cannot have unequal memory order '%s'",
                            getClass().getSimpleName(), mo));
        }
        if (moStrength.indexOf(mo) > moStrength.indexOf(eqMo)) {
            throw new IllegalArgumentException(
                    String.format("Unequal semantics '%s' is stronger than equal semantics '%s'", mo, eqMo));
        }
    }
}
