package porthosc.languages.syntax.ytree.types;

import com.google.common.collect.ImmutableList;
import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.YEntity;
import porthosc.languages.syntax.ytree.expressions.atomics.YParameter;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;


public class YFunctionSignature implements YEntity {

    private final String name;
    private final YType returnType;
    private final ImmutableList<YParameter> parameters;

    public YFunctionSignature(String name, YType returnType) {
        this(name, returnType, ImmutableList.of());
    }

    public YFunctionSignature(String name, YType returnType, ImmutableList<YParameter> parameters) {
        this.name = name;
        this.returnType = returnType;
        this.parameters = parameters;
    }

    public String getName() {
        return name;
    }

    public YType getReturnType() {
        return returnType;
    }

    public ImmutableList<YParameter> getParameters() {
        return parameters;
    }

    @Override
    public Origin origin() {
        return Origin.empty; //TODO: method signature must not be a YEntity! this is a common class used by all representations!
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("[").append(returnType).append(" ").append(name).append("(");
        for (int i = 0; i < parameters.size(); i++) {
            sb.append(parameters.get(i));
            if (i < parameters.size() - 1) {
                sb.append(",");
            }
        }
        sb.append(")]");
        return sb.toString();
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
