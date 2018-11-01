package dartagnan.asserts.utils;

public enum Op {
    EQ, NEQ, GTE, LTE, GT, LT;

    @Override
    public String toString() {
        switch(this){
            case EQ:
                return "==";
            case NEQ:
                return "!=";
            case GTE:
                return ">=";
            case LTE:
                return "<=";
            case GT:
                return ">";
            case LT:
                return "<";
        }
        return super.toString();
    }
}
