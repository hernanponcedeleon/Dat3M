package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.ArrayList;

public abstract class ExprTransformer implements ExpressionVisitor<Expression> {

    protected final TypeFactory types = TypeFactory.getInstance();
    protected final ExpressionFactory expressions = ExpressionFactory.getInstance();

    @Override
    public Expression visit(Atom atom) {
        return expressions.makeBinary(atom.getLHS().accept(this), atom.getOp(), atom.getRHS().accept(this));
    }

    @Override
    public Expression visit(BoolLiteral boolLiteral) {
        return boolLiteral;
    }

    @Override
    public Expression visit(BoolBinaryExpr bBin) {
        return expressions.makeBinary(bBin.getLHS().accept(this), bBin.getOp(), bBin.getRHS().accept(this));
    }

    @Override
    public Expression visit(BoolUnaryExpr bUn) {
        return expressions.makeUnary(bUn.getOp(), bUn.getInner().accept(this));
    }

    @Override
    public Expression visit(NonDetBool nonDetBool) {
        return nonDetBool;
    }

    @Override
    public Expression visit(IntLiteral intLiteral) {
        return intLiteral;
    }

    @Override
    public Expression visit(IntBinaryExpr iBin) {
        return expressions.makeBinary(iBin.getLHS().accept(this), iBin.getOp(), iBin.getRHS().accept(this));
    }

    @Override
    public Expression visit(IntUnaryExpr iUn) {
        return expressions.makeUnary(iUn.getOp(), iUn.getInner().accept(this), iUn.getType());
    }

    @Override
    public Expression visit(ITEExpr iteExpr) {
        return expressions.makeITE(
                iteExpr.getGuard().accept(this),
                iteExpr.getTrueBranch().accept(this),
                iteExpr.getFalseBranch().accept(this));
    }

    @Override
    public Expression visit(NonDetInt iNonDet) {
        return iNonDet;
    }

    @Override
    public Expression visit(Register reg) {
        return reg;
    }

    @Override
    public Expression visit(MemoryObject address) {
        return address;
    }

    @Override
    public Expression visit(Location location) {
        return location;
    }

    @Override
    public Expression visit(Function function) { return function; }

    @Override
    public Expression visit(Construction construction) {
        final var arguments = new ArrayList<Expression>();
        for (final Expression argument : construction.getArguments()) {
            arguments.add(argument.accept(this));
        }
        return expressions.makeConstruct(arguments);
    }

    @Override
    public Expression visit(Extraction extraction) {
        Expression object = extraction.getObject().accept(this);
        return expressions.makeExtract(extraction.getFieldIndex(), object);
    }

    @Override
    public Expression visit(GEPExpression getElementPointer) {
        Expression base = getElementPointer.getBaseExpression().accept(this);
        final var offsets = new ArrayList<Expression>();
        for (Expression offset : getElementPointer.getOffsetExpressions()) {
            offsets.add(offset.accept(this));
        }
        return expressions.makeGetElementPointer(getElementPointer.getIndexingType(), base, offsets);
    }
}
