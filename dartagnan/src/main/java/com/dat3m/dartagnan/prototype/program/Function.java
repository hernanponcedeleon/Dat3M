package com.dat3m.dartagnan.prototype.program;

import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.prototype.expr.ExpressionKind;
import com.dat3m.dartagnan.prototype.expr.ExpressionVisitor;
import com.dat3m.dartagnan.prototype.expr.Type;
import com.dat3m.dartagnan.prototype.expr.helper.LeafExpressionBase;
import com.dat3m.dartagnan.prototype.expr.types.FunctionType;
import com.dat3m.dartagnan.prototype.program.utils.SymbolTable;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.List;

/*
    NOTES:
        (1) Functions may be declaration-only, in which case they do not have a body (no entry event).
            - Intrinsic functions (malloc, free, pthread_XYZ) are declaration-only.
            - External, non-intrinsic functions are declaration-only.
        (2) Intrinsic functions are marked as such. Those will be replaced by custom code generation.
 */
public class Function extends GlobalObject {

    private SymbolTable<Register> registerTable; // TODO: Do we need this?
    private List<Parameter> parameters; // List of parameter expressions, matching the function type.
    private Event entry; // NULL for declaration-only functions
    private boolean isIntrinsic;

    protected Function(Program program, String name, FunctionType funcType, boolean hasDefinition, boolean isIntrinsic) {
        super(program, name, funcType);
        // Invariant: isIntrinsic => not hasDefinition
        Preconditions.checkArgument(!(isIntrinsic && hasDefinition));

        this.parameters = new ArrayList<>(funcType.getParameterTypes().size());
        int counter = 0;
        for (Type paramType : funcType.getParameterTypes()) {
            this.parameters.add(new Parameter("param%" + counter, paramType));
            counter++;
        }
        this.entry = hasDefinition ? new Skip() : null;
        this.isIntrinsic = isIntrinsic;
        this.registerTable = new SymbolTable<>();
    }

    @Override
    public FunctionType getContentType() { return getFunctionType(); }

    public FunctionType getFunctionType() { return (FunctionType) super.getContentType(); }
    public Type getReturnType() { return getFunctionType().getReturnType(); }

    public List<Parameter> getParameters() { return parameters; }

    public boolean isIntrinsic() { return this.isIntrinsic; }
    public boolean hasDefinition() { return entry != null; }
    public Event getEntryEvent() { return entry; }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) { return visitor.visitFunction(this); }


    /*
        NOTES on implementation:
            - We can probably assign parameters to registers inside the entry block: (reg1 <- param1, reg2 <- param2, ...)
            - Inside the function body, we never need to reference the parameters (normalizes the code?!)
            - When inlining, we update the entry-block register assignments by replacing the parameter with the arguments.
     */
    public static class Parameter extends LeafExpressionBase<Type, ExpressionKind.Leaf> {
        private final String name;
        public String getName() { return this.name; }

        protected Parameter(String name, Type type) {
            super(type, ExpressionKind.Leaf.PARAMETER);
            this.name = name;
        }
        @Override
        public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) { return visitor.visitParameter(this); }
    }

}
