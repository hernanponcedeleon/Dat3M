package com.dat3m.dartagnan.program.event.arch.opencl;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWExtremumBase;

public class OpenCLRMWExtremum extends RMWExtremumBase {

    public OpenCLRMWExtremum(Register register, Expression address, IntCmpOp op, Expression value, String mo) {
        super(register, address, op, value, mo);
        this.addTags(Tag.C11.ATOMIC);
    }

    private OpenCLRMWExtremum(OpenCLRMWExtremum other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := rmw_ext[%s](%s, %s, %s)\t###OPENCL", resultRegister, mo, storeValue, address, operator.getName());
    }

    @Override
    public OpenCLRMWExtremum getCopy() {
        return new OpenCLRMWExtremum(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitOpenCLRMWExtremum(this);
    }
}