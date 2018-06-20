package porthosc.languages.syntax.ytree.litmus;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.xgraph.process.XProcessId;
import porthosc.languages.syntax.ytree.definitions.YFunctionDefinition;
import porthosc.languages.syntax.ytree.statements.YCompoundStatement;
import porthosc.languages.syntax.ytree.types.YFunctionSignature;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;


/**
 * Temporary class representing explicitly defined processName in c-like code.
 */
public final class YProcessDefinition extends YFunctionDefinition {

    private final XProcessId processId;

    public YProcessDefinition(Origin origin, YFunctionSignature signature, YCompoundStatement body) {
        super(origin, signature, body);
        this.processId = new XProcessId(signature.getName());
    }

    public XProcessId getProcessId() {
        return processId;
    }

    @Override
    public <T> T accept(YtreeVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return getProcessId() + " " + getBody();
    }
}
