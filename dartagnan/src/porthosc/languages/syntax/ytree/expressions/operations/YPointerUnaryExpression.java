package porthosc.languages.syntax.ytree.expressions.operations;//package porthosc.languages.syntax.ytree.expressions.unary;
//
//import porthosc.languages.syntax.ytree.expressions.YExpression;
//import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;
//
//// TODO: get rid of pointer arithmetics before constructing the Y-level!
//public class YPointerUnaryExpression extends YUnaryExpression {
//    public enum Kind implements YUnaryExpression.Kind {
//        Reference,   // &
//        Dereference, // * //called 'indirection' in C11 standard, p. 109
//        ;
//
//        @Override
//        public String toString() {
//            switch (this) {
//                case Reference:   return "&";
//                case Dereference: return "*";
//                default:
//                    throw new IllegalArgumentException(this.name());
//            }
//        }
//
//        @Override
//        public <T> T accept(YtreeVisitor<T> visitor) {
//            return visitor.visit(this);
//        }
//
//        @Override
//        public YPointerUnaryExpression createExpression(YExpression baseExpression) {
//            return new YPointerUnaryExpression(this, baseExpression);
//        }
//    }
//
//    private YPointerUnaryExpression(YPointerUnaryExpression.Kind kind, YExpression expression) {
//        super(kind, expression);
//    }
//
//    @Override
//    public YPointerUnaryExpression.Kind getOperator() {
//        return (YPointerUnaryExpression.Kind) super.getOperator();
//    }
//
//    @Override
//    public <T> T accept(YtreeVisitor<T> visitor) {
//        return visitor.visit(this);
//    }
//}
