package com.dat3m.dartagnan.prototype.program;

import com.dat3m.dartagnan.prototype.expr.ExpressionVisitor;
import com.dat3m.dartagnan.prototype.expr.Type;

public class GlobalVariable extends GlobalObject {

    protected GlobalVariable(Program program, String name, Type contentType) {
        super(program, name, contentType);
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) { return visitor.visitGlobalVariable(this); }

    // TODO: Add extra attributes like "readonly/isConstant", "zero-initialized", and whatever could be useful
    //  from the LLVM code.


}
