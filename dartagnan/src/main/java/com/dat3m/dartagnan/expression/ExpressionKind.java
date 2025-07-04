package com.dat3m.dartagnan.expression;

public interface ExpressionKind {

    String getSymbol();
    default String getName() {
        if (!(this instanceof Enum<?>)) {
            throw new UnsupportedOperationException("getName not implemented for " + this.getClass().getSimpleName());
        }
        return ((Enum<?>)this).name();
    }

    enum Other implements ExpressionKind {
        LITERAL,
        CAST,
        NONDET,
        FUNCTION_ADDR,
        MEMORY_ADDR,
        FINAL_MEM_VAL,
        REGISTER,
        GEP,
        CONSTRUCT,
        ITE,
        EXTRACT,
        INSERT,
        BV_EXTRACT,
        BV_CONCAT,
        FORMULA;

        @Override
        public String getSymbol() {
            return getName();
        }
    }
}
