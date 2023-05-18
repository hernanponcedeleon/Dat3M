package com.dat3m.dartagnan.prototype.expr;

public interface ExpressionKind {

    String getSymbol();

    default String getLongName() {
        if (!(this instanceof Enum<?>)) {
            throw new UnsupportedOperationException("getLongName not implemented for " + this.getClass().getSimpleName());
        }
        return ((Enum<?>)this).name();
    }

    enum IntBinary implements ExpressionKind {
        ADD("+"), SUB("-"), MUL("*"),
        DIV("/"), UDIV("/"),
        MOD("%"), SREM("%"), UREM("%"),
        AND("&"), OR("|"), XOR("^"),
        L_SHIFT("<<"), R_SHIFT(">>>"), AR_SHIFT(">>");

        private final String symbol;
        IntBinary(String symbol) { this.symbol = symbol; }

        @Override
        public String getSymbol() { return this.symbol; }
    }

    enum IntUnary implements ExpressionKind {
        NEG("-");

        private final String symbol;
        IntUnary(String symbol) { this.symbol = symbol; }

        @Override
        public String getSymbol() { return this.symbol; }
    }

    enum IntCmp implements ExpressionKind {
        EQ("=="), NEQ("!="),
        GTE(">="), UGTE(">="),
        GT(">"), UGT(">"),
        LTE("<="), ULTE("<="),
        LT("<"), ULT("<");

        private final String symbol;
        IntCmp(String symbol) { this.symbol = symbol; }

        @Override
        public String getSymbol() { return this.symbol; }
    }

    enum Cast implements ExpressionKind {
        CONVERT("cast"), REINTERPRET("as");

        private final String symbol;
        Cast(String symbol) { this.symbol = symbol; }

        @Override
        public String getSymbol() { return this.symbol; }
    }

    enum BoolBinary implements ExpressionKind {
        AND("&&"), OR("||"), XOR("XOR"),
        IFF("<=>"), IMPLIES("=>");

        private final String symbol;
        BoolBinary(String symbol) { this.symbol = symbol; }

        @Override
        public String getSymbol() { return this.symbol; }
    }

    enum BoolUnary implements ExpressionKind {
        NOT("!");

        private final String symbol;
        BoolUnary(String symbol) { this.symbol = symbol; }

        @Override
        public String getSymbol() { return this.symbol; }
    }

    enum Leaf implements ExpressionKind {
        LITERAL("lit"),
        NONDET("nondet"),
        REGISTER("reg"),
        PARAMETER("param"),
        GLOBAL("global");

        private final String symbol;
        Leaf(String symbol) { this.symbol = symbol; }

        @Override
        public String getSymbol() { return this.symbol; }
    }

    enum Aggregates implements ExpressionKind {
        AGGREGATE("struct"),
        EXTRACT("extractvalue"),
        INSERT("insertvalue");

        private final String symbol;
        Aggregates(String symbol) { this.symbol = symbol; }

        @Override
        public String getSymbol() { return this.symbol; }
    }

    enum Pointers implements ExpressionKind {
        GEP("gep");

        private final String symbol;
        Pointers(String symbol) { this.symbol = symbol; }

        @Override
        public String getSymbol() { return this.symbol; }
    }

    enum Other implements ExpressionKind {
        ITE("ITE");

        private final String symbol;
        Other(String symbol) { this.symbol = symbol; }

        @Override
        public String getSymbol() { return this.symbol; }
    }
}
