package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.floats.FloatSizeCast;
import com.dat3m.dartagnan.expression.floats.IntToFloatCast;
import com.dat3m.dartagnan.expression.integers.FloatToIntCast;
import com.dat3m.dartagnan.expression.integers.IntSizeCast;
import com.dat3m.dartagnan.expression.misc.ConstructExpr;
import com.dat3m.dartagnan.expression.misc.ExtractExpr;
import com.dat3m.dartagnan.expression.misc.GEPExpr;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.program.Register;

import java.util.stream.Collectors;

public final class ExpressionPrinter implements ExpressionVisitor<String> {

    private final boolean printRegistersWithFunctionId;

    private ExpressionKind kind;

    // If not printing in program / global scope, then printing in function / local scope.
    public ExpressionPrinter(boolean globalScope) {
        this.printRegistersWithFunctionId = globalScope;
    }

    public String visit(Expression expr) {
        final ExpressionKind parentKind = this.kind;
        this.kind = expr.getKind();
        final String inner = expr.accept(this);
        final boolean direct = parentKind == null || parentKind == this.kind || expr.getOperands().isEmpty();
        final String result = direct ? inner : "(" + inner + ")";
        this.kind = parentKind;
        return result;
    }

    @Override
    public String visitExpression(Expression expr) {
        return expr.toString();
    }

    @Override
    public String visitBinaryExpression(BinaryExpression expr) {
        return visit(expr.getLeft()) + " " + expr.getKind() + " " + visit(expr.getRight());
    }

    @Override
    public String visitUnaryExpression(UnaryExpression expr) {
        return expr.getKind() + visit(expr.getOperand());
    }

    @Override
    public String visitIntSizeCastExpression(IntSizeCast expr) {
        final String opName = expr.isTruncation() ? "trunc" : (expr.preservesSign() ? "sext" : "zext");
        return String.format("%s %s to %s", opName, visit(expr.getOperand()), expr.getTargetType());
    }

    @Override
    public String visitFloatToIntCastExpression(FloatToIntCast expr) {
        final String opName = expr.isSigned() ? "fptosi" : "fptoui";
        return String.format("%s %s to %s", opName, expr.getOperand().toString(), expr.getTargetType());
    }

    @Override
    public String visitFloatSizeCastExpression(FloatSizeCast expr) {
        final String opName = expr.isTruncation() ? "trunc" : "ext";
        return String.format("%s %s to %s", visit(expr.getOperand()), opName, expr.getTargetType());
    }

    @Override
    public String visitIntToFloatCastExpression(IntToFloatCast expr) {
        final String opName = expr.isSigned() ? "sitofp" : "uitofp";
        return String.format("%s %s to %s", opName, visit(expr.getOperand()), expr.getTargetType());
    }

    @Override
    public String visitExtractExpression(ExtractExpr extract) {
        return visit(extract.getOperand()) + "[" + extract.getFieldIndex() + "]";
    }

    @Override
    public String visitConstructExpression(ConstructExpr expr) {
        return expr.getOperands().stream().map(this::visit).collect(Collectors.joining(", ", "{ ", " }"));
    }

    @Override
    public String visitGEPExpression(GEPExpr expr) {
        return expr.getOperands().stream().map(this::visit).collect(Collectors.joining(", ", "GEP(", ")"));
    }

    @Override
    public String visitITEExpression(ITEExpr expr) {
        return visit(expr.getCondition()) + " ? " + visit(expr.getTrueCase()) + " : " + visit(expr.getFalseCase());
    }

    @Override
    public String visitRegister(Register reg) {
        return printRegistersWithFunctionId ? reg.getFunction().getId() + ":" + reg.getName() : reg.toString();
    }
}
