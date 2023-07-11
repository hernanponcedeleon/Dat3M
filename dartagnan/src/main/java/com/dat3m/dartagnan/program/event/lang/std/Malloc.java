package com.dat3m.dartagnan.program.event.lang.std;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.HashSet;
import java.util.Set;

import static com.google.common.base.Preconditions.checkArgument;

/*
    NOTE: Although this event is no core event, it does not get compiled in the compilation pass.
    Instead, it will get replaced by a dedicated memory allocation pass.
    FIXME: Possibly make this event "core" due to the absence of compilation?
           A better alternative would be to reuse 'Local' but with a malloc expression as its right-hand side.
 */
public class Malloc extends AbstractEvent implements RegWriter, RegReader {

    protected Register register;
    protected Expression sizeExpr;

    public Malloc(Register register, Expression sizeExpr) {
        checkArgument(sizeExpr.getType() instanceof IntegerType, "Malloc with non-integer size %s.", sizeExpr);
        this.register = register;
        this.sizeExpr = sizeExpr;
        addTags(Tag.Std.MALLOC);
    }

    protected Malloc(Malloc other) {
        super(other);
        this.register = other.register;
        this.sizeExpr = other.sizeExpr;
    }

    public Expression getSizeExpr() {
        return sizeExpr;
    }

    public void setSizeExpr(Expression sizeExpr) {
        this.sizeExpr = sizeExpr;
    }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.register = reg;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        // TODO: Should this technically be an addr-dependency? Maybe an "other" dependency?
        return Register.collectRegisterReads(sizeExpr, Register.UsageType.DATA, new HashSet<>());
    }

    @Override
    public String defaultString() {
        return String.format("%s <- malloc(%s)", register, sizeExpr);
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.sizeExpr = sizeExpr.accept(exprTransformer);
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext context) {
        throw new UnsupportedOperationException("Cannot encode Malloc events.");
    }

    @Override
    public Malloc getCopy() {
        return new Malloc(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitMalloc(this);
    }
}