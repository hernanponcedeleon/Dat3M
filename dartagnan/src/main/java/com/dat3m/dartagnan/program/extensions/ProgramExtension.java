package com.dat3m.dartagnan.program.extensions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.ExpressionPrinter;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;

import java.util.Objects;

public sealed interface ProgramExtension {

    record None() implements ProgramExtension { }

    final class Litmus implements ProgramExtension {
        public enum SpecificationType { EXISTS, FORALL, NOT_EXISTS }

        private SpecificationType specType;
        private Expression spec;
        private Expression filter;
        // private final List<Expression> locations; // TODO

        public Litmus(SpecificationType specType, Expression spec, Expression filter) {
            this.specType = specType;
            this.spec = spec;
            this.filter = filter;
        }

        public static Litmus trivial() {
            final ExpressionFactory exprs = ExpressionFactory.getInstance();
            return new Litmus(SpecificationType.FORALL, exprs.makeTrue(), exprs.makeTrue());
        }

        public void setSpec(SpecificationType specType, Expression spec) {
            this.specType = specType;
            this.spec = spec;
        }

        public void setFilter(Expression filter) {
            this.filter = filter;
        }

        public SpecificationType specType() {
            return specType;
        }

        public Expression spec() {
            return spec;
        }

        public Expression filter() {
            return filter;
        }


        @Override
        public boolean equals(Object obj) {
            if (obj == this) return true;
            if (obj == null || obj.getClass() != this.getClass()) return false;
            var that = (Litmus) obj;
            return Objects.equals(this.specType, that.specType) &&
                    Objects.equals(this.spec, that.spec) &&
                    Objects.equals(this.filter, that.filter);
        }

        @Override
        public int hashCode() {
            return Objects.hash(specType, spec, filter);
        }

        @Override
        public String toString() {
            final ExpressionPrinter printer = new ExpressionPrinter(true);
            final StringBuilder sb = new StringBuilder();
            if (!(filter instanceof BoolLiteral lit && lit.getValue())) {
                sb.append("filter ").append(filter.accept(printer)).append("\n");
            }
            sb.append(specType.toString().toLowerCase()).append(" ").append(spec.accept(printer));

            return sb.toString();
        }
    }
}
