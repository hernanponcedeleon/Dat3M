package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.sosy_lab.java_smt.api.*;

import static com.dat3m.dartagnan.GlobalSettings.getArchPrecision;

class ExpressionEncoder implements ExpressionVisitor<Formula> {

    private final FormulaManager formulaManager;
    private final BooleanFormulaManager booleanFormulaManager;
    private final IntegerFormulaManager integerFormulaManager;
    private final BitvectorFormulaManager bitvectorFormulaManager;
    private final Event event;

    public ExpressionEncoder(FormulaManager formulaManager, Event event) {
        this.formulaManager = formulaManager;
        booleanFormulaManager = formulaManager.getBooleanFormulaManager();
        integerFormulaManager = formulaManager.getIntegerFormulaManager();
        bitvectorFormulaManager = formulaManager.getBitvectorFormulaManager();
        this.event = event;
    }

    public BooleanFormula encodeBoolean(ExprInterface expression) {
        Formula formula = expression.visit(this);
        if (formula instanceof BooleanFormula) {
            return (BooleanFormula) formula;
        }
        if (formula instanceof BitvectorFormula) {
            int length = bitvectorFormulaManager.getLength((BitvectorFormula) formula);
            BitvectorFormula zero = bitvectorFormulaManager.makeBitvector(length, 0);
            return bitvectorFormulaManager.greaterThan((BitvectorFormula) formula, zero, false);
        }
        NumeralFormula.IntegerFormula zero = integerFormulaManager.makeNumber(0);
        return integerFormulaManager.greaterThan((NumeralFormula.IntegerFormula) formula, zero);
    }

    public Formula encodeInteger(ExprInterface expression) {
        Formula formula = expression.visit(this);
        if (formula instanceof BitvectorFormula || formula instanceof NumeralFormula.IntegerFormula) {
            return formula;
        }
        int precision = getArchPrecision();
        Formula one;
        Formula zero;
        if(precision > -1) {
            one = bitvectorFormulaManager.makeBitvector(precision, 1);
            zero = bitvectorFormulaManager.makeBitvector(precision, 0);
        } else {
            one = integerFormulaManager.makeNumber(1);
            zero = integerFormulaManager.makeNumber(0);
        }
        return booleanFormulaManager.ifThenElse((BooleanFormula) formula, one, zero);
    }

    @Override
    public Formula visit(Atom atom) {
        Formula lhs = encodeInteger(atom.getLHS());
        Formula rhs = encodeInteger(atom.getRHS());
        return atom.getOp().encode(lhs, rhs, formulaManager);
    }

    @Override
    public Formula visit(BConst bConst) {
        return booleanFormulaManager.makeBoolean(bConst.getValue());
    }

    @Override
    public Formula visit(BExprBin bBin) {
        BooleanFormula lhs = encodeBoolean(bBin.getLHS());
        BooleanFormula rhs = encodeBoolean(bBin.getRHS());
        return bBin.getOp().encode(lhs, rhs, formulaManager);
    }

    @Override
    public Formula visit(BExprUn bUn) {
        BooleanFormula inner = encodeBoolean(bUn.getInner());
        return bUn.getOp().encode(inner, formulaManager);
    }

    @Override
    public Formula visit(BNonDet bNonDet) {
        return booleanFormulaManager.makeVariable(Integer.toString(bNonDet.hashCode()));
    }

    @Override
    public Formula visit(IValue iValue) {
        return iValue.getPrecision() > 0
                ? bitvectorFormulaManager.makeBitvector(iValue.getPrecision(), iValue.getValue())
                : integerFormulaManager.makeNumber(iValue.getValue());
    }

    @Override
    public Formula visit(IExprBin iBin) {
        Formula lhs = encodeInteger(iBin.getLHS());
        Formula rhs = encodeInteger(iBin.getRHS());
        return iBin.getOp().encode(lhs, rhs, formulaManager);
    }

    @Override
    public Formula visit(IExprUn iUn) {
        Formula inner = encodeInteger(iUn.getInner());
        return iUn.getOp().encode(inner, formulaManager);
    }

    @Override
    public Formula visit(IfExpr ifExpr) {
        BooleanFormula guard = encodeBoolean(ifExpr.getGuard());
        Formula tBranch = encodeInteger(ifExpr.getTrueBranch());
        Formula fBranch = encodeInteger(ifExpr.getFalseBranch());
        return booleanFormulaManager.ifThenElse(guard, tBranch, fBranch);
    }

    @Override
    public Formula visit(INonDet iNonDet) {
        String name = Integer.toString(iNonDet.hashCode());
        if (iNonDet.getPrecision() < 0) {
            return integerFormulaManager.makeVariable(name);
        }
        return bitvectorFormulaManager.makeVariable(iNonDet.getPrecision(), name);
    }

    @Override
    public Formula visit(Register reg) {
        String name = reg.getName() + "(" + event.getGlobalId() + ")";
        if (reg.getPrecision() < 0) {
            return integerFormulaManager.makeVariable(name);
        }
        return bitvectorFormulaManager.makeVariable(reg.getPrecision(), name);
    }

    @Override
    public Formula visit(MemoryObject address) {
        return address.getPrecision() > 0
                ? bitvectorFormulaManager.makeBitvector(address.getPrecision(), address.getValue())
                : integerFormulaManager.makeNumber(address.getValue());
    }
}
