package com.dat3m.dartagnan.programNew;

import com.dat3m.dartagnan.expr.Constant;
import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.ExpressionVisitor;
import com.dat3m.dartagnan.expr.Type;
import com.dat3m.dartagnan.expr.helper.LeafExpressionBase;
import com.dat3m.dartagnan.expr.types.PointerType;

/*
    A GlobalObject is a constant pointer to an object that lives in shared memory, like global variables and functions.
    Typically, such global objects are named, though LLVM does not require them to be!

    NOTES: - Though the address of a global object is constant, it is not a priori fixed.
           - Dynamically allocated memory also lives in shared memory, but may not have a constant pointer associated.
 */
public abstract class GlobalObject extends LeafExpressionBase<Type, ExpressionKind.Leaf> implements Constant {

    protected Program containingProgram;
    protected String name;
    protected Type contentType;
    protected boolean isThreadLocal = false;

    protected GlobalObject(Program program, String name, Type contentType) {
        super(PointerType.get(), ExpressionKind.Leaf.GLOBAL);
        this.containingProgram = program;
        this.name = name;
        this.contentType = contentType;
    }

    public Type getContentType() { return contentType; }

    public boolean isThreadLocal() { return isThreadLocal; }
    public void setIsThreadLocal(boolean value) { isThreadLocal = value; }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) { return visitor.visitGlobalObject(this); }
}
