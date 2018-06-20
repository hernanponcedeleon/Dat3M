package porthosc.languages.syntax.ytree.definitions;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.statements.YCompoundStatement;
import porthosc.languages.syntax.ytree.types.YFunctionSignature;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;

import java.util.Objects;


public class YFunctionDefinition extends YDefinition {
    private final YFunctionSignature signature;
    private final YCompoundStatement body;

    public YFunctionDefinition(Origin origin, YFunctionSignature signature, YCompoundStatement body) {
        super(origin);
        this.signature = signature;
        this.body = body;
    }

    public YFunctionSignature getSignature() {
        return signature;
    }

    public YCompoundStatement getBody() {
        return body;
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return "<method_"+hashCode()+"_signature>"  + body;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof YFunctionDefinition)) return false;
        YFunctionDefinition that = (YFunctionDefinition) o;
        return Objects.equals(getBody(), that.getBody());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getBody());
    }
}
