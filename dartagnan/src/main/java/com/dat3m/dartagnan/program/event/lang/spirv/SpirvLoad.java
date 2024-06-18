package com.dat3m.dartagnan.program.event.lang.spirv;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.LoadBase;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.Spirv.*;

public class SpirvLoad extends LoadBase {

    private final String scope;

    public SpirvLoad(Register register, Expression address, String scope, Set<String> tags) {
        super(register, address, getMoTag(tags));
        this.scope = scope;
        addTags(scope);
        addTags(tags);
        validate();
    }

    private SpirvLoad(SpirvLoad other) {
        super(other);
        this.scope = other.scope;
    }

    @Override
    public String defaultString() {
        return String.format("%s = spirv_load[%s, %s](%s)", resultRegister, mo, scope, address);
    }

    @Override
    public SpirvLoad getCopy() {
        return new SpirvLoad(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitSpirvLoad(this);
    }

    private void validate() {
        if (mo.equals(RELEASE) || mo.equals(ACQ_REL)) {
            throw new IllegalArgumentException(
                    String.format("%s cannot have memory order '%s'",
                            getClass().getSimpleName(), mo));
        }
        if (getTags().contains(SEM_AVAILABLE)) {
            throw new IllegalArgumentException(
                    String.format("%s cannot have semantics '%s'",
                            getClass().getSimpleName(), SEM_AVAILABLE));
        }
    }
}
