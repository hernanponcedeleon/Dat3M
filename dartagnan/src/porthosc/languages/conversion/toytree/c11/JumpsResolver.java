package porthosc.languages.conversion.toytree.c11;

import porthosc.languages.syntax.ytree.statements.YStatement;

import java.util.HashMap;


public class JumpsResolver {
    private final HashMap<String, YStatement> mapForward;
    private final HashMap<YStatement, String> mapBackward;

    // todo: make this immutable (builder, finish() )

    public JumpsResolver() {
        this.mapForward = new HashMap<>();
        this.mapBackward = new HashMap<>();
    }

    public void registerStatement(String label, YStatement statement) {
        assert !mapForward.containsKey(label) : label;
        assert !mapBackward.containsValue(label) : label;
        mapForward.put(label, statement);
        mapBackward.put(statement, label);
    }

    public YStatement tryGetStatementOrNull(String jumpLabel) {
        return mapForward.get(jumpLabel);
    }


    public String tryGetLabelOrNull(YStatement statement) {
        return mapBackward.get(statement);
    }
}
