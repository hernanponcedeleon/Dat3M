package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryExpr;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.booleans.NonDetBool;
import com.dat3m.dartagnan.expression.integers.*;
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
        return expressions.makeBinary(atom.getLeft().accept(this), atom.getKind(), atom.getRight().accept(this));
    }

    @Override
    public Expression visit(BoolLiteral boolLiteral) {
        return boolLiteral;
    }

    @Override
    public Expression visit(BoolBinaryExpr bBin) {
        return expressions.makeBinary(bBin.getLeft().accept(this), bBin.getKind(), bBin.getRight().accept(this));
    }

    @Override
    public Expression visit(BoolUnaryExpr bUn) {
        return expressions.makeUnary(bUn.getKind(), bUn.getOperand().accept(this));
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
        return expressions.makeBinary(iBin.getLeft().accept(this), iBin.getKind(), iBin.getRight().accept(this));
    }

    @Override
    public Expression visit(IntUnaryExpr iUn) {
        return expressions.makeUnary(iUn.getKind(), iUn.getOperand().accept(this), iUn.getType());
    }

    @Override
    public Expression visit(ITEExpr iteExpr) {
        return expressions.makeITE(
                iteExpr.getCondition().accept(this),
                iteExpr.getTrueCase().accept(this),
                iteExpr.getFalseCase().accept(this));
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
